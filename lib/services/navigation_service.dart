import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  void removeAndNavigatToRoute(String _route) {
    navigatorKey.currentState?.popAndPushNamed(_route);
  }

  void navigatToRoute(String _route) {
    navigatorKey.currentState?.pushNamed(_route);
  }

  void navigatToPage(Widget _page) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (BuildContext _context) {
        return _page;
      }),
    );
  }

  void goBack(String _route) {
    navigatorKey.currentState?.pop();
  }
}
