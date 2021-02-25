import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FtToast {

  static warning(String msg){
    Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: msg,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.yellow,
        textColor: Colors.black);
  }

  static danger(String msg){
    Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: msg,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

}