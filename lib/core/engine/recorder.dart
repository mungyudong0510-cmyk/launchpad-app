import 'dart:async';
import 'dart:math';

import 'audio_engine.dart';

class RecordedHit {
  final String trackID;
  final int timeMs;
  final double volume;
  final double pitch;

  RecordedHit({
    required this.trackID,
    required this.timeMs,
    this.volume = 1.0,
    this.pitch = 1.0,
  });
}

class Recorder {
  final Engine engine;
  Recorder(this.engine);

  static const int _driverIntervalMs = 10;
  static const int _defaultBeatMs = 500;
  static const int _minimumLoopMs = 500;

  bool recording = false;
  bool cueing = false;

  List<RecordedHit> _take = [];
  int _loopLengthMs = 0;

  final Stopwatch _recordClock = Stopwatch();
  final Stopwatch _cueClock = Stopwatch();
  Timer? _loopDriver;
  int _nextHitIndex = 0;

  bool get hasTake => _take.isNotEmpty;

  void startRecording() {
    if (recording) return;
    stopCue();
    _take = [];
    _loopLengthMs = 0;
    recording = true;
    _recordClock
      ..reset()
      ..start();
  }

  void stopRecording() {
    if (!recording) return;
    recording = false;
    _recordClock.stop();
    _finalizeLoopLength();
  }

  void capture(String trackID, {double volume = 1.0, double pitch = 1.0}) {
    if (!recording) return;
    _take.add(RecordedHit(
      trackID: trackID,
      timeMs: _recordClock.elapsedMilliseconds,
      volume: volume,
      pitch: pitch,
    ));
  }

  void startCue() {
    if (cueing || recording) return;
    if (_take.isEmpty || _loopLengthMs <= 0) return;

    cueing = true;
    _nextHitIndex = 0;
    _cueClock
      ..reset()
      ..start();

    _playDueHits(0);
    _loopDriver = Timer.periodic(
      const Duration(milliseconds: _driverIntervalMs),
      (_) => _driveLoop(),
    );
  }

  void stopCue() {
    cueing = false;
    _loopDriver?.cancel();
    _loopDriver = null;
    _cueClock.stop();
    _nextHitIndex = 0;
  }

  void toggleCue() {
    if (cueing) {
      stopCue();
    } else {
      startCue();
    }
  }

  void clear() {
    stopCue();
    recording = false;
    _recordClock.stop();
    _take = [];
    _loopLengthMs = 0;
  }

  void _driveLoop() {
    if (!cueing) return;

    final elapsedMs = _cueClock.elapsedMilliseconds;
    _playDueHits(elapsedMs);

    if (elapsedMs >= _loopLengthMs) {
      _cueClock
        ..reset()
        ..start();
      _nextHitIndex = 0;
      _playDueHits(0);
    }
  }

  void _playDueHits(int elapsedMs) {
    while (_nextHitIndex < _take.length &&
        _take[_nextHitIndex].timeMs <= elapsedMs) {
      final hit = _take[_nextHitIndex];
      engine.playTrack(hit.trackID, volume: hit.volume, pitch: hit.pitch);
      _nextHitIndex++;
    }
  }

  void _finalizeLoopLength() {
    if (_take.isEmpty) {
      _loopLengthMs = 0;
      return;
    }

    final firstHitMs = _take.first.timeMs;
    _take = _take
        .map((hit) => RecordedHit(
              trackID: hit.trackID,
              timeMs: hit.timeMs - firstHitMs,
              volume: hit.volume,
              pitch: hit.pitch,
            ))
        .toList();

    final beatMs = _estimateBeatMs();
    final wrapGapMs = _estimateWrapGapMs(beatMs);
    final lastHitMs = _take.last.timeMs;
    final musicalTailMs = lastHitMs + wrapGapMs;

    _loopLengthMs = max(musicalTailMs, _minimumLoopMs);
  }

  int _estimateBeatMs() {
    if (_take.length < 2) return _defaultBeatMs;

    final gaps = <int>[];
    for (var i = 1; i < _take.length; i++) {
      final gap = _take[i].timeMs - _take[i - 1].timeMs;
      if (gap >= 80 && gap <= 2000) gaps.add(gap);
    }

    if (gaps.isEmpty) return _defaultBeatMs;

    gaps.sort();
    final medianGap = gaps[gaps.length ~/ 2];
    return medianGap.clamp(120, 1500).toInt();
  }

  int _estimateWrapGapMs(int fallbackGapMs) {
    if (_take.length < 2) return fallbackGapMs;

    final firstTrackID = _take.first.trackID;
    final lastTrackID = _take.last.trackID;
    final matchingGaps = <int>[];

    for (var i = 0; i < _take.length - 1; i++) {
      final from = _take[i];
      final to = _take[i + 1];
      if (from.trackID == lastTrackID && to.trackID == firstTrackID) {
        final gap = to.timeMs - from.timeMs;
        if (gap >= 80 && gap <= 2000) matchingGaps.add(gap);
      }
    }

    if (matchingGaps.isEmpty) return fallbackGapMs;

    matchingGaps.sort();
    final medianGap = matchingGaps[matchingGaps.length ~/ 2];
    return medianGap.clamp(120, 1500).toInt();
  }

  void dispose() {
    _loopDriver?.cancel();
    _recordClock.stop();
    _cueClock.stop();
  }
}
