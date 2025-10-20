// Export the main PullUpRefresh widget for regular scrollable content
export 'pull_up_refresh.dart';

// Export the SliverPullUpRefresh widget for CustomScrollView / sliver content
export 'sliver_pullup_refresh.dart';

// Type definition for the refresh callback used in both PullUpRefresh widgets
// Users must provide a function that returns a Future<void> when the pull-up refresh is triggered
typedef PullUpCallback = Future<void> Function();
