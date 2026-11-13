import 'rust/api.dart';

/// Frames `[start, end)` where [track] can be on screen: from its first
/// detection to the keyframe after its last one (boxes hold until then).
(int, int) trackSpan(VideoTrack track, List<int> keyframes, int frames) {
  final first = track.frames.first, last = track.frames.last;
  final next = keyframes.firstWhere((k) => k > last, orElse: () => frames);
  return (first, next);
}

/// `m:ss.d` for a time in seconds.
String clock(double seconds) {
  final tenths = (seconds * 10).floor();
  final m = tenths ~/ 600, s = (tenths ~/ 10) % 60, d = tenths % 10;
  return '$m:${'$s'.padLeft(2, '0')}.$d';
}
