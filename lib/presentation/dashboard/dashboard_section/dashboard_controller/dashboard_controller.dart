import 'package:get/get.dart';

/// Tab positions inside [DashboardPage]'s IndexedStack.
class DashboardTabs {
  DashboardTabs._();

  static const int home = 0;
  static const int budget = 1;
  static const int addExpense = 2;
  static const int analytics = 3;
  static const int profile = 4;
}

class DashboardController extends GetxController {
  RxInt currentIndex = DashboardTabs.home.obs;

  /// Data refreshers registered by each tab controller.
  ///
  /// DashboardPage keeps every tab alive inside an IndexedStack, so a tab
  /// controller's `onInit` runs only once at startup and switching tabs does not
  /// rebuild the page. Registering a refresher here lets the dashboard reload a
  /// tab's data every time the user switches to it, so screens never show stale
  /// (often zero) values.
  final Map<int, Future<void> Function()> _tabRefreshers = {};

  /// Register (or replace) the data refresher for the tab at [index].
  void registerTabRefresher(int index, Future<void> Function() refresher) {
    _tabRefreshers[index] = refresher;
  }

  /// Drop the refresher for the tab at [index].
  void unregisterTabRefresher(int index) {
    _tabRefreshers.remove(index);
  }

  void changeTab(int index) {
    final isNewTab = currentIndex.value != index;
    currentIndex.value = index;

    // Reload the tab the user just opened so it always shows fresh data.
    if (isNewTab) {
      _refreshTab(index);
    }
  }

  Future<void> _refreshTab(int index) async {
    final refresher = _tabRefreshers[index];
    if (refresher == null) return;

    try {
      await refresher();
    } catch (_) {
      // Tab controllers already log and surface their own errors.
    }
  }
 
}