import 'package:flutter/widgets.dart';
import 'package:flutter_app/provider/auth/global_auth.dart';

class GlobalModel extends ChangeNotifier {
  BuildContext context;

  ///app的名字
  String appName = "Question";

  /// 用户信息
  String account = '';
  String nickName = 'nickName';
  String headPortrait = '';
  int gender = 0;

  ///是否进入登录页
  bool goToLogin = true;
  GlobalAuth logic;

  GlobalModel() {
    logic = GlobalAuth(this);
  }

  void setContext(BuildContext context) {
    if (this.context == null) {
      this.context = context;
      Future.wait([
        logic.getLoginState(),
        logic.getAccount(),
        logic.getNickName(),
        logic.getHeadPortrait(),
        logic.getGender(),
      ]).then((value) {
        refresh();
      });
    }
  }

  void initInfo() async {}

  @override
  void dispose() {
    super.dispose();
    debugPrint("GlobalModel销毁了");
  }

  void refresh() {
    if (!goToLogin) initInfo();
    notifyListeners();
  }
}
