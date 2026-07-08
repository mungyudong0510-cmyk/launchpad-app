import 'package:flutter/material.dart';
import 'pad_button.dart';
import '../core/engine/audio_engine.dart';



class ScenePads2 extends StatelessWidget{
  final Engine engine; 
  final double pitch;
  const ScenePads2({super.key, required this.engine, this.pitch = 0.0});

  @override
  Widget build(BuildContext context){
    return Column(children: [

      /*────────────────────[Row 1]────────────────────*/
      Expanded(child: Row(children: [
        Expanded(child: PadButton(engine: engine, pitch: pitch,color: const Color(0xFF4A148C), soundPath: 'assets/sounds/s2_01.wav')),
        Expanded(child: PadButton(engine: engine, pitch: pitch,color: const Color(0xFF6A1B9A), soundPath: 'assets/sounds/s2_02.wav')),
        Expanded(child: PadButton(engine: engine, pitch: pitch,color: const Color(0xFF1A237E), soundPath: 'assets/sounds/s2_03.wav')),
        Expanded(child: PadButton(engine: engine, pitch: pitch,color: const Color(0xFF283593), soundPath: 'assets/sounds/s2_04.wav')),
      ])),

      /*────────────────────[Row 2]────────────────────*/
      Expanded(child: Row(children: [
        Expanded(child: PadButton(engine: engine, pitch: pitch,color: const Color(0xFFAA00FF), soundPath: 'assets/sounds/s2_05.wav')),
        Expanded(child: PadButton(engine: engine, pitch: pitch,color: const Color(0xFFCE93D8), soundPath: 'assets/sounds/s2_06.wav')),
        Expanded(child: PadButton(engine: engine, pitch: pitch,color: const Color(0xFF3949AB), soundPath: 'assets/sounds/s2_07.wav')),
        Expanded(child: PadButton(engine: engine, pitch: pitch,color: const Color(0xFF7986CB), soundPath: 'assets/sounds/s2_08.wav')),
      ])),

      /*────────────────────[Row 3]────────────────────*/
      Expanded(child: Row(children: [
        Expanded(child: PadButton(engine: engine, pitch: pitch,color: const Color(0xFF004D40), soundPath: 'assets/sounds/s2_09.wav')),
        Expanded(child: PadButton(engine: engine, pitch: pitch,color: const Color(0xFF00695C), soundPath: 'assets/sounds/s2_10.wav')),
        Expanded(child: PadButton(engine: engine, pitch: pitch,color: const Color(0xFF006064), soundPath: 'assets/sounds/s2_11.wav')),
        Expanded(child: PadButton(engine: engine, pitch: pitch,color: const Color(0xFF00838F), soundPath: 'assets/sounds/s2_12.wav')),
      ])),

      /*────────────────────[Row 4]────────────────────*/
      Expanded(child: Row(children: [
        Expanded(child: PadButton(engine: engine, pitch: pitch,color: const Color(0xFF1DE9B6), soundPath: 'assets/sounds/s2_13.wav')),
        Expanded(child: PadButton(engine: engine, pitch: pitch,color: const Color(0xFF64FFDA), soundPath: 'assets/sounds/s2_14.wav')),
        Expanded(child: PadButton(engine: engine, pitch: pitch,color: const Color(0xFF00E5FF), soundPath: 'assets/sounds/s2_15.wav')),
        Expanded(child: PadButton(engine: engine, pitch: pitch,color: const Color(0xFF84FFFF), soundPath: 'assets/sounds/s2_16.wav')),
      ])),
    ]);
  }
}
