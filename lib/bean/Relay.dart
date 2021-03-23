import 'dart:convert';

class Relay {
  int id;
  int questionId;
  String title;
  String user;
  String image;
  String content;
  String time;
  int isRead;
  int tid;
  int sec;
  int all;

  String showTime(String s) {
    DateTime t = DateTime.parse(s);
    DateTime th = DateTime.parse(time);

    bool show =
        th.microsecondsSinceEpoch - t.microsecondsSinceEpoch > 3 * 60 * 1000 * 1000;
    if (!show) {
      return "";
    }
    DateTime now = DateTime.now();
    if (th.day == t.day && t.month == th.month) {
      if (th.day == now.day && th.month == now.month) {
        return time.substring(time.indexOf(" "));
      }
    }
    return time;
  }

  String timeString() {
    DateTime th = DateTime.parse(time);
    DateTime now = DateTime.now();
    if (th.day == now.day && th.month == now.month) {
      return time.substring(time.indexOf(" "));
    }
    return time;
  }

  static Relay fromJson(Map<String,dynamic> json){
    var relay = Relay();
    relay.questionId = json['questionId'];
    relay.user = json['user'];
    relay.image = json['image'];
    relay.content = json['content'];
    relay.title = json['title'];
    relay.time = json['time'];
    relay.tid = json['tid'];
    relay.sec = json['sec'];
    relay.all = json['all'];
    relay.isRead = 0;
    return relay;
  }

  String toJsonStr(){
    var result = <String,dynamic> {};
    if(questionId != null){
      result['questionId'] = questionId;
    }

    if(user != null){
      result['user'] = user;
    }

    if(image != null){
      result['image'] = image;
    }

    if(content != null){
      result['content'] = content;
    }

    if(title != null){
      result['title'] = title;
    }

    if(time != null){
      result['time'] = time;
    }

    if(tid != null){
      result['tid'] = tid;
    }

    if(sec != null){
      result['sec'] = sec;
    }

    if(all != null){
      result['all'] = all;
    }

    return jsonEncode(result);
  }
}
