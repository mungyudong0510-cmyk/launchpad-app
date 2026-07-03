import 'package:flutter/material.dart';



class PitchDial extends StatelessWidget {
  final double value;           // -1.0 ~ 1.0 (0.0 = center, default)
  final ValueChanged<double>? onChanged;
  final double sensitivity;     // [drag sensitivity] added it just for mouse drag;; its cancer to drag around without this function;; the delta setting in android studio is too low for this kind of drag, so i added this function to make it more sensitive and easier to use. you can change the value to depand on your preference yeee

  const PitchDial({
    super.key,
    this.value = 0.0,
    this.onChanged,
    this.sensitivity = 6.0, // drag sensitivity — higher = faster

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final h = constraints.maxHeight;
          final w = constraints.maxWidth;
          // handle position: value=1.0 → top, value=0 → center, value=-1.0 → bottom
          final handleTop = ((1 - value) / 2) * (h - 32);

          return GestureDetector(
            onVerticalDragUpdate: (details) {
              // drag up = positive, drag down = negative
              final delta = -details.delta.dy / h * sensitivity;
              final newVal = (value + delta).clamp(-1.0, 1.0);
              onChanged?.call(newVal);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  // vertical track
                  Positioned(
                    top: 16,
                    bottom: 32,
                    left: w / 2 - 1,
                    child: Container(
                      width: 2,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  // center line (0% reference)
                  Positioned(
                    top: h / 2 - 0.5,
                    left: 8,
                    right: 8,
                    child: Container(
                      height: 1,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  // handle
                  Positioned(
                    top: handleTop,
                    left: 6,
                    right: 6,
                    height: 32,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 30),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4081).withValues(
                          alpha: value == 0 ? 0.35 : 0.85,
                        ),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: value != 0
                            ? [BoxShadow(
                                color: const Color(0xFFFF4081).withValues(alpha: 0.45),
                                blurRadius: 10,
                              )]
                            : null,
                      ),
                    ),
                  ),
                  // PITCH label (top)
                  Positioned(
                    top: 5,
                    left: 0, right: 0,
                    child: Text(
                      'PITCH',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.3),
                        fontSize: 7,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // current value % (bottom)
                  Positioned(
                    bottom: 5,
                    left: 0, right: 0,
                    child: Text(
                      '${(value * 100).round()}%',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.45),
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
