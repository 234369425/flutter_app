import 'dart:io';

import 'package:connectivity/connectivity.dart';
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
  String _state = '';
  String _ssid = '';
  final Connectivity _connectivity = new Connectivity();
  var subscription;

  _ExportDataState() {
    _handleRequest();
    Shared.instance.getAccount().then((value) {
      _user = value;
    });
  }

  @override
  void initState() {
    super.initState();
    subscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (this.mounted) {
        if (result != ConnectivityResult.wifi) {
          _state = '当前不是wifi,无法进行数据同步';
        } else {
          _state = '';
        }
        setState(() => _ssid = result.toString());
      }
    });
    _connectivity
        .checkConnectivity()
        .then((value) => {_ssid = value.toString()});
  }

  _handleRequest() async {
    server = await HttpServer.bind(
      InternetAddress.anyIPv4,
      14040,
    );

    await for (var req in server) {
      var uri = req.requestedUri;
      if (uri.path == '/' + _user) {
        req.response.write(await DBOperator.export());
      } else {
        req.response.write("404 not found");
      }
      req.response.close();
    }

    print(server.address);
  }

  @override
  void dispose() {
    super.dispose();
    if (subscription != null) {
      subscription.cancel();
    }
    try {
      server.close(force: true);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appBarColor,
        appBar: new HeaderBar(title: '导出数据'),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
            child: QrImage(
              data: 'flutter_app' + this.widget.name + '@' + this.widget.ip,
              //生成二维码的文字
              size: 200.0,
              //二维码中心图片
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: Size(30, 30), //二维码中心图片大小
              ),
            ),
          ),
          Text('请保持两手机在同一个wifi下'),
          Text('登录同一帐号扫一扫导入'),
          Text(
            _state,
            style: TextStyle(color: Colors.red),
          ),
        ])));
  }
}
