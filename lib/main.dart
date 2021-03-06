import 'package:flutter/material.dart';
import 'package:flutter_app/config/provider_config.dart';
import 'package:flutter_app/layout/application.dart';
import 'package:flutter_app/pages/login.dart';
import 'package:flutter_app/provider/login_model.dart';
import 'package:flutter_app/utils/route.dart';
import 'package:flutter_app/utils/user_header.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ProviderConfig.getInstance().getLoginPage(Application()));
  UserHeader.init();
}

class Application extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LoginModel>(context)..setContext(context);

    return new MaterialApp(
      navigatorKey: navGK,
      title: '百问',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) {
          return model.gotoLogin()
              ? ProviderConfig.getInstance().getLoginPage(LoginFrame())
              : new ApplicationLayout('0');
        }
      },
    );
  }
}
