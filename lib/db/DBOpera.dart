import 'package:flutter_app/bean/Question.dart';
import 'package:flutter_app/bean/Relay.dart';
import 'package:flutter_app/utils/shared_util.dart';
import 'package:sqflite/sqflite.dart';

class DBOperator {
  static Future<Database> init() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'chart.db';
    var database = openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      if (version == 1) {
        db.execute('create table Question('
            'id INTEGER PRIMARY KEY autoincrement, '
            'type INTEGER default 0,'
            'user TEXT,'
            'title TEXT,'
            'image TEXT,'
            'content TEXT,'
            'create_time TIMESTAMP default (datetime(\'now\', \'localtime\')),'
            'new_message INTEGER default 0)');

        db.execute('create table Relay('
            'id INTEGER PRIMARY KEY autoincrement,'
            'question_id INTEGER,'
            'user TEXT,'
            'image TEXT,'
            'content TEXT,'
            'receive_time TIMESTAMP default (datetime(\'now\', \'localtime\')),'
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

  static Future<List<Question>> listQuestion() async {
    var database = await init();
    List<Map> list =
        await database.rawQuery("select id, title, create_time, new_message "
            "from Question order by create_time desc,new_message desc");
    var result = List<Question>();
    for (var v in list) {
      result.add(new Question(v["id"], v["title"], v["create_time"],
          v["new_message"] == null ? 0 : v["new_message"]));
    }
    return result;
  }

  static void insertRelay(Relay relay) async {
    var database = await init();
    var params = [];
    params.add(relay.questionId);
    params.add(relay.user);
    params.add(relay.image);
    params.add(relay.content);
    await database.rawInsert(
        "insert into Relay(question_id,user,image,content,receive_time) values (?,?,?,?,datetime(\'now\', \'localtime\'))",
        params);
  }

  static Future<List<Relay>> queryRelay(int id) async {
    var database = await init();
    var params = new List();
    params.add(id);
    List<Map> relays = await database.rawQuery(
        "select * from Relay where question_id = ?", params);
    List<Relay> result = List<Relay>();
    for (var relay in relays) {
      Relay r = Relay();
      r.id = relay["id"];
      r.questionId = relay["question_id"];
      r.user = relay["user"];
      r.image = relay["image"];
      r.content = relay["content"];
      r.time = relay["receive_time"];
      result.add(r);
    }
    return result;
  }

  static void insertQuestion(String title, String image, String detail) async {
    var database = await init();
    var params = new List();
    params.add(await Shared.instance.getAccount());
    params.add(title);
    params.add(image);
    params.add(detail);
    database.rawInsert(
        'insert into Question(user,title,image,content) values (?,?,?,?)',
        params);
  }

  static void deleteQuestion(int id) async {
    var data = [];
    data.add(id);
    var database = await init();
    database.delete("Question", where: "id = ?", whereArgs: data);
  }

  static Future<Question> viewQuestion(int id) async {
    var data = [];
    data.add(id);
    var database = await init();
    var q = await database.query("Question", where: "id = ?", whereArgs: data);
    return Question.of(q[0]);
  }
}
