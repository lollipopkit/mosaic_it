//! Video: detection on keyframes, ByteTrack across them, and the boxes to
//! redact in every frame (docs/design.md §9, M5).
//!
//! A frame becomes a keyframe when it differs from the last keyframe
//! anywhere on a coarse grid, or after `max_gap` frames. Frames between two
//! keyframes therefore show the same content as the first one, and its boxes
//! are held until the next keyframe. ByteTrack links detections across
//! keyframes so a track can be toggled as a whole, and so a keyframe where the
//! detector missed a tracked object is filled by interpolation.

use image::{GrayImage, RgbImage, imageops};
use serde::Serialize;
use trackforge::trackers::byte_track::{ByteTrack, ByteTrackParams};

use crate::detect::{Detection, Selection};
use crate::propagate::{FindOptions, find_similar};

#[derive(Debug, Clone)]
pub struct KeyframeOptions {
    /// Grid cell size in pixels; each cell is averaged before comparing.
    pub cell: u32,
    /// Largest change of a cell's mean grey level (0-255) still counted as
    /// the same content.
    pub threshold: u8,
    /// A keyframe at least this often, whatever the content.
    pub max_gap: usize,
}

impl Default for KeyframeOptions {
    fn default() -> Self {
        Self {
            cell: 8,
            threshold: 6,
            max_gap: 30,
        }
    }
}

/// Decides, frame by frame, which frames get a detection pass.
pub struct Keyframes {
    opts: KeyframeOptions,
    last: Option<(usize, GrayImage)>,
}

impl Keyframes {
    pub fn new(opts: KeyframeOptions) -> Self {
        Self { opts, last: None }
    }

    /// Whether frame `index` (increasing) is a keyframe.
    pub fn push(&mut self, index: usize, frame: &RgbImage) -> bool {
        let (w, h) = frame.dimensions();
        let c = self.opts.cell.max(1);
        let grid = imageops::grayscale(&imageops::thumbnail(frame, w.div_ceil(c), h.div_ceil(c)));
        let key = match &self.last {
            None => true,
            Some((at, prev)) => {
                index - at >= self.opts.max_gap
                    || prev.dimensions() != grid.dimensions()
                    || prev
                        .pixels()
                        .zip(grid.pixels())
                        .any(|(a, b)| a.0[0].abs_diff(b.0[0]) > self.opts.threshold)
            }
        };
        if key {
            self.last = Some((index, grid));
        }
        key
    }
}

#[derive(Debug, Clone, Serialize)]
pub struct Observation {
    pub frame: usize,
    /// xyxy in frame pixels.
    pub bbox: [f32; 4],
    pub score: f32,
}

/// One object across the video.
#[derive(Debug, Clone, Serialize)]
pub struct Track {
    pub id: u64,
    /// The class seen most often.
    pub class: String,
    /// Selected if any observation was.
    pub selection: Selection,
    /// At keyframes, increasing.
    pub observations: Vec<Observation>,
}

#[derive(Debug, Clone, Serialize)]
pub struct Timeline {
    pub frames: usize,
    pub keyframes: Vec<usize>,
    pub tracks: Vec<Track>,
}

/// An observation with the class and selection of its detection.
type Seen = (Observation, String, Selection);

/// Links keyframe detections into tracks.
pub struct Tracker {
    byte: ByteTrack,
    keyframes: Vec<usize>,
    tracks: Vec<(u64, Vec<Seen>)>,
    next_single: u64,
}

impl Default for Tracker {
    fn default() -> Self {
        Self::new()
    }
}

impl Tracker {
    pub fn new() -> Self {
        let mut p = ByteTrackParams::default();
        // Keep lost tracks for a few keyframes, so one missed detection is
        // bridged; matching uses the defaults.
        p.common.max_age = 5;
        Self {
            byte: ByteTrack::from_params(p),
            keyframes: Vec::new(),
            tracks: Vec::new(),
            // Detections the tracker does not keep get ids above its range.
            next_single: 1 << 48,
        }
    }

    /// Adds a keyframe's detections; hidden ones are ignored. Every other
    /// detection ends up in a track: those ByteTrack does not track (too
    /// low a score to start one) become single-observation tracks.
    pub fn add(&mut self, frame: usize, dets: Vec<(Detection, Selection)>) {
        debug_assert!(self.keyframes.last().is_none_or(|&k| k < frame));
        self.keyframes.push(frame);
        let dets: Vec<_> = dets.into_iter().filter(|(_, s)| *s != Selection::Hidden).collect();
        let input = dets
            .iter()
            .map(|(d, _)| {
                let [x0, y0, x1, y1] = d.bbox;
                ([x0, y0, x1 - x0, y1 - y0], d.score, d.class_id as i64)
            })
            .collect();
        let mut owner: Vec<Option<u64>> = vec![None; dets.len()];
        for t in self.byte.update(input) {
            if let Some(i) = t.det_ind.filter(|&i| i < dets.len() && owner[i].is_none()) {
                owner[i] = Some(t.track_id);
            }
        }
        for ((d, sel), id) in dets.into_iter().zip(owner) {
            let id = id.unwrap_or_else(|| {
                self.next_single += 1;
                self.next_single
            });
            let obs = (
                Observation {
                    frame,
                    bbox: d.bbox,
                    score: d.score,
                },
                d.class,
                sel,
            );
            match self.tracks.iter_mut().find(|(t, _)| *t == id) {
                Some((_, v)) => v.push(obs),
                None => self.tracks.push((id, vec![obs])),
            }
        }
    }

    pub fn finish(self, frames: usize) -> Timeline {
        let tracks = self
            .tracks
            .into_iter()
            .map(|(id, obs)| {
                let mut counts: Vec<(&str, usize)> = Vec::new();
                for (_, c, _) in &obs {
                    match counts.iter_mut().find(|(n, _)| n == c) {
                        Some((_, k)) => *k += 1,
                        None => counts.push((c, 1)),
                    }
                }
                // max_by_key keeps the last maximum; ties go to the first seen.
                let class = counts
                    .iter()
                    .rev()
                    .max_by_key(|(_, k)| *k)
                    .map_or("", |(c, _)| c)
                    .to_string();
                let any = |want| obs.iter().any(|(_, _, s)| *s == want);
                let selection = if any(Selection::Selected) {
                    Selection::Selected
                } else if any(Selection::Suggested) {
                    Selection::Suggested
                } else {
                    Selection::Review
                };
                Track {
                    id,
                    class,
                    selection,
                    observations: obs.into_iter().map(|(o, _, _)| o).collect(),
                }
            })
            .collect();
        Timeline {
            frames,
            keyframes: self.keyframes,
            tracks,
        }
    }
}

fn lerp(a: [f32; 4], b: [f32; 4], t: f32) -> [f32; 4] {
    std::array::from_fn(|i| a[i] + (b[i] - a[i]) * t)
}

impl Timeline {
    /// First keyframe after `frame`, or the end of the video.
    fn next_keyframe(&self, frame: usize) -> usize {
        let i = self.keyframes.partition_point(|&k| k <= frame);
        self.keyframes.get(i).copied().unwrap_or(self.frames)
    }

    /// The box of `track` in `frame`, if it is on screen.
    ///
    /// An observation holds until the next keyframe. Past that, inside a gap
    /// where the detector missed the tracked object, the box moves linearly
    /// to the next observation.
    pub fn box_at(&self, track: &Track, frame: usize) -> Option<[f32; 4]> {
        let obs = &track.observations;
        let i = obs.partition_point(|o| o.frame <= frame).checked_sub(1)?;
        let a = &obs[i];
        if frame < self.next_keyframe(a.frame) {
            return Some(a.bbox);
        }
        let b = obs.get(i + 1)?;
        let t = (frame - a.frame) as f32 / (b.frame - a.frame) as f32;
        Some(lerp(a.bbox, b.bbox, t))
    }

    /// Adds a track for a region the user marked in `frame`, followed
    /// keyframe by keyframe in both directions by template matching
    /// (`find_similar`, nearest match to the last position) until it is not
    /// found. `keyframe` loads a keyframe's image. Returns the track's index.
    pub fn add_manual<E>(
        &mut self,
        frame: usize,
        bbox: [f32; 4],
        class: &str,
        mut keyframe: impl FnMut(usize) -> Result<RgbImage, E>,
    ) -> Result<usize, E> {
        // Keyframe JPEGs and re-rendered text score a little below exact copies.
        let opts = FindOptions {
            min_score: 0.85,
            ..FindOptions::default()
        };
        let i0 = self.keyframes.partition_point(|&k| k <= frame).saturating_sub(1);
        let mut observations = vec![Observation {
            frame: self.keyframes.get(i0).copied().unwrap_or(0),
            bbox,
            score: 1.0,
        }];
        let start = keyframe(observations[0].frame)?;
        for dir in [1isize, -1] {
            let (mut img, mut b) = (start.clone(), bbox);
            let mut i = i0 as isize + dir;
            while let Some(&k) = usize::try_from(i).ok().and_then(|i| self.keyframes.get(i)) {
                let next = keyframe(k)?;
                let centre = |b: &[f32; 4]| ((b[0] + b[2]) / 2.0, (b[1] + b[3]) / 2.0);
                let (cx, cy) = centre(&b);
                let Some(m) = find_similar(&img, b, &next, None, &opts).into_iter().min_by(|p, q| {
                    let d = |m: &crate::propagate::Match| {
                        let (x, y) = centre(&m.bbox);
                        (x - cx).powi(2) + (y - cy).powi(2)
                    };
                    d(p).total_cmp(&d(q))
                }) else {
                    break;
                };
                observations.push(Observation {
                    frame: k,
                    bbox: m.bbox,
                    score: m.score,
                });
                (img, b) = (next, m.bbox);
                i += dir;
            }
        }
        observations.sort_by_key(|o| o.frame);
        let id = self.tracks.iter().map(|t| t.id).max().unwrap_or(0) + 1;
        self.tracks.push(Track {
            id,
            class: class.to_string(),
            selection: Selection::Selected,
            observations,
        });
        Ok(self.tracks.len() - 1)
    }

    /// Boxes in `frame` of the tracks `keep` accepts.
    pub fn boxes_at(&self, frame: usize, keep: impl Fn(&Track) -> bool) -> Vec<[f32; 4]> {
        self.tracks
            .iter()
            .filter(|t| keep(t))
            .filter_map(|t| self.box_at(t, frame))
            .collect()
    }
}

#[cfg(test)]
mod tests {
    use image::Rgb;

    use super::*;

    fn det(bbox: [f32; 4], score: f32) -> (Detection, Selection) {
        (
            Detection {
                class: "phone".into(),
                class_id: 2,
                score,
                bbox,
            },
            if score >= 0.5 {
                Selection::Selected
            } else {
                Selection::Review
            },
        )
    }

    #[test]
    fn keyframes_on_change_and_gap() {
        let mut k = Keyframes::new(KeyframeOptions {
            max_gap: 4,
            ..Default::default()
        });
        let plain = RgbImage::from_pixel(64, 64, Rgb([200, 200, 200]));
        let mut marked = plain.clone();
        for y in 10..18 {
            for x in 10..18 {
                marked.put_pixel(x, y, Rgb([0, 0, 0]));
            }
        }
        let frames = [&plain, &plain, &marked, &marked, &marked, &marked, &marked, &plain];
        let got: Vec<bool> = frames.iter().enumerate().map(|(i, f)| k.push(i, f)).collect();
        assert_eq!(got, [true, false, true, false, false, false, true, true]);
    }

    #[test]
    fn tracks_hold_and_bridge_a_missed_keyframe() {
        let mut t = Tracker::new();
        let b = |x: f32| [x, 100.0, x + 80.0, 120.0];
        t.add(0, vec![det(b(10.0), 0.9)]);
        t.add(10, vec![det(b(12.0), 0.9)]);
        t.add(20, vec![]); // missed
        t.add(30, vec![det(b(16.0), 0.9), det([0.0, 0.0, 5.0, 5.0], 0.2)]);
        let tl = t.finish(40);
        assert_eq!(tl.tracks.len(), 2, "{tl:?}");
        let main = &tl.tracks[0];
        assert_eq!(main.observations.len(), 3);
        assert_eq!(main.selection, Selection::Selected);
        assert_eq!(tl.box_at(main, 5), Some(b(10.0)));
        assert_eq!(tl.box_at(main, 15), Some(b(12.0)));
        // Missed at keyframe 20: interpolated between frames 10 and 30.
        assert_eq!(tl.box_at(main, 20), Some(b(14.0)));
        assert_eq!(tl.box_at(main, 39), Some(b(16.0)));
        // The weak detection stays, as a single-observation track.
        let weak = &tl.tracks[1];
        assert_eq!(weak.selection, Selection::Review);
        assert_eq!(tl.box_at(weak, 29), None);
        assert_eq!(tl.box_at(weak, 35), Some([0.0, 0.0, 5.0, 5.0]));
        assert_eq!(tl.boxes_at(35, |t| t.selection == Selection::Selected), vec![b(16.0)]);
    }

    #[test]
    fn manual_track_follows_scrolling_content() {
        // A text-like block scrolling up 30 px per keyframe, gone at the end.
        let page = |dy: i64| {
            RgbImage::from_fn(200, 300, |x, y| {
                let y = y as i64 + dy;
                let on = (60..140).contains(&x) && (150..170).contains(&y) && !(x / 4 + y as u32 / 3).is_multiple_of(3);
                if on { Rgb([20, 20, 20]) } else { Rgb([235, 235, 235]) }
            })
        };
        let frames = [page(0), page(30), page(60), page(400)];
        let mut tl = Tracker::new().finish(40);
        tl.keyframes = vec![0, 10, 20, 30];
        let i = tl
            .add_manual(15, [60.0, 120.0, 140.0, 140.0], "manual", |k| {
                Ok::<_, ()>(frames[k / 10].clone())
            })
            .unwrap();
        let t = &tl.tracks[i];
        // Drawn at frame 15 (keyframe 10), found back at 0 and on at 20,
        // lost at 30 where the block has scrolled away.
        assert_eq!(t.observations.iter().map(|o| o.frame).collect::<Vec<_>>(), [0, 10, 20]);
        assert!(
            (t.observations[0].bbox[1] - 150.0).abs() < 1.5,
            "{:?}",
            t.observations[0]
        );
        assert!(
            (t.observations[2].bbox[1] - 90.0).abs() < 1.5,
            "{:?}",
            t.observations[2]
        );
        assert_eq!(tl.box_at(t, 29).map(|b| b[1].round()), Some(90.0));
        assert_eq!(tl.box_at(t, 30), None);
    }

    #[test]
    fn track_ends_at_next_keyframe() {
        let mut t = Tracker::new();
        t.add(0, vec![det([0.0, 0.0, 50.0, 20.0], 0.9)]);
        t.add(8, vec![]);
        let tl = t.finish(20);
        let tr = &tl.tracks[0];
        assert!(tl.box_at(tr, 7).is_some());
        assert_eq!(tl.box_at(tr, 8), None);
    }
}
