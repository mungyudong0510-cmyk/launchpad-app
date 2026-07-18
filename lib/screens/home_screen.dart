import 'package:flutter/material.dart';
import '../widgets/dj_bqk_logo.dart';
import '../widgets/function_button.dart';
import '../widgets/volume_dial.dart';
import '../widgets/scene_pads_1.dart';
import '../widgets/scene_pads_2.dart';
import '../core/engine/audio_engine.dart';
import '../core/engine/recorder.dart';
 
 
 
class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});
 
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
 
class _HomeScreenState extends State<HomeScreen>{
  final Engine _engine = Engine(); // shared audio engine for every pad
  late final Recorder _recorder;
 
  double _volume = 1.0; // 0.0 ~ 1.0, default 1.0 (full volume)
  int _scene = 1;      // active scene: 1 or 2
 
  @override
  void initState() {
    super.initState();
    _recorder = Recorder(_engine);
  }
 
  void _toggleLoopRecording() {
    setState(() {
      if (_recorder.recording) {
        _recorder.stopRecording();
      } else {
        _recorder.startRecording();
      }
    });
  }
 
  void _toggleCue() {
    if (!_recorder.hasTake) return;
    setState(() {
      _recorder.toggleCue();
    });
  }
 
  void _clearAll() {
    setState(() {
      _recorder.clear();
      _volume = 1.0;
    });
  }
 
  @override
  void dispose() {
    _recorder.dispose();
    _engine.dispose();
    super.dispose();
  }
  
 
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Column(
            children: [
              const SizedBox(
                height: 86,
                child: Center(child: DjBqkLogo()),
              ),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Column(
                      children: [
 
                  // top section: 4x4 pads + right volume dial
                  Expanded(
                    flex: 4,
                    child: Row(
                      children: [
 
                        // 4x4 pad grid — switches between SC1 and SC2
                        Expanded(
                          flex: 4,
                          child: _scene == 1
                              ? ScenePads1(
                                  engine: _engine,
                                  recorder: _recorder,
                                  volume: _volume,
                                )
                              : ScenePads2(
                                  engine: _engine,
                                  recorder: _recorder,
                                  volume: _volume,
                                ),
                        ),
 
                        // right column: volume dial
                        Expanded(
                          flex: 1,
                          child: VolumeDial(
                            value: _volume,
                            onChanged: (val) => setState(() => _volume = val),
                          ),
                        ),
                      ],
                    ),
                  ),
 
                  /*─────────────────[Row 5] (Function Buttons)────────────*/
                  Expanded(
                    flex: 1,
                    child: Row(children: [
 
                      //──────────[scene1/page1]──────────
                      Expanded(child: FunctionButton(
                        color: const Color(0xFFFF4081),
                        label: 'SC1',
                        isToggle: true,
                        isActive: _scene == 1,
                        onChanged: (_) => setState(() => _scene = 1),
                      )),
 
                      //──────────[scene2/page2]──────────
                      Expanded(child: FunctionButton(
                        color: const Color(0xFF00E5FF),
                        label: 'SC2',
                        isToggle: true,
                        isActive: _scene == 2,
                        onChanged: (_) => setState(() => _scene = 2),
                      )),
 
                      //──────────[loop toggle buttons]──────────
                      Expanded(child: FunctionButton(
                        color: const Color(0xFFFF4081),
                        label: 'Loop',
                        isToggle: true,
                        isActive: _recorder.recording,
                        onChanged: (_) => _toggleLoopRecording(),
                      )),
 
                      //──────────[echo toggle button]──────────
                      Expanded(child: FunctionButton(
                        color: const Color(0xFFFFD740),
                        label: 'CUE',
                        isToggle: true,
                        isActive: _recorder.cueing,
                        onChanged: (_) => _toggleCue(),
                      )),
 
                      // ──────────[clear button]──────────
                      Expanded(child: FunctionButton(
                        color: const Color(0xFFFF4081),
                        label: 'Clear',
                        onTap: _clearAll, //— resets all toggles + pitch to 0%
                      )),
                    ]),
                  ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
