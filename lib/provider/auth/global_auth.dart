import 'package:flutter_app/constants/SaveKeys.dart';
import 'package:flutter_app/provider/global_model.dart';
import 'package:flutter_app/utils/shared_util.dart';

class GlobalAuth {
  final GlobalModel _model;

  GlobalAuth(this._model);

  Future getNickName() async {
    _model.nickName = await Shared.instance.getString(userName);
  }

  Future getHeadPortrait() async {
    _model.headPortrait = await Shared.instance.getString(userHeader);
  }

  Future getGender() async {
    _model.gender = await Shared.instance.getInt(userGender);
  }

  Future getLoginState() async {
    return Shared.instance.getAccount() == null;
  }

  Future getAccount() async {
    _model.account = await Shared.instance.getAccount();
  }
}
