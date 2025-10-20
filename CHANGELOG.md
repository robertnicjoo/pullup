### 1.0.3
* Updated ReadMe.

### 1.0.2
* Added optional `ScrollController` support for `PullUpRefresh` and `SliverPullUpRefresh` widgets.
* Added detailed inline comments across all widgets and platform indicator files.
* Improved API consistency by unifying `animation` property usage in `PlatformIndicator`.
* Minor code cleanups and documentation improvements.

### 1.0.1
* Updated PullUp plugin description in `pubspec.yaml`.

## 1.0.0

* Initial release of the PullUp plugin for Flutter.
* Adds `PullUpRefresh` widget to enable pull-up-to-refresh functionality for scrollable content.
* Adds `SliverPullUpRefresh` widget to enable pull-up-to-refresh functionality for sliver-based scroll views (e.g., `CustomScrollView`).
* Supports:
    * Manual pull-up refresh by user interaction.
    * Automatic periodic refresh (`autoPull`) with customizable duration.
    * Platform-specific loading indicators (Android: `CircularProgressIndicator`, iOS: `CupertinoActivityIndicator`).
    * Configurable indicator size, color, and slide distance.
* Example app demonstrating usage of `PullUpRefresh` with auto-pull and custom indicator.
* Fully documented public API with `PullUpCallback` typedef.