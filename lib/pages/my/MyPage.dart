import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/component/dialog/show_toast.dart';
import 'package:flutter_app/component/ui/header_bar.dart';
import 'package:flutter_app/component/ui/label_row.dart';
import 'package:flutter_app/constants/color.dart';
import 'package:flutter_app/constants/defaults.dart';
import 'package:flutter_app/pages/my/ChangeGrade.dart';
import 'package:flutter_app/pages/my/ChangeName.dart';
import 'package:flutter_app/provider/global_model.dart';
import 'package:flutter_app/utils/Image.dart';
import 'package:flutter_app/utils/Network.dart';
import 'package:flutter_app/utils/cache.dart';
import 'package:flutter_app/utils/route.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => new _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final ImagePicker picker = ImagePicker();
  GlobalModel _model;

  _openGallery({type = ImageSource.gallery}) async {
    var image = await picker.getImage(source: type);
    if (image == null) {
      return;
    }
    String headPortrait = await compressToString(File(image.path));
    showToast(context, 'success ');
    _model.headPortrait = headPortrait;
    _model.refresh();
  }

  Widget _body(GlobalModel model) {
    _model = model;

    var content = [
      new LabelRow(
        label: 'Header',
        isLine: true,
        isRight: true,
        rightW: new SizedBox(
          width: 55.0,
          height: 55.0,
          child: new ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: model.headPortrait == null || model.headPortrait == ''
                ? new Image.asset(headPortrait, fit: BoxFit.cover)
                : dynamicAvatar(model.headPortrait),
          ),
        ),
        onPressed: () => _openGallery(),
      ),
      new LabelRow(
        label: 'Name',
        isLine: true,
        isRight: true,
        rValue: model.nickName,
        onPressed: () => routerPush(new ChangeName()),
      ),
      new LabelRow(
        label: 'Grade',
        isLine: true,
        isRight: true,
        rValue: model.grade,
        onPressed: () => routerPush(new ChangeGrade()),
      )
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
            appBar: new HeaderBar(title: 'Personal information'
            ),
            body: Builder(
              builder: (BuildContext ctx) {
                return new SingleChildScrollView(
                    child: _body(ctx.watch<GlobalModel>()));
              },
            )));
  }
}
