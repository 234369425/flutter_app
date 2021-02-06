import 'package:flutter/material.dart';
import 'package:flutter_app/config/provider_config.dart';
import 'package:flutter_app/layout/application.dart';
import 'file:///E:/Application/flutter_app/lib/pages/question/createQuestion.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: RouterPathConstants.login,
      onGenerateRoute: (RouteSettings settings) {
        var routes = <String, WidgetBuilder>{
          RouterPathConstants.login: (context) => LoginFrame(),
          RouterPathConstants.index: (context) => ApplicationLayout(),
          RouterPathConstants.createQuestion: (context) => QuestionWidget()
        };
        WidgetBuilder builder = routes[settings.name];
        return MaterialPageRoute(builder: (ctx) => builder(ctx));
      },
    );
  }
}
