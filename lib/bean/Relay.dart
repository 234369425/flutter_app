import 'dart:convert';

class Relay {
  int id;
  int questionId;
  String user;
  String image;
  String content;
  String time;
  int isRead;

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
    relay.isRead = 0;
    return relay;
  }

  String toJsonStr(){
    return jsonEncode(<String,dynamic>{
      'questionId': this.questionId,
      'user':this.user,
      'image': this.image,
      'content' : this.content
    });
  }
}
