import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';
import '../models/pattern.dart';

class Engine {
  final Map<String, AudioPlayer> _players = {};
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

  AudioPlayer _playerFor(String trackID) =>
      _players.putIfAbsent(trackID, () => AudioPlayer());

  Future<void> init(Pattern pattern) async {
    for (final track in pattern.tracks) {
      final sample = track.sample;
      if (sample != null) {
        await loadSample(track.id, sample.filePath);
      } else {
        _playerFor(track.id);
      }
    }
  }

  Future<void> loadSample(String trackID, String filePath) async {
    final player = _playerFor(trackID);
    try {
      await player.setAsset(filePath);
      await _primePlayer(player);
    } catch (e) {
      debugPrint('Error loading sample for track $trackID: $e');
    }
  }

  Future<void> _primePlayer(AudioPlayer player) async {
    try {
      final originalVolume = player.volume;
      await player.setVolume(0.0);
      await player.seek(Duration.zero);
      await player.play();
      await player.pause();
      await player.seek(Duration.zero);
      await player.setVolume(originalVolume);
    } catch (e) {
      debugPrint('Error priming player: $e');
    }
  }

  Future<void> playTrack(String trackID, {double? volume, double? pitch}) async {
    final player = _players[trackID];
    if (player == null) return;
    try {
      final setup = <Future<void>>[
        if (volume != null) player.setVolume(volume.clamp(0.0, 1.0)),
        if (pitch != null) player.setPitch(pitch.clamp(0.25, 4.0)),
      ];
      if (setup.isNotEmpty) await Future.wait(setup);
      await player.seek(Duration.zero);
      unawaited(player.play());
    } catch (e) {
      debugPrint('Engine: could not play "$trackID": $e');
    }
  }

  Future<void> stopTrack(String trackID) async {
    await _players[trackID]?.stop();
  }

  Future<void> setTrackVolume(String trackID, double volume) async {
    await _players[trackID]?.setVolume(volume.clamp(0.0, 1.0));
  }

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
          pitch: (1.0 + step.pitch).clamp(0.25, 4.0),
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
    for (final player in _players.values) {
      player.stop();
    }
  }

  void dispose() {
    _timer?.cancel();
    for (final player in _players.values) {
      player.dispose();
    }
    _players.clear();
  }
}