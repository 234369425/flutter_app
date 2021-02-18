import 'package:flutter/material.dart';

class LoginModel extends ChangeNotifier {
  BuildContext context;

  void setContext(BuildContext context) {
    if (this.context == null) {
      this.context = context;
    }
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("Login logic dispose");
  }

  void refresh() {
    notifyListeners();
  }
}
