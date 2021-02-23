import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  factory Shared() => _getInstance();

  static Shared get instance => _getInstance();
  static Shared _instance;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  Shared._internal() {
    //初始化
    //init
  }

  static Shared _getInstance() {
    if (_instance == null) {
      _instance = new Shared._internal();
    }
    return _instance;
  }

  void setAccount(String user) async {
    prefs.then((value) => value.setString("user", user));
  }

  Future<String> getAccount() async {
    return prefs.then((v) => v.getString("user"));
  }

  /// save
  Future saveString(String key, String value) async {
    getAccount()
        .then((a) => prefs.then((v) => v.setString(a + ":" + key, value)));
  }

  Future saveInt(String key, int value) async {
    getAccount().then((a) => prefs.then((v) => v.setInt(a + ":" + key, value)));
  }

  Future saveDouble(String key, double value) async {
    getAccount()
        .then((a) => prefs.then((v) => v.setDouble(a + ":" + key, value)));
  }

  Future saveBoolean(String key, bool value) async {
    getAccount()
        .then((a) => prefs.then((v) => v.setBool(a + ":" + key, value)));
  }

  Future saveStringList(String key, List<String> list) async {
    getAccount()
        .then((a) => prefs.then((v) => v.setStringList(a + ":" + key, list)));
  }

  /// get
  Future<String> getString(String key) async {
    return getAccount()
        .then((a) => prefs.then((v) => v.getString(a + ":" + key)));
  }

  Future<int> getInt(String key) async {
    return getAccount().then((a) => prefs.then((v) => v.getInt(a + ":" + key)));
  }

  Future<double> getDouble(String key) async {
    return getAccount()
        .then((a) => prefs.then((v) => v.getDouble(a + ":" + key)));
  }

  Future<bool> getBool(String key) async {
    return getAccount()
        .then((a) => prefs.then((v) => v.getBool(a + ":" + key)));
  }

  Future<List<String>> getStringList(String key) async {
    return getAccount()
        .then((a) => prefs.then((v) => v.getStringList(a + ":" + key)));
  }
}
