import 'package:flutter/material.dart';
import 'pad_button.dart';
import '../core/engine/audio_engine.dart';



class ScenePads2 extends StatelessWidget{
  final Engine engine; 
  final double volume;
  const ScenePads2({super.key, required this.engine, this.volume = 0.0});

  @override
  Widget build(BuildContext context){
    return Column(children: [

      /*────────────────────[Row 1]────────────────────*/
      Expanded(child: Row(children: [
        Expanded(child: PadButton(engine: engine, pitch: volume,color: const Color(0xFF4A148C), soundPath: 'assets/sounds/Kick3.wav')),
        Expanded(child: PadButton(engine: engine, pitch: volume,color: const Color(0xFF6A1B9A), soundPath: 'assets/sounds/Kick4.wav')),
        Expanded(child: PadButton(engine: engine, pitch: volume,color: const Color(0xFF1A237E), soundPath: 'assets/sounds/Snare3.wav')),
        Expanded(child: PadButton(engine: engine, pitch: volume,color: const Color(0xFF283593), soundPath: 'assets/sounds/Snare4.wav')),
      ])),

      /*────────────────────[Row 2]────────────────────*/
      Expanded(child: Row(children: [
        Expanded(child: PadButton(engine: engine, pitch: volume,color: const Color(0xFFAA00FF), soundPath: 'assets/sounds/ClosedHat3.wav')),
        Expanded(child: PadButton(engine: engine, pitch: volume,color: const Color(0xFFCE93D8), soundPath: 'assets/sounds/ClosedHat4.wav')),
        Expanded(child: PadButton(engine: engine, pitch: volume,color: const Color(0xFF3949AB), soundPath: 'assets/sounds/OpenHat3.wav')),
        Expanded(child: PadButton(engine: engine, pitch: volume,color: const Color(0xFF7986CB), soundPath: 'assets/sounds/OpenHat4.wav')),
      ])),

      /*────────────────────[Row 3]────────────────────*/
      Expanded(child: Row(children: [
        Expanded(child: PadButton(engine: engine, pitch: volume,color: const Color(0xFF004D40), soundPath: 'assets/sounds/Clap3.wav')),
        Expanded(child: PadButton(engine: engine, pitch: volume,color: const Color(0xFF00695C), soundPath: 'assets/sounds/Clap4.wav')),
        Expanded(child: PadButton(engine: engine, pitch: volume,color: const Color(0xFF006064), soundPath: 'assets/sounds/Rim2.wav')),
        Expanded(child: PadButton(engine: engine, pitch: volume,color: const Color(0xFF00838F), soundPath: 'assets/sounds/Trangle2.wav')),
      ])),

      /*────────────────────[Row 4]────────────────────*/
      Expanded(child: Row(children: [
        Expanded(child: PadButton(engine: engine, pitch: volume,color: const Color(0xFF1DE9B6), soundPath: 'assets/sounds/Crash2.wav')),
        Expanded(child: PadButton(engine: engine, pitch: volume,color: const Color(0xFF64FFDA), soundPath: 'assets/sounds/Vox.wav')),
        Expanded(child: PadButton(engine: engine, pitch: volume,color: const Color(0xFF00E5FF), soundPath: 'assets/sounds/Siren.wav')),
        Expanded(child: PadButton(engine: engine, pitch: volume,color: const Color(0xFF84FFFF), soundPath: 'assets/sounds/Shaker.wav')),
      ])),
    ]);
  }
}
