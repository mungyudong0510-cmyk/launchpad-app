import 'package:flutter/material.dart';
import 'pad_button.dart';
import '../core/engine/audio_engine.dart';
import '../core/engine/recorder.dart';



class ScenePads2 extends StatelessWidget{
  final Engine engine; 
  final Recorder? recorder;
  final double volume;
  const ScenePads2({
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
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFF4A148C), soundPath: 'assets/sounds/scene2/Kick3.wav')),
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFF6A1B9A), soundPath: 'assets/sounds/scene2/Kick4.wav')),
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFF1A237E), soundPath: 'assets/sounds/scene2/Snare3.wav')),
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFF283593), soundPath: 'assets/sounds/scene2/Snare4.wav')),
      ])),

      /*────────────────────[Row 2]────────────────────*/
      Expanded(child: Row(children: [
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFFAA00FF), soundPath: 'assets/sounds/scene2/ClosedHat3.wav')),
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFFCE93D8), soundPath: 'assets/sounds/scene2/ClosedHat4.wav')),
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFF3949AB), soundPath: 'assets/sounds/scene2/OpenHat3.wav')),
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFF7986CB), soundPath: 'assets/sounds/scene2/OpenHat4.wav')),
      ])),

      /*────────────────────[Row 3]────────────────────*/
      Expanded(child: Row(children: [
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFF004D40), soundPath: 'assets/sounds/scene2/Clap3.wav')),
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFF00695C), soundPath: 'assets/sounds/scene2/Clap4.wav')),
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFF006064), soundPath: 'assets/sounds/scene2/Rim2.wav')),
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFF00838F), soundPath: 'assets/sounds/scene2/Triangle2.wav')),
      ])),

      /*────────────────────[Row 4]────────────────────*/
      Expanded(child: Row(children: [
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFF1DE9B6), soundPath: 'assets/sounds/scene2/Crash2.wav')),
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFF64FFDA), soundPath: 'assets/sounds/scene2/Vox.wav')),
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFF00E5FF), soundPath: 'assets/sounds/scene2/Siren.wav')),
        Expanded(child: PadButton(engine: engine, recorder: recorder, volume: volume, color: const Color(0xFF84FFFF), soundPath: 'assets/sounds/scene2/Shaker.wav')),
      ])),
    ]);
  }
}
