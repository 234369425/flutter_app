import 'package:flutter/material.dart';
import 'package:flutter_app/config/provider_config.dart';
import 'package:flutter_app/layout/application.dart';
import 'package:flutter_app/pages/question/createQuestion.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/pages/login.dart';
import 'package:flutter_app/provider/global_model.dart';
import 'package:flutter_app/utils/route.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ProviderConfig.getInstance().getGlobal(Application()));
}

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<GlobalModel>(context)..setContext(context);

    return new MaterialApp(
      navigatorKey: navGK,
      title: model.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) {
          return model.goToLogin
              ? ProviderConfig.getInstance().getLoginPage(LoginFrame())
              : new ApplicationLayout();
        }
      },
    );
  }
}
