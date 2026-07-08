import 'package:flutter/material.dart';
import '../core/engine/audio_engine.dart';



class PadButton extends StatefulWidget{
  final Engine engine;
  final Color color;
  final String? soundPath;
  final double pitch;

  const PadButton({
    super.key,
    required this.engine,
    required this.color,
    this.soundPath,
    this.pitch = 0.0  
  });

  @override //for debugging purposes don't remove it took me ages to figure out why the buttons weren't working;; goodie shittt but you can deleted this if you want, it won't affect the functionality of the codes
  State<PadButton> createState() => _PadButtonState();
}

class _PadButtonState extends State<PadButton>{
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    final path = widget.soundPath;
    if (path != null) {
      widget.engine.loadSample(path, path);
    }
  }

  void _onTapDown(TapDownDetails _){
    setState(() => _pressed = true);
    final path = widget.soundPath;
    if (path != null) {
      final pitchFactor = (1.0 + widget.pitch).clamp(0.5, 2.0);
      widget.engine.playTrack(path, pitch: pitchFactor);
    }
  }

  void _onTapEnd() {
    Future.delayed(const Duration(milliseconds: 100),( ){ //100ms for glow effect duration
      if (mounted) setState(() => _pressed = false);
    });
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(4), //setted as 4px, but idk you can change it to whatever you want
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: (_) => _onTapEnd(),
        onTapCancel: _onTapEnd,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 50), //50ms for glow effect reaction time
          decoration: BoxDecoration(  //shape of the button
            color: _pressed ? widget.color : widget.color.withValues(alpha: 0.6), //brightness of the button before being pressed
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: _pressed ? 0.85 : 0.2),
                blurRadius: _pressed ? 22 : 6,
                spreadRadius: _pressed ? 3 : 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
