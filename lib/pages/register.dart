import 'package:flutter/material.dart';
import 'package:flutter_app/component/ui/header_bar.dart';
import 'package:flutter_app/utils/route.dart';
import 'package:flutter_app/utils/system.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  final TextEditingController userName = TextEditingController();
  final TextEditingController password = TextEditingController();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode userNameFocus = FocusNode();

  var teacher = false;

  _checkUserName(dynamic v) {
    print(v);
  }

  _submit() {
    if (userName.value.text.trim() == "") {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          msg: "user name is empty",
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white);
      userNameFocus.requestFocus();
      return;
    }
    if(password.value.text.trim() == ""){
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          msg: "password is empty",
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white);
      passwordFocus.requestFocus();
    }

  }

  _loginPage() {
    popRoute();
  }

  @override
  Widget build(BuildContext context) {
    SystemUtil.hideSoftKeyBoard(context);
    return Scaffold(
      appBar: new HeaderBar(title: 'Register'),
      body: Column(
        children: [
          TextField(
            keyboardType: TextInputType.text,
            controller: userName,
            focusNode: userNameFocus,
            decoration: InputDecoration(
              labelText: 'user name',
              icon: Icon(Icons.supervised_user_circle_rounded),
            ),
            onChanged: _checkUserName,
          ),
          Row(
            children: [
              Icon(Icons.accessibility_new_sharp),
              Text('     teacher'),
              Switch(
                  value: teacher,
                  onChanged: (v) {
                    setState(() {
                      teacher = v;
                    });
                  })
            ],
          ),
          TextField(
            keyboardType: TextInputType.visiblePassword,
            controller: password,
            focusNode: passwordFocus,
            decoration: InputDecoration(
                labelText: 'password', icon: Icon(Icons.lock_outline)),
          ),
          Row(
            children: [
              SystemUtil.emptyExpanded(4),
              Expanded(
                  flex: 4,
                  child:
                      RaisedButton(onPressed: _submit, child: Text('Submit'))),
              SystemUtil.emptyExpanded(2),
              Expanded(
                  flex: 4,
                  child: RaisedButton(
                      onPressed: _loginPage, child: Text('To login'))),
              SystemUtil.emptyExpanded(4),
            ],
          )
        ],
      ),
    );
  }
}
