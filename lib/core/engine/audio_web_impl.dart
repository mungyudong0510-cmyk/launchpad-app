// Web-only implementation using the browser's built-in HTML Audio API.
// dart:html is only available on web, so this file must never be imported
// on non-web platforms — audio_engine.dart picks it via conditional import.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

final _webPlayers = <String, html.AudioElement>{};

Future<void> webLoadSample(String trackID, String filePath) async {
  final el = html.AudioElement(filePath)..preload = 'auto';
  _webPlayers[trackID] = el;
}

void webPlayTrack(String trackID, {double volume = 1.0}) {
  final el = _webPlayers[trackID];
  if (el == null) return;
  el.currentTime = 0;
  el.volume = volume.clamp(0.0, 1.0);
  el.play();
}

void webDispose() => _webPlayers.clear();
