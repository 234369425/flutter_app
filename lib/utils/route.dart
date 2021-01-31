import 'package:flutter/cupertino.dart';

class Route {
  static final navGK = new GlobalKey<NavigatorState>();

  static Future<dynamic> push(Widget widget) {
    final route = new CupertinoPageRoute(
      builder: (BuildContext context) => widget,
      settings: new RouteSettings(
        name: widget.toStringShort(),
      ),
    );
    return navGK.currentState.push(route);
  }
}
