class Question {
  int id;
  String title;
  String image;
  String createTime;
  int newMessage;

  Question(this.id, this.title, this.createTime, this.newMessage);

  static Question of(Map<String,dynamic> q){
    return Question(q["id"], q["title"], q["image"], q["new_message"]);
  }

}
