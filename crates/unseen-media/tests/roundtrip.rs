#![cfg(any(target_vendor = "apple", target_os = "android"))]

use image::{Rgb, RgbImage};
use unseen_media::{Timestamp, VideoReader, VideoWriter, has_audio};

#[test]
fn write_then_read() {
    let dir = std::env::temp_dir().join(format!("unseen-media-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let path = dir.join("rt.mp4");
    let (w, h) = (320, 240);
    // A block moving right on grey, 30 fps.
    let frame = |i: u32| {
        let mut img = RgbImage::from_pixel(w, h, Rgb([128, 128, 128]));
        for y in 100..140 {
            for x in 20 + i * 8..60 + i * 8 {
                img.put_pixel(x, y, Rgb([220, 30, 30]));
            }
        }
        img
    };
    let mut wr = VideoWriter::create(&path, w, h, None).unwrap();
    for i in 0..20 {
        wr.write(
            &frame(i),
            Timestamp {
                value: i as i64,
                timescale: 30,
            },
        )
        .unwrap();
    }
    wr.finish().unwrap();

    assert!(!has_audio(&path).unwrap());
    let rd = VideoReader::open(&path).unwrap();
    assert_eq!(rd.size(), (w, h));
    assert!((rd.fps() - 30.0).abs() < 0.5, "fps {}", rd.fps());
    let frames: Vec<_> = rd.collect::<Result<_, _>>().unwrap();
    assert_eq!(frames.len(), 20);
    for (i, f) in frames.iter().enumerate() {
        assert!(
            (f.time.seconds() - i as f64 / 30.0).abs() < 1e-3,
            "frame {i} at {}",
            f.time.seconds()
        );
        // Lossy, so compare colours loosely: inside the block and outside it.
        let inside = f.image.get_pixel(40 + i as u32 * 8, 120).0;
        let outside = f.image.get_pixel(300, 20).0;
        assert!(inside[0] > 180 && inside[1] < 80, "frame {i} inside {inside:?}");
        assert!(
            outside.iter().all(|&c| (110..150).contains(&c)),
            "frame {i} outside {outside:?}"
        );
    }
    std::fs::remove_dir_all(&dir).unwrap();
}

#[test]
fn missing_file_is_an_error() {
    assert!(VideoReader::open(std::path::Path::new("/nonexistent/x.mp4")).is_err());
}

/// Decodes `UNSEEN_TEST_VIDEO` (expected size `UNSEEN_TEST_VIDEO_SIZE`,
/// e.g. 720x1280) when set; skipped otherwise.
#[test]
fn decode_given_file() {
    let Ok(path) = std::env::var("UNSEEN_TEST_VIDEO") else {
        eprintln!("skip: set UNSEEN_TEST_VIDEO");
        return;
    };
    let rd = VideoReader::open(path.as_ref()).unwrap();
    let size = rd.size();
    if let Ok(s) = std::env::var("UNSEEN_TEST_VIDEO_SIZE") {
        let (w, h) = s.split_once('x').unwrap();
        assert_eq!(size, (w.parse().unwrap(), h.parse().unwrap()));
    }
    let (mut n, mut last) = (0, -1.0);
    for f in rd {
        let f = f.unwrap();
        assert_eq!(f.image.dimensions(), size);
        let t = f.time.seconds();
        assert!(t > last, "frame {n} at {t} after {last}");
        (n, last) = (n + 1, t);
    }
    assert!(n > 0);
    eprintln!("{path}: {n} frames, {size:?}, last at {last:.3}s");
}

/// Copies the audio of `UNSEEN_TEST_AUDIO` (any file with an audio track)
/// into a new video when set; skipped otherwise.
#[test]
fn audio_is_copied_when_asked() {
    let Ok(src) = std::env::var("UNSEEN_TEST_AUDIO") else {
        eprintln!("skip: set UNSEEN_TEST_AUDIO");
        return;
    };
    let src = std::path::Path::new(&src);
    assert!(has_audio(src).unwrap());
    let dir = std::env::temp_dir().join(format!("unseen-audio-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let out = dir.join("with-audio.mp4");
    let mut wr = VideoWriter::create(&out, 160, 120, Some(src)).unwrap();
    // Two seconds of frames, so the audio has video to sit beside.
    for i in 0..60 {
        let img = RgbImage::from_pixel(160, 120, Rgb([(i * 4) as u8, 90, 160]));
        wr.write(
            &img,
            Timestamp {
                value: i,
                timescale: 30,
            },
        )
        .unwrap();
    }
    wr.finish().unwrap();
    assert!(has_audio(&out).unwrap());
    assert_eq!(VideoReader::open(&out).unwrap().count(), 60);
    std::fs::remove_dir_all(&dir).unwrap();
}
