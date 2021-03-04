import 'package:flutter/material.dart';
import 'package:flutter_app/config/provider_config.dart';
import 'package:flutter_app/layout/application.dart';
import 'package:flutter_app/pages/question/createQuestion.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/pages/login.dart';
import 'package:flutter_app/provider/global_model.dart';
import 'package:flutter_app/provider/login_model.dart';
import 'package:flutter_app/utils/route.dart';
import 'package:provider/provider.dart';

import 'agora/agora_rtm_client.dart';

void main() {
  runApp(ProviderConfig.getInstance().getLoginPage(Application()));
}

class Application extends StatelessWidget {
  var _client;

  Application() {
    init();
  }

  init() async {
    _client =
        await AgoraRtmClient.createInstance('9c2be3809d414367a9eac783c3621d72');
  }

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
