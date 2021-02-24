import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/component/ui/header_bar.dart';
import 'package:flutter_app/constants/urls.dart';
import 'package:flutter_app/utils/route.dart';
import 'package:flutter_app/utils/system.dart';
import 'package:flutter_app/utils/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  final TextEditingController userName = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController displayName = TextEditingController();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode userNameFocus = FocusNode();
  final FocusNode displayNameFocus = FocusNode();

  var teacher = false;

  _submit() {
    if (userName.value.text.trim() == "") {
      FtToast.danger("用户不能为空！");
      userNameFocus.requestFocus();
      return;
    }
    if (password.value.text.trim() == "") {
      FtToast.danger("密码不能为空！");
      passwordFocus.requestFocus();
    }
    if (displayName.value.text.trim() == "") {
      FtToast.danger("显示名不能为空");
      displayNameFocus.requestFocus();
    }
    _send((rs) {
      var resp = jsonDecode(rs);
      if (resp["code"] == 0) {
        popRoute();
      } else {
        var msg = "服务器内部错误";
        if (resp["code"] == 501) {
          msg = "用户已存在";
        }
        FtToast.danger(msg);
        print('error');
      }
    }, () {
      Fluttertoast.showToast(msg: "连接服务器失败，请稍后尝试！");
    });
  }

  _send(success, fail) async {
    try {
      var response = await http.post(url_register,
          body: jsonEncode(<String, String>{
            'name': userName.value.text,
            'displayName': displayName.value.text,
            'password': password.value.text,
            'teacher': teacher ? "1" : "0"
          }));
      success(response.body);
      print(response);
    } catch (e) {
      fail();
    }
  }

  _loginPage() {
    popRoute();
  }

  @override
  Widget build(BuildContext context) {
    SystemUtil.hideSoftKeyBoard(context);
    return Scaffold(
      appBar: new HeaderBar(title: '注册'),
      body: Column(
        children: [
          TextField(
            keyboardType: TextInputType.text,
            controller: userName,
            focusNode: userNameFocus,
            decoration: InputDecoration(
              labelText: '用户名',
              icon: Icon(Icons.supervised_user_circle_rounded),
            ),
          ),
          TextField(
            keyboardType: TextInputType.text,
            controller: displayName,
            focusNode: displayNameFocus,
            decoration: InputDecoration(
              labelText: '显示名',
              icon: Icon(Icons.accessibility_new),
            ),
          ),
          Row(
            children: [
              Icon(Icons.accessibility_new_sharp),
              Text('     教师'),
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
                labelText: '密码', icon: Icon(Icons.lock_outline)),
          ),
          Row(
            children: [
              SystemUtil.emptyExpanded(4),
              Expanded(
                  flex: 4,
                  child: RaisedButton(onPressed: _submit, child: Text('注册'))),
              SystemUtil.emptyExpanded(2),
              Expanded(
                  flex: 4,
                  child:
                      RaisedButton(onPressed: _loginPage, child: Text('返回'))),
              SystemUtil.emptyExpanded(4),
            ],
          )
        ],
      ),
    );
  }
}
