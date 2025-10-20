# PullUp

A Flutter Pull-Up-to-Refresh widget with platform-specific indicators, manual pull, optional auto-refresh, and smooth bottom-slide animation.
This package works opposite to the built-in `RefreshIndicator` and is perfect for chat apps or lists that need to refresh from bottom to top.


## Features

- Manual pull-up refresh for `ListView`, `Column`, `SingleChildScrollView`, `CustomScrollView`.
- Sliver-compatible with `SliverPullUpRefresh`.
- Platform-specific indicator: 
  - Android → `CircularProgressIndicator`
  - iOS → `CupertinoActivityIndicator`
- Optional automatic refresh (`autoPull`) with configurable interval (`pullDuration` in ms).
- Auto-pull pauses while the user is scrolling or interacting.
- Smooth sliding animation for the indicator (`slideDistance`).
- Cross-platform: iOS, Android, Web, Linux, Windows.
- Customizable indicator size and color.
- Configurable trigger distance.

## Usage

### Standard Scrollable

```dart
PullUpRefresh(
    autoPull: true,             // enable auto-refresh
    pullDuration: 5000,         // refresh every 5 seconds
    indicatorColor: Colors.purple,
    indicatorSize: 40,
    slideDistance: 24.0,
    onRefresh: () async {
      // Your refresh logic
    },
    child: Column(
      children: [...],
    ),
)
```

### Sliver Usage

```dart
SliverPullUpRefresh(
    autoPull: true,
    pullDuration: 5000,
    indicatorColor: Colors.purple,
    indicatorSize: 40,
    slideDistance: 24.0,
    onRefresh: () async {
      // Your refresh logic
    },
    slivers: [
        SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(title: Text('Message $index')),
              childCount: 30,
            ),
        ),
    ],
)
```

