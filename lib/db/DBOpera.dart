import 'package:flutter_app/bean/Question.dart';
import 'package:sqflite/sqflite.dart';

class DBOperator {
  Future<Database> init() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'chart.db';
    var database = openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      if (version == 1) {
        db.execute('create table Question('
            'id INTEGER PRIMARY KEY autoincrement, '
            'type INTEGER default 0,'
            'title TEXT,'
            'image TEXT,'
            'content TEXT,'
            'create_time TIMESTAMP default (datetime(\'now\', \'localtime\')),'
            'new_message INTEGER default 0)');

        db.execute('create table Answer('
            'id INTEGER PRIMARY KEY autoincrement,'
            'question_id INTEGER,'
            'user_id INTEGER,'
            'image TEXT,'
            'content TEXT,'
            'receive_time TIMESTAMP,'
            'is_read INTEGER default 0'
            ')');

        db.execute('create table user('
            'id INTEGER PRIMARY KEY autoincrement,'
            'nick_name TEXT,'
            'head_image TEXT'
            ')');
      }
    });
    return database;
  }

  Future<List<Question>> listQuestion() async {
    var database = await init();
    List<Map> list = await database.rawQuery(
        "select id, title,create_time from Question order by create_time desc,new_message desc");
    var result = List<Question>();
    for (var v in list) {
      result.add(Question(v["id"], v["title"], v["create_time"], v["new_message"]) == null ? 0 : v["new_message"]);
    }
    return result;
  }

  void insertQuestion(String title, String image, String detail) async {
    var database = await init();
    var params = new List();
    params.add(title);
    params.add(image);
    params.add(detail);
    database.rawInsert(
        'insert into Question(title,image,content) values (?,?,?)', params);
  }

  void deleteQuestion(int id) async {
    var data = List();
    data.add(id);
    var database = await init();
    database.delete("Question", where: "id = ?", whereArgs: data);
  }

  Future<Question> viewQuestion(int id) async {
    var data = List();
    data.add(id);
    var database = await init();
    var q = await database.query("Question", where: "id = ?", whereArgs: data);
    return Question.of(q[0]);
  }
}
