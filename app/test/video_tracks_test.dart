import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:unseen/src/rust/api.dart';
import 'package:unseen/src/video_tracks.dart';

VideoTrack track(List<int> frames) => VideoTrack(
  className: 'phone',
  state: RegionState.selected,
  frames: Uint32List.fromList(frames),
);

void main() {
  test('a track spans to the keyframe after its last detection', () {
    const keyframes = [0, 10, 20, 30];
    expect(trackSpan(track([10, 20]), keyframes, 40), (10, 30));
    // Seen on the last keyframe: until the end of the video.
    expect(trackSpan(track([30]), keyframes, 40), (30, 40));
  });

  test('clock', () {
    expect(clock(0), '0:00.0');
    expect(clock(1.96), '0:01.9');
    expect(clock(75.25), '1:15.2');
  });
}
