import 'package:flutter/material.dart';
import 'package:flutter_app/constants/urls.dart';
import 'package:flutter_app/utils/http_client.dart';

class UserHeader{

  static var headers = {};

  static init() async{
    HttpClient.send(url_query_user_header, {}, (rs){
      var list = rs['list'];
      for (var data in list) {
        var u = data["map"];
        headers[u["name"]] = u["head"];
      }
    }, (rs){
      print(rs);
    });
  }

  static String get(String user){
    return headers[user]??user;
  }
}