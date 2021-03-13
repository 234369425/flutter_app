import 'dart:convert';

import 'package:flutter_app/utils/toast.dart';
import 'package:http/http.dart' as http;

class HttpClient {
  static send(url, json, success, fail) async {
    try {
      var response = await http.post(url, body: jsonEncode(json));
      var data = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
      success(data);
    } catch (e) {
      if (e == null) {
        fail("");
      } else {
        if(e.toString().contains('SocketException')){
          FtToast.danger('失去网络，请网络恢复后重试！');
        }else {
          fail(e.toString());
        }
      }
    }
  }

  static get(url,success,fail) async{
    try {
      var response = await http.get(url);
      var data = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
      success(data);
    } catch (e) {
      if (e == null) {
        fail("-3");
      } else {
        if(e.toString().contains('SocketException')){
          fail("-1");
        }else {
          fail(e.toString());
        }
      }
    }
  }
}

