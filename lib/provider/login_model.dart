import 'package:flutter/material.dart';

class LoginModel extends ChangeNotifier {
  BuildContext context;

  String area = '中国大陆（+86）';

  void setContext(BuildContext context) {
    if (this.context == null) {
      this.context = context;
    }
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("LoginLogic销毁了");
  }

  void refresh() {
    notifyListeners();
  }
}
