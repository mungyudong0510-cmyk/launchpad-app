import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';


class Engine {
  static const MethodChannel _channel = MethodChannel('launchpad_app/sound_pool');

  final Map<String, String> _loadedAssets = {};
  final Map<String, Future<void>> _loadingAssets = {};

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
  void playTrack(String trackID, {double? volume}) {
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
    unawaited(_channel.invokeMethod<void>('dispose'));
    _loadedAssets.clear();
    _loadingAssets.clear();
  }
}
