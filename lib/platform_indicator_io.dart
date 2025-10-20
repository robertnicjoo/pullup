import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// PlatformIndicator widget chooses the appropriate loading indicator
/// based on the current platform (Android or iOS).
/// - On Android: CircularProgressIndicator with optional rotation animation
/// - On iOS: CupertinoActivityIndicator
class PlatformIndicator extends StatelessWidget {
  final Animation<double> animation; // Animation for rotation (Android)
  final Color? color; // Optional color for Android indicator

  const PlatformIndicator({super.key, required this.animation, this.color});

  @override
  Widget build(BuildContext context) {
    // Check the platform
    if (Theme.of(context).platform == TargetPlatform.android) {
      // Android indicator with rotation animation
      return RotationTransition(
        turns: animation, // Rotate indicator continuously
        child: CircularProgressIndicator(
          strokeWidth: 2.5, // Indicator thickness
          valueColor: AlwaysStoppedAnimation(
            color ?? Colors.blue, // Use provided color or default to blue
          ),
        ),
      );
    } else {
      // iOS indicator
      return const CupertinoActivityIndicator(
        radius: 14, // Fixed radius for iOS spinner
      );
    }
  }
}
