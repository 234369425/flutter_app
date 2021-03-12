import 'package:flutter/material.dart';
import 'package:flutter_app/component/dialog/show_toast.dart';
import 'package:flutter_app/component/ui/header_bar.dart';
import 'package:flutter_app/constants/color.dart';
import 'package:flutter_app/constants/urls.dart';
import 'package:flutter_app/utils/http_client.dart';
import 'package:flutter_app/utils/route.dart';
import 'package:flutter_app/utils/shared_util.dart';
import 'package:flutter_app/utils/toast.dart';

class ChangeName extends StatefulWidget {
  final String name;

  ChangeName(this.name);

  @override
  State<StatefulWidget> createState() {
    return _ChangeNameState();
  }
}

class _ChangeNameState extends State<ChangeName> {
  TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  _saveName() {
    if (controller.text == null || controller.text == "") {
      showToast(context, "空用户名");
      return;
    }
    if (controller.text.length > 15) {
      showToast(context, "用户名过长");
      return;
    }

    Shared.instance.getAccount().then((value) => HttpClient.send(
            url_update_user,
            {'user': value, 'displayName': controller.value.text}, (data) {
          Shared.instance.saveString("displayName", controller.text);
          popRoute();
        }, (cause) {
          FtToast.danger("更新失败");
        }));
  }

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    controller.text = this.widget.name;

    return Scaffold(
        backgroundColor: appBarColor,
        appBar: new HeaderBar(title: '修改显示名', rightDMActions: [
          TextButton(onPressed: _saveName, child: Text('完成'))
        ]),
        body: Column(
          children: [
            TextField(
              controller: controller,
              focusNode: focusNode,
            )
          ],
        ));
  }
}
