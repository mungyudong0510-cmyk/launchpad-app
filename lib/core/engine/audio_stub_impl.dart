// Non-web stub — these functions are never called on Android/iOS,
// but must exist so the conditional import compiles on all platforms.
Future<void> webLoadSample(String trackID, String filePath) async {}
void webPlayTrack(String trackID, {double volume = 1.0}) {}
void webDispose() {}
