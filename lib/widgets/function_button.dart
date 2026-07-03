import 'package:flutter/material.dart';



class FunctionButton extends StatefulWidget{
  final Color color;
  final String label;
  final bool isToggle;
  final bool isActive; // toggle on/off — parent(HomeScreen)
  final ValueChanged<bool>? onChanged; // notify parent when toggle changes
  final VoidCallback? onTap;

  const FunctionButton({
    super.key,
    required this.color,
    required this.label,
    this.isToggle = false,
    this.isActive = false,
    this.onChanged,
    this.onTap,
  });

  @override
  State<FunctionButton> createState() => _FunctionButtonState();
}

class _FunctionButtonState extends State<FunctionButton>{
  bool _pressed = false; // default state for non-toggle buttons

  void _onTapDown(TapDownDetails _){
    if (widget.isToggle) {
      widget.onChanged?.call(!widget.isActive); // req parent to change toggle state
    } else {
      setState(() => _pressed = true);
    }
    widget.onTap?.call();
  }

  void _onTapEnd(){
    if (!widget.isToggle){
      Future.delayed(const Duration(milliseconds: 100),(){
        if (mounted) setState(() => _pressed = false);
      });
    }
  }

  bool get _isLit => widget.isActive || _pressed;

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(4), //setted as 4px, but idk you can change it to whatever you want
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: (_) => _onTapEnd(),
        onTapCancel: _onTapEnd,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 50),
          decoration: BoxDecoration(
            shape: BoxShape.circle, //shape of the button
            color: _isLit ? widget.color.withValues(alpha: 0.2) : Colors.transparent,
            border: Border.all(
              color: _isLit ? widget.color : widget.color.withValues(alpha: 0.45),
              width: (_isLit && widget.isToggle) ? 3 : 2,
            ),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                color: _isLit ? widget.color : widget.color.withValues(alpha: 0.6),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
