import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/component/ui/header_bar.dart';
import 'package:flutter_app/constants/color.dart';
import 'package:flutter_app/db/DBOpera.dart';
import 'package:flutter_app/utils/http_client.dart';
import 'package:flutter_app/utils/route.dart';
import 'package:flutter_app/utils/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:last_qr_scanner/last_qr_scanner.dart';

class ImportData extends StatefulWidget {
  String user;

  ImportData(this.user);

  @override
  State<StatefulWidget> createState() {
    return _ImportDataState();
  }
}

class _ImportDataState extends State<ImportData> {
  String text = '相机启动中...';
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    _init();
  }

  void _onQRViewCreated(QRViewController controller) {
    final channel = controller.channel;
    controller.init(qrKey);
    channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case "onRecognizeQR":
          dynamic arguments = call.arguments;
          String text = arguments.toString();
          if (!text.startsWith("flutter_app")) {
            FtToast.danger('不支持的二维码');
            popRoute();
            return;
          }
          text = text.substring("flutter_app".length);
          var user = text.substring(0, text.indexOf("@"));
          if (this.widget.user != user) {
            FtToast.danger('不是相同账户，无法继续执行');
            popRoute();
            return;
          }
          var ipAddress = text.substring(text.indexOf("@") + 1);
          var url = "http://" + ipAddress + ":14040/" + user;

          this.setState(() {
            this.text = '正在发现对方设备...';
          });
          _import(url);
      }
    });
  }

  _init() async {
    var result = await Permission.camera.request();

    if (result.isGranted) {
      print('拥有相机权限');
      this.setState(() {
        this.text = '等待扫码';
      });
    } else {
      FtToast.danger('缺少相机权限，无法执行');
      popRoute();
    }
  }

  _import(String url) async {
    HttpClient.get(url, (data) {
      print(data);
      DBOperator.import(data, () {
        FtToast.danger('任务完成');
        popRoute();
      });
    }, (e) {
      if (e == '-1') {
        this.setState(() {
          this.text = '没有找到设备,请检查是否在同一wifi';
        });
      } else {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appBarColor,
        appBar: new HeaderBar(title: '导入数据'),
        body: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
          Text(text),
          LastQrScannerPreview(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          text == '等待扫码'? TextButton(onPressed: _init, child: Text('打开相机')) : Container()
        ])));
  }
}
