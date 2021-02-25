import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpClient{
  static send(url, json, success, fail) async {
    try {
      var response = await http.post(url, body: jsonEncode(json));
      var data = jsonDecode(response.body);
      if (data["code"] != 0) {
        fail(data);
      } else {
        success(data);
      }
    } catch (e) {
      fail(e.toString());
    }
  }
}

