import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/pattern.dart';

class Engine {
  static const MethodChannel _channel = MethodChannel('launchpad_app/sound_pool');

  final Map<String, String> _loadedAssets = {};
  final Map<String, Future<void>> _loadingAssets = {};
  bool playing = false;
  int currentStep = 0;
  double _bpm = 120.0;
  double get bpm => _bpm;
  int get stepDurationMs => (60000 / (_bpm * 4)).round();

  Timer? _timer;
  final Stopwatch _clock = Stopwatch();
  int _nextStepTargetMs = 0;

  void setBpm(double newBpm) {
    _bpm = newBpm.clamp(20.0, 300.0);
  }

  Future<void> init(Pattern pattern) async {
    for (final track in pattern.tracks) {
      final sample = track.sample;
      if (sample != null) {
        await loadSample(track.id, sample.filePath);
      }
    }
  }

  Future<void> loadSample(String trackID, String filePath) async {
    if (_loadedAssets[trackID] == filePath) return;

    final currentLoad = _loadingAssets[trackID];
    if (currentLoad != null) return currentLoad;

    final loadFuture = _channel.invokeMethod<void>('load', {
      'trackID': trackID,
      'filePath': filePath,
    }).then((_) {
      _loadedAssets[trackID] = filePath;
    }).catchError((e) {
      debugPrint('Error loading sample for track $trackID: $e');
    }).whenComplete(() {
      _loadingAssets.remove(trackID);
    });

    _loadingAssets[trackID] = loadFuture;
    return loadFuture;
  }

  // fire-and-forget everything so tap -> sound is instant
  void playTrack(String trackID, {double? volume, double? pitch}) {
    final loading = _loadingAssets[trackID];
    if (loading != null) {
      unawaited(loading.then((_) {
        _playLoaded(trackID, volume: volume, pitch: pitch);
      }));
      return;
    }

    _playLoaded(trackID, volume: volume, pitch: pitch);
  }

  void _playLoaded(String trackID, {double? volume, double? pitch}) {
    if (_loadedAssets[trackID] == null) return;

    unawaited(_channel.invokeMethod<void>('play', {
      'trackID': trackID,
      'volume': (volume ?? 1.0).clamp(0.0, 1.0).toDouble(),
      'pitch': (pitch ?? 1.0).clamp(0.5, 2.0).toDouble(),
    }).catchError((e) {
      debugPrint('Engine: could not play "$trackID": $e');
    }));
  }

  // pre-apply pitch when dial changes so it's ready before next tap
  void preSetPitch(String trackID, double pitch) {}

  Future<void> stopTrack(String trackID) async {
    await _channel.invokeMethod<void>('stop', {'trackID': trackID});
  }

  Future<void> setTrackVolume(String trackID, double volume) async {}

  void start(Pattern pattern) {
    if (playing) return;
    playing = true;
    currentStep = 0;
    _clock
      ..reset()
      ..start();
    _nextStepTargetMs = 0;
    _scheduleTick(pattern);
  }

  void _scheduleTick(Pattern pattern) {
    if (!playing) return;
    final delay = _nextStepTargetMs - _clock.elapsedMilliseconds;
    _timer = Timer(Duration(milliseconds: delay > 0 ? delay : 0), () {
      _tick(pattern);
    });
  }

  void _tick(Pattern pattern) {
    if (!playing) return;
    for (final track in pattern.tracks) {
      if (track.muted) continue;
      if (track.steps.isEmpty) continue;
      final step = track.steps[currentStep];
      if (step.active) {
        playTrack(
          track.id,
          volume: (step.volume * track.volume).clamp(0.0, 1.0),
          pitch: (1.0 + step.pitch).clamp(0.5, 2.0),
        );
      }
    }
    currentStep = (currentStep + 1) % pattern.stepCount;
    _nextStepTargetMs += stepDurationMs;
    _scheduleTick(pattern);
  }

  void stop() {
    playing = false;
    currentStep = 0;
    _timer?.cancel();
    _clock.stop();
    unawaited(_channel.invokeMethod<void>('stopAll'));
  }

  void dispose() {
    _timer?.cancel();
    unawaited(_channel.invokeMethod<void>('dispose'));
    _loadedAssets.clear();
    _loadingAssets.clear();
  }
}
