import 'package:flutter/material.dart';
import 'pad_button.dart';



class ScenePads1 extends StatelessWidget{
  const ScenePads1({super.key});

  @override
  Widget build(BuildContext context){
    return Column(children: [

      /*────────────────────[Row 1]────────────────────*/
      Expanded(child: Row(children: [
        Expanded(child: PadButton(color: const Color(0xFFC62828), soundPath: 'assets/sounds/s1_01.mp3')), //drop mp3 files into assets/sounds/ folder then change the name path strings yee
        Expanded(child: PadButton(color: const Color(0xFFE53935), soundPath: 'assets/sounds/s1_02.mp3')),
        Expanded(child: PadButton(color: const Color(0xFFF57F17), soundPath: 'assets/sounds/s1_03.mp3')),
        Expanded(child: PadButton(color: const Color(0xFFFFA000), soundPath: 'assets/sounds/s1_04.mp3')),
      ])),

      /*────────────────────[Row 2]────────────────────*/
      Expanded(child: Row(children: [
        Expanded(child: PadButton(color: const Color(0xFFFF5252), soundPath: 'assets/sounds/s1_05.mp3')),
        Expanded(child: PadButton(color: const Color(0xFFFF8A80), soundPath: 'assets/sounds/s1_06.mp3')),
        Expanded(child: PadButton(color: const Color(0xFFFFCA28), soundPath: 'assets/sounds/s1_07.mp3')),
        Expanded(child: PadButton(color: const Color(0xFFFFE082), soundPath: 'assets/sounds/s1_08.mp3')),
      ])),

      /*────────────────────[Row 3]────────────────────*/
      Expanded(child: Row(children: [
        Expanded(child: PadButton(color: const Color(0xFF2E7D32), soundPath: 'assets/sounds/s1_09.mp3')),
        Expanded(child: PadButton(color: const Color(0xFF43A047), soundPath: 'assets/sounds/s1_10.mp3')),
        Expanded(child: PadButton(color: const Color(0xFF1565C0), soundPath: 'assets/sounds/s1_11.mp3')),
        Expanded(child: PadButton(color: const Color(0xFF1E88E5), soundPath: 'assets/sounds/s1_12.mp3')),
      ])),

      /*────────────────────[Row 4]────────────────────*/
      Expanded(child: Row(children: [
        Expanded(child: PadButton(color: const Color(0xFF00E676), soundPath: 'assets/sounds/s1_13.mp3')),
        Expanded(child: PadButton(color: const Color(0xFF69F0AE), soundPath: 'assets/sounds/s1_14.mp3')),
        Expanded(child: PadButton(color: const Color(0xFF40C4FF), soundPath: 'assets/sounds/s1_15.mp3')),
        Expanded(child: PadButton(color: const Color(0xFF82B1FF), soundPath: 'assets/sounds/s1_16.mp3')),
      ])),
    ]);
  }
}
