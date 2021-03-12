import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/component/ui/header_bar.dart';
import 'package:flutter_app/constants/color.dart';
import 'package:flutter_app/db/DBOpera.dart';
import 'package:flutter_app/utils/shared_util.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ExportData extends StatefulWidget {
  final String name;
  final String ip;

  ExportData(this.name, this.ip);

  @override
  State<StatefulWidget> createState() {
    return _ExportDataState();
  }
}

class _ExportDataState extends State<ExportData> {

  HttpServer server;
  String _user = '';

  _ExportDataState() {
    _handleRequest();
    Shared.instance.getAccount().then((value){
      _user = value;
    });
  }

  _handleRequest( ) async{

    server = await HttpServer.bind(
      InternetAddress.anyIPv4,
      14040,
    );

    await for(var req in server){
      var uri = req.requestedUri;
      if(uri.path == '/' + _user){
        req.response.write(await DBOperator.export());
      }else {
        req.response.write("404 not found");
      }
      req.response.close();
    }

    print(server.address);

  }


  @override
  void dispose() {
    super.dispose();
    try {
      server.close(force: true);
    }catch(e){

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appBarColor,
        appBar: new HeaderBar(title: '导出数据'),
        body: Column(children: [
          Center(
            child: QrImage(
              data: this.widget.name,
              //生成二维码的文字
              size: 200.0,
              //二维码中心图片
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: Size(30, 30), //二维码中心图片大小
              ),
            ),
          )
        ]));
  }
}
