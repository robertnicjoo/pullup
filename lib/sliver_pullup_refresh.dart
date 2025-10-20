import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';

import 'package:pullup/pullup.dart';

/// A Flutter widget that allows users to pull **upwards** at the bottom of a
/// CustomScrollView / sliver list to trigger a refresh action.
/// Supports auto-pull, custom indicators, and slide animations.
class SliverPullUpRefresh extends StatefulWidget {
  /// Callback function executed when a pull-up refresh is triggered
  final PullUpCallback onRefresh;

  /// Distance from the bottom at which the refresh triggers automatically
  final double triggerDistance;

  /// Size of the loading indicator widget
  final double indicatorSize;

  /// Color of the loading indicator (Android only)
  final Color? indicatorColor;

  /// Enables automatic periodic refresh without user interaction
  final bool autoPull;

  /// Interval for auto-pull in milliseconds
  final int pullDuration;

  /// Distance the indicator slides up from the bottom when refreshing
  final double slideDistance;

  /// The list of sliver widgets inside the scrollable area
  final List<Widget> slivers;

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
  });

  @override
  // ignore: library_private_types_in_public_api
  State<SliverPullUpRefresh> createState() => _SliverPullUpRefreshState();
}

/// Private state class for SliverPullUpRefresh
/// Handles scroll listening, animation, auto-pull, and indicator display.
class _SliverPullUpRefreshState extends State<SliverPullUpRefresh>
    with SingleTickerProviderStateMixin {
  /// Controller for the CustomScrollView
  final ScrollController _controller = ScrollController();

  /// Whether a refresh is currently in progress
  bool _isRefreshing = false;

  /// Whether the user is actively interacting with the scroll
  bool _userInteracting = false;

  /// Animation controller for rotating the loading indicator (Android)
  late AnimationController _animationController;

  /// Timer for auto-pull refresh
  Timer? _autoTimer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // If autoPull is enabled, set up a periodic timer
    if (widget.autoPull) {
      _autoTimer =
          Timer.periodic(Duration(milliseconds: widget.pullDuration), (_) {
            if (!_isRefreshing && !_userInteracting) _triggerRefresh();
          });
    }
  }

  /// Listener that checks if the user has scrolled close enough to the bottom
  /// to trigger a refresh
  void _scrollListener() {
    if (_controller.position.maxScrollExtent - _controller.position.pixels <=
        widget.triggerDistance &&
        !_isRefreshing) {
      _triggerRefresh();
    }
  }

  /// Triggers the refresh callback and manages the loading indicator animation
  Future<void> _triggerRefresh() async {
    setState(() => _isRefreshing = true);
    _animationController.repeat(); // Start rotation animation

    await widget.onRefresh(); // Execute the user-provided callback

    if (!mounted) return;
    setState(() => _isRefreshing = false);
    _animationController.reset(); // Reset animation when done
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    _animationController.dispose();
    _autoTimer?.cancel();
    super.dispose();
  }

  /// Builds the loading indicator widget
  /// Uses CircularProgressIndicator on Android and CupertinoActivityIndicator on iOS.
  Widget _buildIndicator() {
    Widget indicator;
    if (Platform.isAndroid) {
      indicator = RotationTransition(
        turns: _animationController,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.indicatorColor ?? Colors.blue,
          ),
        ),
      );
    } else {
      indicator = const CupertinoActivityIndicator(radius: 14);
    }

    // Slide the indicator up when refreshing
    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: _isRefreshing ? widget.slideDistance : 0),
      child: SizedBox(
        height: widget.indicatorSize,
        width: widget.indicatorSize,
        child: indicator,
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
          // Main scrollable area containing the provided slivers
          CustomScrollView(
            controller: _controller,
            slivers: widget.slivers,
          ),
          if (_isRefreshing) _buildIndicator(), // Show indicator if refreshing
        ],
      ),
    );
  }
}
