import 'package:flutter/material.dart';
import 'package:flutter_app/component/ui/header_bar.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/layout/application.dart';
import 'package:flutter_app/pages/register.dart';
import 'package:flutter_app/utils/route.dart';
import 'package:flutter_app/utils/system.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginFrame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Frame();
}

class Frame extends State<LoginFrame> {
  void check(c) {
    pref.then((value) => value.setString(LoginConstants.userName, c));
  }

  @override
  void initState() {
    super.initState();
    pref.then(
        (value) => {userName.text = value.getString(LoginConstants.userName)});
  }

  final TextEditingController userName = TextEditingController();
  final TextEditingController password = TextEditingController();

  final Future<SharedPreferences> pref = SharedPreferences.getInstance();

  void _submit() {
    //todo validate input text
    if (userName.value == '') {}
    pushAndRemoveRoute(ApplicationLayout());
  }

  void _register() {
    pushRoute(Register());
  }

  void _dropDownChanged(dynamic v) {
    print(v);
  }

  @override
  Widget build(BuildContext context) {
    SystemUtil.hideSoftKeyBoard(context);
    return Scaffold(
        appBar: new HeaderBar(title: 'Login'),
        body: Center(
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.text,
                controller: userName,
                decoration: InputDecoration(
                  labelText: 'user name',
                  icon: Icon(Icons.supervised_user_circle_rounded),
                ),
                onChanged: check,
              ),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                controller: password,
                decoration: InputDecoration(
                    labelText: 'password',
                    icon: Icon(Icons.lock_outline_sharp)),
              ),
              Row(
                children: [
                  SystemUtil.emptyExpanded(4),
                  Expanded(
                      flex: 4,
                      child: RaisedButton(
                          onPressed: _submit, child: Text('Login'))),
                  SystemUtil.emptyExpanded(2),
                  Expanded(
                      flex: 4,
                      child: RaisedButton(
                          onPressed: _register, child: Text('Register'))),
                  SystemUtil.emptyExpanded(4),
                ],
              )
            ],
          ),
        ));
  }
}
