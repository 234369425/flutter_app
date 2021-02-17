import 'package:flutter/cupertino.dart';

final navGK = new GlobalKey<NavigatorState>();

Future<dynamic> pushRoute(Widget widget) {
  final route = new CupertinoPageRoute(
    builder: (BuildContext context) => widget,
    settings: new RouteSettings(
      name: widget.toStringShort(),
    ),
  );
  return navGK.currentState.push(route);
}

pushAndRemoveRoute(Widget widget) {
  final route = new CupertinoPageRoute(
    builder: (BuildContext context) => widget,
    settings: new RouteSettings(
      name: widget.toStringShort(),
    ),
  );
  return navGK.currentState.pushAndRemoveUntil(route, (route) => route == null);
}

popRoute() {
  navGK.currentState.pop();
}

popUntilPage(Widget page) {
  try {
    navGK.currentState.popUntil(ModalRoute.withName(page.toStringShort()));
  } catch (e) {
    print('pop路由出现错误:::${e.toString()}');
  }
}
