import 'package:flutter/material.dart';
import 'pad_button.dart';
import '../core/engine/audio_engine.dart';
import '../core/engine/recorder.dart';



class ScenePads1 extends StatelessWidget{
  final Engine engine; 
  final Recorder? recorder;
  final double volume;
  const ScenePads1({
    super.key,
    required this.engine,
    this.recorder,
    required this.volume,
  });

  @override
  Widget build(BuildContext context){
    return Column(children: [

      /*────────────────────[Row 1]────────────────────*/
      Expanded(child: Row(children: [
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFFC62828), soundPath: 'assets/sounds/scene1/Kick1.wav'
        )), //drop wav files into assets/sounds/ folder then change the name path strings yee
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFFE53935), soundPath: 'assets/sounds/scene1/Kick2.wav')),
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFFF57F17), soundPath: 'assets/sounds/scene1/Snare1.wav')),
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFFFFA000), soundPath: 'assets/sounds/scene1/Snare2.wav')),
      ])),

      /*────────────────────[Row 2]────────────────────*/
      Expanded(child: Row(children: [
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFFFF5252), soundPath: 'assets/sounds/scene1/ClosedHat1.wav')),
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFFFF8A80), soundPath: 'assets/sounds/scene1/ClosedHat2.wav')),
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFFFFCA28), soundPath: 'assets/sounds/scene1/OpenHat1.wav')),
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFFFFE082), soundPath: 'assets/sounds/scene1/OpenHat2.wav')),
      ])),

      /*────────────────────[Row 3]────────────────────*/
      Expanded(child: Row(children: [
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFF2E7D32), soundPath: 'assets/sounds/scene1/Clap1.wav')),
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFF43A047), soundPath: 'assets/sounds/scene1/Clap2.wav')),
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFF1565C0), soundPath: 'assets/sounds/scene1/Rim1.wav')),
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFF1E88E5), soundPath: 'assets/sounds/scene1/Triangle1.wav')),
      ])),

      /*────────────────────[Row 4]────────────────────*/
      Expanded(child: Row(children: [
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFF00E676), soundPath: 'assets/sounds/scene1/Crash1.wav')),
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFF69F0AE), soundPath: 'assets/sounds/scene1/Chant.wav')),
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFF40C4FF), soundPath: 'assets/sounds/scene1/Bleep.wav')),
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFF82B1FF), soundPath: 'assets/sounds/scene1/Cowbell.wav')),
      ])),
    ]);
  }
}
