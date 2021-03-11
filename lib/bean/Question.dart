import 'package:flutter_app/bean/Relay.dart';

class Question {
  int id;
  String title;
  String head;
  String image;
  String createTime;
  String content;
  String user;
  String relayUser;
  int newMessage;
  int ct;

  Question(this.id, this.title, this.createTime, this.newMessage);

  static Question of(Map<String, dynamic> q) {
    Question qt =
        Question(q["id"], q["title"], q["create_time"], q["new_message"]);
    qt.image = q["image"];
    qt.content = q["content"];
    return qt;
  }

  Relay toRelay() {
    Relay relay = Relay();
    relay.image = this.image;
    relay.content = this.content;
    relay.time = this.createTime;
    relay.user = this.user;
    return relay;
  }
}
