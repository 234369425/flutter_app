import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
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
    pref.then((value) => {
      userName.text = value.getString(LoginConstants.userName)
    });
  }

  final TextEditingController userName = TextEditingController();
  final TextEditingController password = TextEditingController();
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();

  void _submit() {
    //todo validate input text
    Navigator.popAndPushNamed(context, RouterPathConstants.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
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
              RaisedButton(onPressed: _submit, child: Text('Login'))
            ],
          ),
        ));
  }
}
