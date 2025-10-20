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
final ScrollController _controller = ScrollController();

PullUpRefresh(
    controller: _controller,     // optional: provide your own ScrollController, or omit to use internal
    autoPull: true,              // optional: enable automatic periodic refresh
    pullDuration: 5000,          // optional: interval for autoPull in milliseconds (default 5000)
    indicatorColor: Colors.purple, // optional: customize indicator color
    indicatorSize: 40,           // optional: customize indicator size
    slideDistance: 24.0,         // optional: distance indicator slides up when refreshing
    onRefresh: () async {
      // required: your refresh logic here
    },
    child: Column(
      children: [...],
    ),
)
```


### Sliver Usage

```dart
final ScrollController _controller = ScrollController();

SliverPullUpRefresh(
  controller: _controller,     // optional: provide your own ScrollController
  autoPull: true,              // optional: enable automatic periodic refresh
  pullDuration: 5000,          // optional: interval for autoPull in milliseconds
  indicatorColor: Colors.purple, // optional: customize indicator color
  indicatorSize: 40,           // optional: customize indicator size
  slideDistance: 24.0,         // optional: distance indicator slides up when refreshing
  onRefresh: () async {
    // required: your refresh logic here
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

### Notes

- All parameters except `onRefresh` and `child`/`slivers` are optional.
- `controller` can be omitted, in which case an internal `ScrollController` is used.
- `autoPull` and `pullDuration` are only needed if you want periodic automatic refresh.
- `indicatorColor`, `indicatorSize`, and `slideDistance` are optional customization options.