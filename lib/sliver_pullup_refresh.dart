import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pullup/pullup.dart';
import 'dart:async';

// Conditional import to use platform-specific indicator
import 'platform_indicator_stub.dart'
    if (dart.library.io) 'platform_indicator_io.dart';

/// SliverPullUpRefresh widget for sliver-based scroll views like CustomScrollView.
/// Enables pull-up-to-refresh behavior similar to PullUpRefresh, but supports slivers.
class SliverPullUpRefresh extends StatefulWidget {
  final PullUpCallback onRefresh; // Callback executed when refresh triggers
  final List<Widget> slivers; // List of slivers inside CustomScrollView
  final double triggerDistance; // Distance from bottom to trigger refresh
  final double indicatorSize; // Size of the loading indicator
  final Color? indicatorColor; // Color of the indicator (Android only)
  final bool autoPull; // Enables automatic periodic refresh
  final int pullDuration; // Interval for auto-pull in milliseconds
  final double slideDistance; // Distance indicator slides up when refreshing
  final ScrollController? controller; // Optional scroll controller

  const SliverPullUpRefresh({
    super.key,
    required this.onRefresh,
    required this.slivers,
    this.triggerDistance = 60.0,
    this.indicatorSize = 36.0,
    this.indicatorColor,
    this.autoPull = false,
    this.pullDuration = 5000,
    this.slideDistance = 16.0,
    this.controller,
  });

  @override
  State<SliverPullUpRefresh> createState() => _SliverPullUpRefreshState();
}

class _SliverPullUpRefreshState extends State<SliverPullUpRefresh>
    with SingleTickerProviderStateMixin {
  late final ScrollController _controller; // Internal scroll controller
  bool _isRefreshing = false; // Tracks if refresh is in progress
  bool _userInteracting = false; // Tracks if user is actively scrolling
  late final AnimationController _animationController; // For rotating indicator
  Timer? _autoTimer; // Timer for auto-pull

  @override
  void initState() {
    super.initState();

    // Use provided controller or create new one
    _controller = widget.controller ?? ScrollController();
    _controller.addListener(_scrollListener); // Listen to scroll events

    // Initialize animation controller for indicator rotation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Set up automatic pull refresh if enabled
    if (widget.autoPull) {
      _autoTimer = Timer.periodic(Duration(milliseconds: widget.pullDuration), (
        _,
      ) {
        if (!_isRefreshing && !_userInteracting) _triggerRefresh();
      });
    }
  }

  /// Scroll listener that triggers refresh when reaching triggerDistance from bottom
  void _scrollListener() {
    if (_controller.position.maxScrollExtent - _controller.position.pixels <=
            widget.triggerDistance &&
        !_isRefreshing) {
      _triggerRefresh();
    }
  }

  /// Trigger the refresh callback and manage the indicator animation
  Future<void> _triggerRefresh() async {
    setState(() => _isRefreshing = true); // Show indicator
    _animationController.repeat(); // Start rotation animation

    await widget.onRefresh(); // Call user-provided callback

    if (!mounted) return;
    setState(() => _isRefreshing = false); // Hide indicator
    _animationController.reset(); // Reset animation
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener); // Remove scroll listener
    if (widget.controller == null) {
      _controller.dispose(); // Dispose internal controller
    }
    _animationController.dispose(); // Dispose animation controller
    _autoTimer?.cancel(); // Cancel auto-pull timer
    super.dispose();
  }

  /// Builds the loading indicator widget
  Widget _buildIndicator() {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: _isRefreshing ? widget.slideDistance : 0, // Slide up indicator
      ),
      child: SizedBox(
        height: widget.indicatorSize,
        width: widget.indicatorSize,
        child: PlatformIndicator(
          animation: _animationController, // Pass animation controller
          color: widget.indicatorColor, // Pass optional color
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Track user interaction to pause auto-pull
      onPanDown: (_) => _userInteracting = true,
      onPanCancel: () => _userInteracting = false,
      onPanEnd: (_) => _userInteracting = false,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Main sliver-based scroll view
          CustomScrollView(controller: _controller, slivers: widget.slivers),
          if (_isRefreshing) _buildIndicator(), // Show indicator if refreshing
        ],
      ),
    );
  }
}
