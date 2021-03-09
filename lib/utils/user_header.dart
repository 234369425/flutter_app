import 'package:flutter/material.dart';
import 'package:flutter_app/constants/urls.dart';
import 'package:flutter_app/utils/http_client.dart';

class UserHeader{

  static var data = {};

  static init() async{
    HttpClient.send(url_query_user_header, {}, (rs){
      var list = rs.list;

      print(rs);
    }, (rs){
      print(rs);
    });
  }

  static String get(String user){
    return data[user]??user;
  }
}