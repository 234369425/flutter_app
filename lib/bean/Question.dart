class Question {
  int id;
  String title;
  String image;
  String createTime;
  String content;
  int newMessage;

  Question(this.id, this.title, this.createTime, this.newMessage);

  static Question of(Map<String,dynamic> q){
    Question qt = Question(q["id"], q["title"], q["create_time"], q["new_message"]);
    qt.image = q["image"];
    qt.content = q["content"];
    return qt;
  }

}
