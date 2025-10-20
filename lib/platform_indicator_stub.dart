import 'package:flutter/material.dart';

/// PlatformIndicator widget for Web.
/// Always shows a simple CircularProgressIndicator since web
/// does not require platform-specific indicators.
class PlatformIndicator extends StatelessWidget {
  /// Animation is unused for web but kept for API consistency
  final Animation<double> animation;

  /// Optional color for the spinner
  final Color? color;

  const PlatformIndicator({
    super.key,
    required this.animation, // kept for API consistency
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Show a standard CircularProgressIndicator on Web
    return CircularProgressIndicator(
      strokeWidth: 2.5, // Thickness of the spinner
      valueColor: AlwaysStoppedAnimation(
        color ?? Colors.blue, // Use provided color or default to blue
      ),
    );
  }
}
