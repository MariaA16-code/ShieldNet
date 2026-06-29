import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieGlobe extends StatelessWidget {
  final double size;

  const LottieGlobe({super.key, this.size = 160});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Lottie.asset(
        'assets/animations/globe.json',
        fit: BoxFit.contain,
        repeat: true,
      ),
    );
  }
}