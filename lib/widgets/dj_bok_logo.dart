import 'dart:math' as math;

import 'package:flutter/material.dart';

class DjBokLogo extends StatelessWidget {
  const DjBokLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 176,
      height: 80,
      child: CustomPaint(
        painter: _DjBokLogoPainter(),
      ),
    );
  }
}

class _DjBokLogoPainter extends CustomPainter {
  const _DjBokLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()
      ..color = Colors.white.withValues(alpha: 0.94)
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.94)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;
    final cutout = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.save();
    const iconScale = 0.68;
    canvas.translate(size.width / 2 - 42 * iconScale, 0);
    canvas.scale(iconScale);

    canvas.drawArc(
      const Rect.fromLTWH(7, 3, 70, 48),
      math.pi,
      math.pi,
      false,
      stroke,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(0, 24, 15, 24), const Radius.circular(7)),
      white,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(69, 24, 15, 24), const Radius.circular(7)),
      white,
    );

    canvas.drawOval(const Rect.fromLTWH(22, 14, 42, 48), white);
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(26, 35, 34, 23), const Radius.circular(11)),
      cutout,
    );
    canvas.drawOval(const Rect.fromLTWH(31, 38, 11, 12), white);
    canvas.drawOval(const Rect.fromLTWH(44, 38, 11, 12), white);
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(35, 42, 16, 14), const Radius.circular(7)),
      white,
    );

    canvas.drawOval(const Rect.fromLTWH(4, 45, 34, 18), white);
    canvas.drawOval(const Rect.fromLTWH(48, 45, 34, 18), white);
    for (var i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(15 + i * 5, 51),
        Offset(18 + i * 5, 64),
        stroke..strokeWidth = 3,
      );
      canvas.drawLine(
        Offset(58 + i * 5, 51),
        Offset(55 + i * 5, 64),
        stroke..strokeWidth = 3,
      );
    }

    for (var row = 0; row < 3; row++) {
      for (var col = 0; col < 3; col++) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(28 + col * 14, 58 + row * 9, 10, 7),
            const Radius.circular(2),
          ),
          white,
        );
      }
    }

    canvas.restore();

    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'DJ BOK',
        style: TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset((size.width - textPainter.width) / 2, 57),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
