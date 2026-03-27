import 'package:flutter/foundation.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentTab = 0;

  int get currentTab => _currentTab;

  void setTab(int index) {
    if (_currentTab == index) {
      return;
    }
    _currentTab = index;
    notifyListeners();
  }
}
