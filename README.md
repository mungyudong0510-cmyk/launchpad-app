# 🎛️ Launchpad App (DJ BQK)

A dark-themed, low-latency drum pad / launchpad app built with Flutter. Tap the 4×4 grid to fire samples, record a live loop by playing along, and cue it back on repeat — with automatic tempo detection so you never have to set a BPM by hand.

> Status: active work-in-progress. The pad grid, volume dial, and live loop recorder are functional; a step-sequencer data model exists in the codebase but isn't wired into the UI yet.

---

## Table of Contents

- [Features](#features)
- [How It Works](#how-it-works)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Adding Your Own Sounds](#adding-your-own-sounds)
- [Platform Support](#platform-support)
- [Architecture Notes](#architecture-notes)
- [Roadmap](#roadmap)
- [Contributing](#contributing)

---

## Features

- **4×4 sample pad grid** — 16 velocity-styled pads per scene, with a glowing press animation for tactile feedback.
- **Two switchable scenes (SC1 / SC2)** — 32 total pad slots, split across two sample banks you can flip between instantly.
- **Native low-latency audio on Android** — pads are driven by a Kotlin `SoundPool` bridge (via `MethodChannel`) instead of a general-purpose audio plugin, so tap-to-sound latency stays tight.
- **Browser playback on Web** — an alternate `dart:html` `AudioElement`-based engine kicks in automatically when running on Flutter Web.
- **Live loop recording ("Loop")** — hit **Loop**, play a pattern on the pads, hit **Loop** again to stop. Every hit's track ID, timestamp, and volume are captured.
- **Auto-tempo loop cueing ("CUE")** — hit **CUE** to play your recorded take back on repeat. The recorder estimates the beat spacing and the "wrap" gap from your own performance (median gap between hits, and between the last hit and the first), so the loop feels musical without you tapping in a BPM.
- **Per-pad volume + master volume dial** — a custom vertical drag-to-adjust dial (with drag-sensitivity tuning) controls playback volume for every pad in the active scene.
- **Clear button** — resets the current take and master volume in one tap.
- **Custom branded UI** — dark, near-black canvas with a small animated "DJ BQK" logo mark and neon-accented function buttons (pink / cyan / amber).

---

## How It Works

The app is a single `HomeScreen` that composes four moving parts:

1. **`Engine`** (`lib/core/engine/audio_engine.dart`) — a thin, platform-aware wrapper around sample loading/playback. On Android/iOS it talks to native code over a `MethodChannel`; on Web it swaps in an HTML5 `<audio>`-backed implementation via a conditional import, so the same call site (`engine.playTrack(...)`) works everywhere.
2. **`Recorder`** (`lib/core/engine/recorder.dart`) — captures pad hits while `recording` is on, then estimates a musical loop length from the gaps between your hits and replays them on a lightweight polling `Timer` while `cueing` is on.
3. **`ScenePads1` / `ScenePads2`** (`lib/widgets/`) — declarative 4×4 grids of `PadButton`s, each pre-loading its sample on first frame and firing `engine.playTrack()` + `recorder.capture()` on tap-down for the lowest possible input-to-sound delay.
4. **`HomeScreen`** (`lib/screens/home_screen.dart`) — owns the shared `Engine`/`Recorder` instances, the active scene, and the master volume, and lays out the pad grid, volume dial, and function-button row (SC1, SC2, Loop, CUE, Clear).

On Android, audio actually plays through `MainActivity.kt`, which maintains a single `SoundPool` (16 concurrent streams), loads each pad's asset the first time it's tapped, and queues plays that arrive before loading finishes so nothing gets dropped.

---

## Project Structure

```
launchpad-app/
├── lib/
│   ├── main.dart                     # App entry point (MaterialApp, dark theme)
│   ├── core/
│   │   ├── engine/
│   │   │   ├── audio_engine.dart     # Platform-agnostic Engine (loadSample/playTrack/dispose)
│   │   │   ├── audio_web_impl.dart   # Web audio backend (dart:html AudioElement)
│   │   │   ├── audio_stub_impl.dart  # No-op stub compiled in on non-web platforms
│   │   │   └── recorder.dart         # Live loop capture + tempo-aware cue playback
│   │   └── models/
│   │       ├── sample.dart           # Sample metadata model (id, name, filePath, category, instrument)
│   │       ├── step.dart             # Sequencer step model (active/volume/pitch) — not yet wired to UI
│   │       └── track.dart            # Track model combining a Sample with a list of Steps
│   ├── screens/
│   │   └── home_screen.dart          # Main (and only) screen; wires everything together
│   └── widgets/
│       ├── pad_button.dart           # Single sample pad (press animation, load, play, capture)
│       ├── scene_pads_1.dart         # 4×4 grid for Scene 1
│       ├── scene_pads_2.dart         # 4×4 grid for Scene 2
│       ├── function_button.dart      # Circular toggle/tap buttons (SC1, SC2, Loop, CUE, Clear)
│       ├── volume_dial.dart          # Vertical drag-to-adjust volume control
│       └── dj_bqk_logo.dart          # Small animated brand logo widget
├── android/
│   └── app/src/main/kotlin/.../MainActivity.kt   # Native SoundPool bridge (load/play/stop/dispose)
├── assets/
│   ├── images/                       # Logo/branding assets
│   └── sounds/
│       ├── scene1/                   # 16 samples for Scene 1 (kicks, snares, hats, claps, fx)
│       └── scene2/                   # 16 samples for Scene 2
├── test/
│   └── widget_test.dart              # ⚠️ default Flutter counter-app template — not yet updated for this app
├── ios/, macos/, linux/, windows/, web/   # Standard Flutter platform scaffolding
├── pubspec.yaml
└── analysis_options.yaml
```

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart SDK `^3.11.5`, per `pubspec.yaml`) on the stable channel.
- A configured target: Android Studio + an emulator or device for Android, Xcode for iOS/macOS, or just a modern browser for Web.
- Run `flutter doctor` to confirm your environment is set up correctly.

### Installation

```bash
# Clone the repository
git clone https://github.com/mungyudong0510-cmyk/launchpad-app.git
cd launchpad-app

# Install Dart/Flutter dependencies
flutter pub get
```

### Running the app

```bash
# List available devices/emulators
flutter devices

# Run on a connected device or emulator (Android/iOS/desktop)
flutter run

# Run in a browser (uses the HTML5 audio backend)
flutter run -d chrome
```

### Building a release

```bash
flutter build apk        # Android APK
flutter build appbundle  # Android App Bundle (for Play Store)
flutter build ios        # iOS (requires macOS + Xcode)
flutter build web        # Static web build
```

> **Note:** Native low-latency playback via `SoundPool` is Android-only. On iOS/macOS/Linux/Windows, the `Engine` currently falls through to the native `MethodChannel` call, which requires an equivalent platform implementation to actually produce sound — see [Platform Support](#platform-support).

---

## Adding Your Own Sounds

Sample files live under `assets/sounds/scene1/` and `assets/sounds/scene2/`, and are wired up directly in `lib/widgets/scene_pads_1.dart` / `scene_pads_2.dart` via each `PadButton`'s `soundPath`.

To swap a sound:

1. Drop your `.wav`, `.mp3`, or `.ogg` file into the relevant `assets/sounds/sceneN/` folder.
2. Update the corresponding `soundPath:` string in `scene_pads_1.dart` or `scene_pads_2.dart` to point at your new file.
3. If you add a **new** file (rather than replacing an existing one), make sure the folder is already declared under `flutter: assets:` in `pubspec.yaml` — both scene folders are included by default, so new files in the same folders are picked up automatically. Run `flutter pub get` after any asset changes.

`assets/sounds/README.txt` documents an alternate naming convention (`s1_01.wav` … `s1_16.wav`, `s2_01.wav` … `s2_16.wav`, matching the pad grid left-to-right/top-to-bottom) if you'd rather rename files than edit widget source.

---

## Platform Support

| Platform | Audio Backend | Status |
|---|---|---|
| **Android** | Native `SoundPool` via `MethodChannel` (`MainActivity.kt`) | ✅ Fully implemented |
| **Web** | Browser `dart:html` `AudioElement` | ✅ Fully implemented |
| **iOS** | Falls through to the same `MethodChannel` call as Android | ⚠️ No native iOS handler yet — needs a Swift/Obj-C implementation |
| **macOS / Linux / Windows** | Falls through to the same `MethodChannel` call as Android | ⚠️ No native desktop handler yet |

The Flutter project scaffolding for iOS, macOS, Linux, and Windows is present (so the app builds and launches), but playback on those platforms requires implementing the `load` / `play` / `stop` / `stopAll` / `dispose` methods on the `launchpad_app/sound_pool` channel natively, or swapping in a cross-platform audio package.

---

## Architecture Notes

- **Conditional imports keep platform code out of shared logic.** `audio_engine.dart` imports either `audio_stub_impl.dart` or `audio_web_impl.dart` based on `dart.library.html`, so `dart:html` is never bundled into the Android/iOS/desktop builds.
- **Loads are de-duplicated and awaited safely.** `Engine.loadSample` tracks in-flight loads per track ID so rapid re-triggers (e.g. re-entering a screen) don't queue duplicate native loads; `playTrack` will wait on an in-flight load rather than silently dropping the play.
- **The loop recorder infers tempo, it doesn't ask for one.** `Recorder._estimateBeatMs()` takes the median gap between consecutive hits (filtered to a sane 80 ms–2000 ms range) as the implied beat length, and `_estimateWrapGapMs()` separately looks at the gap between your *last* hit and *first* hit (when they share a beat pattern) to make the loop-back feel natural rather than mechanically truncated.
- **The step-sequencer models are forward-looking.** `Sample`, `Step`, and `Track` in `lib/core/models/` describe a per-step grid (with per-step volume/pitch) keyed off a sample's `category` (e.g. `"Oneshot"` → 16 steps), but nothing in `lib/screens` or `lib/widgets` currently consumes them — they're scaffolding for a planned sequencer view.

---

## Roadmap

Based on the current state of the code, likely next steps include:

- [ ] Native audio backends for iOS, macOS, Linux, and Windows (or a shared cross-platform audio package).
- [ ] Wire up the `Sample` / `Step` / `Track` models to an actual step-sequencer UI.
- [ ] Replace the placeholder `test/widget_test.dart` (currently the default Flutter counter-app smoke test) with tests that reflect the actual pad/loop/volume UI.
- [ ] Per-pad pitch control (the native Android layer already accepts a `rate`/pitch argument; the model layer has a `pitch` field; the UI doesn't expose it yet).
- [ ] Save/export recorded loops.

---

## Contributing

Issues and pull requests are welcome. If you're adding a new scene, sample pack, or platform backend, please keep the `Engine` interface (`loadSample` / `playTrack` / `dispose`) consistent across platforms so scene widgets don't need platform-specific branching.

---

## License

This repository is free for non-commerical use and does not require any license for it.
