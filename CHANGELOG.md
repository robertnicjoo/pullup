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
