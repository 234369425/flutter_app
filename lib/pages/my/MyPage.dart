import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/component/dialog/show_toast.dart';
import 'package:flutter_app/component/ui/header_bar.dart';
import 'package:flutter_app/component/ui/label_row.dart';
import 'package:flutter_app/constants/color.dart';
import 'package:flutter_app/constants/defaults.dart';
import 'package:flutter_app/constants/urls.dart';
import 'package:flutter_app/pages/login.dart';
import 'package:flutter_app/pages/my/ChangeGrade.dart';
import 'package:flutter_app/pages/my/ChangeName.dart';
import 'package:flutter_app/pages/my/ExportData.dart';
import 'package:flutter_app/pages/my/ImportData.dart';
import 'package:flutter_app/provider/global_model.dart';
import 'package:flutter_app/utils/Image.dart';
import 'package:flutter_app/utils/http_client.dart';
import 'package:flutter_app/utils/route.dart';
import 'package:flutter_app/utils/rtm_message.dart';
import 'package:flutter_app/utils/shared_util.dart';
import 'package:flutter_app/utils/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => new _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final ImagePicker picker = ImagePicker();
  var shared = Shared.instance;
  var name;
  var head;
  var grade;
  var account = '';
  String ipAddress = '';


  @override
  void initState() {
    super.initState();
    _loadIp();
  }

  _loadIp() async {

    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        ipAddress = addr.address;
      }
    }
    print(ipAddress);
  }

  _openGallery({type = ImageSource.gallery}) async {
    var image;
    try {
      image = await ImagePicker.pickImage(source: type);
      //image = await picker.getImage(source: type);
    } catch (e) {
      FtToast.danger("请授予相机相册访问权限！");
      return;
    }
    if (image == null) {
      return;
    }
    String headPortrait =
        await compressToString(File(image.path), width: 80, height: 80);
    Shared.instance.getAccount().then((value) => {
          HttpClient.send(
              url_update_user, {'user': value, 'head': headPortrait}, (s) {
            Shared.instance.saveString('head', headPortrait);
          }, () {})
        });
    showToast(context, 'success ');
  }

  _loadInfo() async {
    await shared.getString("displayName").then((value) => {
          if (this.mounted)
            {
              this.setState(() {
                name = value;
              })
            }
        });

    await shared.getString("head").then((value) => {
          if (this.mounted)
            {
              this.setState(() {
                if (value == null || value == "") {
                  head = headPortrait;
                } else {
                  head = value;
                }
              })
            }
        });

    await shared.getAccount().then((value) => {
          if (this.mounted)
            {
              this.setState(() {
                account = value;
              })
            }
        });
  }

  Widget _body() {
    _loadInfo();

    var content = [
      new LabelRow(
        label: '头像',
        isLine: true,
        isRight: true,
        rightW: new SizedBox(
          width: 55.0,
          height: 55.0,
          child: new ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: ImageUtils.dynamicAvatar(head),
          ),
        ),
        onPressed: () => _openGallery(),
      ),
      new LabelRow(
        label: '名字',
        isLine: true,
        isRight: true,
        rValue: name,
        onPressed: () => pushRoute(new ChangeName(name), callback: () {
          _loadInfo();
        }),
      ),
      new LabelRow(
        label: '数据导出',
        isLine: true,
        isRight: true,
        onPressed: () => pushRoute(new ExportData(account, ipAddress)),
      ),
      new LabelRow(
        label: '数据导入',
        onPressed: () {
          pushRoute(new ImportData(account));
        },
      ),
      /*
      new LabelRow(
        label: '班级',
        isLine: true,
        isRight: true,
        rValue: grade,
        onPressed: () => pushRoute(new ChangeGrade()),
      ),*/
    ];

    return new Column(children: content);
  }

  @override
  Widget build(BuildContext context) {
    return new ChangeNotifierProvider(
        create: (context) => GlobalModel(),
        child: new Scaffold(
            backgroundColor: appBarColor,
            appBar: new HeaderBar(
                title: '个人资料'
                    ''),
            body: Builder(
              builder: (BuildContext ctx) {
                return new SingleChildScrollView(child: _body());
              },
            ),
            bottomNavigationBar: Row(
              children: [
                Expanded(
                    child: RaisedButton(
                  child: Text('退出登陆'),
                  onPressed: () => {
                    RTMMessage.logout(),
                    pushAndRemoveRoute(new LoginFrame())
                  },
                ))
              ],
            )));
  }
}
