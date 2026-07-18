import 'package:flutter/material.dart';

class DjBqkLogo extends StatelessWidget {
  const DjBqkLogo({super.key});

  static const String _assetPath = 'assets/images/dj_bqk_logo_mark.png';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          _assetPath,
          width: 98,
          height: 58,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
        const SizedBox(height: 2),
        const Text(
          'DJ BQK',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.4,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}
