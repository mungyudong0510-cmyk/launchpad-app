import 'package:flutter/material.dart';
import 'pad_button.dart';



class ScenePads2 extends StatelessWidget{
  const ScenePads2({super.key});

  @override
  Widget build(BuildContext context){
    return Column(children: [

      /*────────────────────[Row 1]────────────────────*/
      Expanded(child: Row(children: [
        Expanded(child: PadButton(color: const Color(0xFF4A148C), soundPath: 'assets/sounds/s2_01.mp3')),
        Expanded(child: PadButton(color: const Color(0xFF6A1B9A), soundPath: 'assets/sounds/s2_02.mp3')),
        Expanded(child: PadButton(color: const Color(0xFF1A237E), soundPath: 'assets/sounds/s2_03.mp3')),
        Expanded(child: PadButton(color: const Color(0xFF283593), soundPath: 'assets/sounds/s2_04.mp3')),
      ])),

      /*────────────────────[Row 2]────────────────────*/
      Expanded(child: Row(children: [
        Expanded(child: PadButton(color: const Color(0xFFAA00FF), soundPath: 'assets/sounds/s2_05.mp3')),
        Expanded(child: PadButton(color: const Color(0xFFCE93D8), soundPath: 'assets/sounds/s2_06.mp3')),
        Expanded(child: PadButton(color: const Color(0xFF3949AB), soundPath: 'assets/sounds/s2_07.mp3')),
        Expanded(child: PadButton(color: const Color(0xFF7986CB), soundPath: 'assets/sounds/s2_08.mp3')),
      ])),

      /*────────────────────[Row 3]────────────────────*/
      Expanded(child: Row(children: [
        Expanded(child: PadButton(color: const Color(0xFF004D40), soundPath: 'assets/sounds/s2_09.mp3')),
        Expanded(child: PadButton(color: const Color(0xFF00695C), soundPath: 'assets/sounds/s2_10.mp3')),
        Expanded(child: PadButton(color: const Color(0xFF006064), soundPath: 'assets/sounds/s2_11.mp3')),
        Expanded(child: PadButton(color: const Color(0xFF00838F), soundPath: 'assets/sounds/s2_12.mp3')),
      ])),

      /*────────────────────[Row 4]────────────────────*/
      Expanded(child: Row(children: [
        Expanded(child: PadButton(color: const Color(0xFF1DE9B6), soundPath: 'assets/sounds/s2_13.mp3')),
        Expanded(child: PadButton(color: const Color(0xFF64FFDA), soundPath: 'assets/sounds/s2_14.mp3')),
        Expanded(child: PadButton(color: const Color(0xFF00E5FF), soundPath: 'assets/sounds/s2_15.mp3')),
        Expanded(child: PadButton(color: const Color(0xFF84FFFF), soundPath: 'assets/sounds/s2_16.mp3')),
      ])),
    ]);
  }
}
