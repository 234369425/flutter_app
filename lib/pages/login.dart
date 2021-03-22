import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/component/ui/header_bar.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/constants/defaults.dart';
import 'package:flutter_app/constants/urls.dart';
import 'package:flutter_app/layout/application.dart';
import 'package:flutter_app/pages/register.dart';
import 'package:flutter_app/provider/login_model.dart';
import 'package:flutter_app/utils/http_client.dart';
import 'package:flutter_app/utils/route.dart';
import 'package:flutter_app/utils/rtm_message.dart';
import 'package:flutter_app/utils/shared_util.dart';
import 'package:flutter_app/utils/system.dart';
import 'package:flutter_app/utils/toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginFrame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Frame();
}

class Frame extends State<LoginFrame> {
  var subscription;
  bool hasNetwork = true;

  void check(c) {
    pref.then((value) => value.setString(LoginConstants.userName, c));
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    pref.then(
        (value) => {userName.text = value.getString(LoginConstants.userName)});
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!
      this.setState(() {
        if (result == ConnectivityResult.none) {
          FtToast.danger("失去网络连接！");
          hasNetwork = false;
        } else {
          hasNetwork = true;
        }
      });
    });
  }

  final TextEditingController userName = TextEditingController();
  final TextEditingController password = TextEditingController();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode userNameFocus = FocusNode();
  LoginModel model;
  var loading = false;

  final Future<SharedPreferences> pref = SharedPreferences.getInstance();

  void _submit() {
    if (userName.value.text.trim() == '') {
      FtToast.danger('用户名不能为空');
      userNameFocus.requestFocus();
      return;
    }

    if (password.value.text.trim() == '') {
      FtToast.danger('密码不能为空');
      passwordFocus.requestFocus();
      return;
    }

    this.setState(() {
      this.loading = true;
    });
    HttpClient.send(url_login,
        {'name': userName.value.text, 'password': password.value.text}, (resp) {
      if (resp['code'] == 0) {
        var role = resp['data']['role'];
        var head = resp['data']['head'];
        var grade = resp['data']['grade'];
        var shared = Shared.instance;
        shared.setAccount(userName.text.trim());
        shared.saveString("head", head);
        shared.saveString("grade", grade);
        shared.saveString("role", role);
        shared.saveString("displayName", resp['data']['displayName']);
        pushAndRemoveRoute(ApplicationLayout(role));
        try {
          RTMMessage.init(userName.text.trim());
        }catch(e){
          print(e.toString());
        }
      } else {
        FtToast.danger('用户名或密码错误！');
      }
      this.setState(() {
        this.loading = false;
      });
    }, (s) {
      FtToast.danger('无法连接服务器，请稍后再试！');
      this.setState(() {
        this.loading = false;
      });
    });
  }

  void _register() {
    pushRoute(Register());
  }

  @override
  Widget build(BuildContext context) {
    SystemUtil.hideSoftKeyBoard(context);
    Provider.of<LoginModel>(context)..setContext(context);

    return Scaffold(
        appBar: new HeaderBar(title: hasNetwork?'Login':'等待网络恢复',mainColor: hasNetwork?Colors.black54:Colors.red,),
        body: Center(
          child: Column(
            children: [

              TextField(
                keyboardType: TextInputType.text,
                controller: userName,
                focusNode: userNameFocus,
                decoration: InputDecoration(
                  labelText: '用户名',
                  icon: Icon(Icons.supervised_user_circle_rounded),
                ),
                onChanged: check,
              ),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                controller: password,
                obscureText: true,
                focusNode: passwordFocus,
                decoration: InputDecoration(
                    labelText: '密码', icon: Icon(Icons.lock_outline_sharp)),
              ),
              Row(
                children: [
                  SystemUtil.emptyExpanded(4),
                  Expanded(
                      flex: 4,
                      child: !loading
                          ? RaisedButton(
                              onPressed: hasNetwork?_submit:null,
                              child: Text('登陆'),
                            )
                          : RaisedButton(
                              child: Text('登录中'),
                              onPressed: null,
                            )),
                  SystemUtil.emptyExpanded(2),
                  Expanded(
                      flex: 4,
                      child: !loading
                          ? RaisedButton(
                              onPressed: hasNetwork?_register:null, child: Text('注册'))
                          : RaisedButton(
                              child: Text('注册'),
                              onPressed: null,
                            )),
                  SystemUtil.emptyExpanded(4),
                ],
              ),
            ],
          ),
        ));
  }
}
