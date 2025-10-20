import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pullup/pullup.dart';
import 'dart:async';

// Use conditional import to choose platform-specific indicator
import 'platform_indicator_stub.dart'
    if (dart.library.io) 'platform_indicator_io.dart';

/// PullUpRefresh widget for scrollable content.
class PullUpRefresh extends StatefulWidget {
  final Widget child; // Scrollable content inside PullUpRefresh
  final PullUpCallback onRefresh; // Callback executed when refresh is triggered
  final double triggerDistance; // Distance from bottom to trigger refresh
  final double indicatorSize; // Size of the loading indicator
  final Color? indicatorColor; // Color of the indicator (Android only)
  final bool autoPull; // Enable automatic periodic refresh
  final int pullDuration; // Interval for auto-pull (ms)
  final double slideDistance; // Slide distance for indicator animation
  final ScrollController?
  controller; // Optional scroll controller provided by user

  const PullUpRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.triggerDistance = 60.0,
    this.indicatorSize = 36.0,
    this.indicatorColor,
    this.autoPull = false,
    this.pullDuration = 5000,
    this.slideDistance = 16.0,
    this.controller,
  });

  @override
  State<PullUpRefresh> createState() => _PullUpRefreshState(); // Create private state
}

class _PullUpRefreshState extends State<PullUpRefresh>
    with SingleTickerProviderStateMixin {
  late final ScrollController _controller; // Actual controller used internally
  bool _isRefreshing = false; // Tracks if refresh is in progress
  bool _userInteracting = false; // Tracks if user is actively scrolling
  late final AnimationController
  _animationController; // Rotating indicator animation
  Timer? _autoTimer; // Timer for automatic pull refresh

  @override
  void initState() {
    super.initState();

    // Use provided controller or create new one
    _controller = widget.controller ?? ScrollController();
    _controller.addListener(_scrollListener); // Listen for scroll events

    // Initialize animation controller for indicator rotation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Set up auto-pull if enabled
    if (widget.autoPull) {
      _autoTimer = Timer.periodic(Duration(milliseconds: widget.pullDuration), (
        _,
      ) {
        if (!_isRefreshing && !_userInteracting) _triggerRefresh();
      });
    }
  }

  /// Called on scroll events to determine if refresh should trigger
  void _scrollListener() {
    if (_controller.position.maxScrollExtent - _controller.position.pixels <=
            widget.triggerDistance &&
        !_isRefreshing) {
      _triggerRefresh();
    }
  }

  /// Execute the refresh callback and handle indicator animation
  Future<void> _triggerRefresh() async {
    setState(() => _isRefreshing = true); // Show indicator
    _animationController.repeat(); // Start rotation

    await widget.onRefresh(); // Call user-provided callback

    if (!mounted) return;
    setState(() => _isRefreshing = false); // Hide indicator
    _animationController.reset(); // Reset animation
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener); // Clean up listener
    if (widget.controller == null) {
      _controller.dispose(); // Dispose internal controller only
    }
    _animationController.dispose(); // Dispose animation controller
    _autoTimer?.cancel(); // Cancel timer if auto-pull was enabled
    super.dispose();
  }

  /// Build the platform-specific loading indicator widget
  Widget _buildIndicator() {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: _isRefreshing
            ? widget.slideDistance
            : 0, // Slide up during refresh
      ),
      child: SizedBox(
        height: widget.indicatorSize,
        width: widget.indicatorSize,
        child: PlatformIndicator(
          animation: _animationController, // Pass animation controller
          color: widget.indicatorColor, // Pass color
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Track user interactions to pause auto-pull
      onPanDown: (_) => _userInteracting = true,
      onPanCancel: () => _userInteracting = false,
      onPanEnd: (_) => _userInteracting = false,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Hide default overscroll glow
          NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              controller: _controller, // Connect scroll controller
              physics: const AlwaysScrollableScrollPhysics(),
              child: widget.child, // Display child content
            ),
          ),
          if (_isRefreshing) _buildIndicator(), // Show indicator if refreshing
        ],
      ),
    );
  }
}
