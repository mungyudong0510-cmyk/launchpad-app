import 'dart:async';
import 'audio_engine.dart';

/// A single captured pad tap: which track, how far into the take it landed,
/// and the volume/pitch that were actually in effect at tap time (so loop
/// playback sounds exactly like the take, even if the pitch dial moves
/// afterwards).
class RecordedHit {
  final String trackID;
  final int timeMs; // offset from the start of the recording
  final double volume;
  final double pitch;

  RecordedHit({
    required this.trackID,
    required this.timeMs,
    this.volume = 1.0,
    this.pitch = 1.0,
  });
}

/// Records live pad taps into a take, then loops that take back on a
/// repeating cycle. Loop playback runs alongside live pad taps rather than
/// blocking them — both funnel through the same [Engine], so a live tap and
/// a looped hit on the same pad just retrigger the same player.
class Recorder {
  final Engine engine;
  Recorder(this.engine);

  static const int _driverIntervalMs = 10; // loop-playback scan resolution

  bool recording = false;
  bool looping = false;

  List<RecordedHit> _take = [];
  int _loopLengthMs = 0;

  final Stopwatch _recordClock = Stopwatch();

  Timer? _loopDriver;
  int _loopElapsedMs = 0; // ms into the current loop cycle
  int _nextHitIndex = 0; // walks _take in order as the loop plays

  bool get hasTake => _take.isNotEmpty;

  /// Starts capturing taps. Any previous take is discarded once this is
  /// called — there is one take at a time. Stops loop playback first, since
  /// recording a new take while the old one is looping would mix the two.
  void startRecording() {
    if (recording) return;
    stopLoop();
    _take = [];
    recording = true;
    _recordClock
      ..reset()
      ..start();
  }

  /// Stops capturing. The take is kept (even if empty) so [hasTake] reflects
  /// whether there's anything to loop.
  void stopRecording() {
    if (!recording) return;
    recording = false;
    _recordClock.stop();
    _loopLengthMs = _recordClock.elapsedMilliseconds;
  }

  /// Called by a pad on tap-down. No-ops when not recording, so pads can
  /// always call this unconditionally.
  void capture(String trackID, {double volume = 1.0, double pitch = 1.0}) {
    if (!recording) return;
    _take.add(RecordedHit(
      trackID: trackID,
      timeMs: _recordClock.elapsedMilliseconds,
      volume: volume,
      pitch: pitch,
    ));
  }

  /// Starts looping the current take. No-ops if there's nothing recorded
  /// yet, or the loop is zero-length (e.g. stopped instantly after starting).
  void startLoop() {
    if (looping || recording) return;
    if (_take.isEmpty || _loopLengthMs <= 0) return;
    looping = true;
    _loopElapsedMs = 0;
    _nextHitIndex = 0;
    _loopDriver = Timer.periodic(
      const Duration(milliseconds: _driverIntervalMs),
      (_) => _driveLoop(),
    );
  }

  void stopLoop() {
    looping = false;
    _loopDriver?.cancel();
    _loopDriver = null;
  }

  void toggleLoop() {
    if (looping) {
      stopLoop();
    } else {
      startLoop();
    }
  }

  void _driveLoop() {
    _loopElapsedMs += _driverIntervalMs;

    // Fire every hit whose recorded offset falls within the slice of the
    // loop we just crossed. Walking an index forward (rather than filtering
    // the whole list each tick) keeps this cheap even for long takes.
    while (_nextHitIndex < _take.length &&
        _take[_nextHitIndex].timeMs <= _loopElapsedMs) {
      final hit = _take[_nextHitIndex];
      engine.playTrack(hit.trackID, volume: hit.volume, pitch: hit.pitch);
      _nextHitIndex++;
    }

    if (_loopElapsedMs >= _loopLengthMs) {
      _loopElapsedMs = 0;
      _nextHitIndex = 0;
    }
  }

  void dispose() {
    _loopDriver?.cancel();
    _recordClock.stop();
  }
}
