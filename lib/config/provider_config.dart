import 'package:flutter/cupertino.dart';
import 'package:flutter_app/provider/global_model.dart';
import 'package:flutter_app/provider/login_model.dart';
import 'package:provider/provider.dart';

class ProviderConfig {
  static ProviderConfig _instance;

  static ProviderConfig getInstance() {
    if (_instance == null) {
      _instance = ProviderConfig._internal();
    }
    return _instance;
  }

  ChangeNotifierProvider<GlobalModel> getGlobal(Widget child) {
    return ChangeNotifierProvider<GlobalModel>(
      create: (context) => GlobalModel(),
      child: child,
    );
  }

  ChangeNotifierProvider<LoginModel> getLoginPage(Widget child) {
    return ChangeNotifierProvider<LoginModel>(
      create: (context) => LoginModel(),
      child: child,
    );
  }

  ProviderConfig._internal();
}
