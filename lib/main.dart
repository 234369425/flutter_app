import 'package:flutter/material.dart';
import 'package:flutter_app/compontent/question.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/index.dart';
import 'login.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    initialRoute: RouterPathConstants.login,
    routes: {
      RouterPathConstants.login: (context) => LoginFrame(),
      RouterPathConstants.index: (context) => Index(),
      RouterPathConstants.createQuestion: (context) => Question(),
    },
  ));
}
