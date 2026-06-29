import 'package:flutter/material.dart';
import '../theme.dart';

/// Earth-from-space image with a subtle indigo/purple gradient wash on
/// top, sitting behind the hero content. Replaces the Lottie globe on
/// Home only — `LottieGlobe` itself is untouched in case other screens
/// use it.
class EarthHeroBackground extends StatelessWidget {
  final Widget child;

  const EarthHeroBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.background,
        image: DecorationImage(
          image: const AssetImage('assets/images/earth_bg.jpg'),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          onError: (error, stackTrace) {
            // If the image still doesn't show, this prints the real
            // reason to your terminal/debug console.
            debugPrint('EARTH IMAGE LOAD ERROR: $error');
          },
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0x59000000),
              Color(0x0F9B8CF5),
              Color(0xA6000000),
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: child,
      ),
    );
  }
}