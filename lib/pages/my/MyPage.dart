import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/component/dialog/show_toast.dart';
import 'package:flutter_app/component/ui/header_bar.dart';
import 'package:flutter_app/component/ui/label_row.dart';
import 'package:flutter_app/constants/color.dart';
import 'package:flutter_app/constants/defaults.dart';
import 'package:flutter_app/pages/login.dart';
import 'package:flutter_app/pages/my/ChangeGrade.dart';
import 'package:flutter_app/pages/my/ChangeName.dart';
import 'package:flutter_app/provider/global_model.dart';
import 'package:flutter_app/provider/login_model.dart';
import 'package:flutter_app/utils/Image.dart';
import 'package:flutter_app/utils/Network.dart';
import 'package:flutter_app/utils/cache.dart';
import 'package:flutter_app/utils/route.dart';
import 'package:flutter_app/utils/shared_util.dart';
import 'package:flutter_app/utils/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => new _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final ImagePicker picker = ImagePicker();
  var shared = Shared.instance;
  var name ;
  GlobalModel _model;

  _openGallery({type = ImageSource.gallery}) async {
    var image;
    try {
      image = await picker.getImage(source: type);
    } catch (e) {
      FtToast.danger("请授予相机相册访问权限！");
      return;
    }
    if (image == null) {
      return;
    }
    String headPortrait = await compressToString(File(image.path));
    showToast(context, 'success ');

    _model.head = headPortrait;
    _model.refresh();
  }

  _loadInfo() async{
    await shared.getString("displayName");
  }

  Widget _body(GlobalModel model) {
    _model = model;
    shared.getString("displayName").then((value) => this.setState(() {
      name = value;
    }));

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
            child: model.head == null || model.head == ''
                ? new Image.asset(headPortrait, fit: BoxFit.cover)
                : dynamicAvatar(model.head),
          ),
        ),
        onPressed: () => _openGallery(),
      ),
      new LabelRow(
        label: '名字',
        isLine: true,
        isRight: true,
        rValue: name,
        onPressed: () => pushRoute(new ChangeName(name)),
      ),
      new LabelRow(
        label: '班级',
        isLine: true,
        isRight: true,
        rValue: model.grade,
        onPressed: () => pushRoute(new ChangeGrade()),
      ),
    ];

    return new Column(children: content);
  }

  Widget dynamicAvatar(avatar, {size}) {
    if (isInternetImage(avatar)) {
      return new CachedNetworkImage(
          imageUrl: avatar,
          cacheManager: cacheManager,
          width: size ?? null,
          height: size ?? null,
          fit: BoxFit.fill);
    } else {
      return new Image.asset(avatar,
          fit: BoxFit.fill, width: size ?? null, height: size ?? null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new ChangeNotifierProvider(
        create: (context) => GlobalModel(),
        child: new Scaffold(
            backgroundColor: appBarColor,
            appBar: new HeaderBar(title: '个人资料'
                ''),
            body: Builder(
              builder: (BuildContext ctx) {
                return new SingleChildScrollView(
                    child: _body(ctx.watch<GlobalModel>()));
              },
            ),
            bottomNavigationBar: Row(
              children: [
                Expanded(child: RaisedButton(child:Text('退出登陆'),onPressed: () => pushAndRemoveRoute(new LoginFrame()),))
              ],
            )
        ));
  }
}
