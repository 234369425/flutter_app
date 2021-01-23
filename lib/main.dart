import 'package:flutter/material.dart';
import 'package:flutter_app/bean/Question.dart';
import 'package:flutter_app/pages/createQuestion.dart';
import 'package:flutter_app/pages/showQuestion.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/pages/questionList.dart';
import 'package:flutter_app/pages/login.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    initialRoute: RouterPathConstants.login,
    onGenerateRoute: (RouteSettings settings) {
      var routes = <String, WidgetBuilder>{
        RouterPathConstants.login: (context) => LoginFrame(),
        RouterPathConstants.index: (context) => Index(),
        RouterPathConstants.createQuestion: (context) => QuestionWidget(),
        RouterPathConstants.showQuestion: (context) =>
            ShowQuestion(q: (settings.arguments as Map<String, Question>)['q'])
      };
      WidgetBuilder builder = routes[settings.name];
      return MaterialPageRoute(builder: (ctx) => builder(ctx));
    },
  ));
}
