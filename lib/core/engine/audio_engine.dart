import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// Picks audio_web_impl.dart on Chrome, audio_stub_impl.dart on Android/iOS.
import 'audio_stub_impl.dart' if (dart.library.html) 'audio_web_impl.dart';


class Engine {
  // Native SoundPool channel — Android only.
  static const MethodChannel _channel = MethodChannel('launchpad_app/sound_pool');

  final Map<String, String> _loadedAssets = {};
  final Map<String, Future<void>> _loadingAssets = {};

  Future<void> loadSample(String trackID, String filePath) async {
    if (kIsWeb) {
      // Web: use browser HTML Audio API via audio_web_impl.dart
      return webLoadSample(trackID, filePath);
    }

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
  void playTrack(String trackID, {double? volume}) {
    if (kIsWeb) {
      webPlayTrack(trackID, volume: volume ?? 1.0);
      return;
    }

    final loading = _loadingAssets[trackID];
    if (loading != null) {
      unawaited(loading.then((_) {
        _playLoaded(trackID, volume: volume);
      }));
      return;
    }

    _playLoaded(trackID, volume: volume);
  }

  void _playLoaded(String trackID, {double? volume}) {
    if (_loadedAssets[trackID] == null) return;

    unawaited(_channel.invokeMethod<void>('play', {
      'trackID': trackID,
      'volume': (volume ?? 1.0).clamp(0.0, 1.0).toDouble(),
    }).catchError((e) {
      debugPrint('Engine: could not play "$trackID": $e');
    }));
  }

  void dispose() {
    if (kIsWeb) {
      webDispose();
      return;
    }
    unawaited(_channel.invokeMethod<void>('dispose'));
    _loadedAssets.clear();
    _loadingAssets.clear();
  }
}
