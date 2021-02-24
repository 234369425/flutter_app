import 'package:flutter/material.dart';
import 'package:flutter_app/component/dialog/show_toast.dart';
import 'package:flutter_app/component/ui/header_bar.dart';
import 'package:flutter_app/constants/color.dart';
import 'package:flutter_app/provider/global_model.dart';
import 'package:flutter_app/utils/route.dart';
import 'package:provider/provider.dart';

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

  _saveName() {
    if (controller.text == null || controller.text == "") {
      showToast(context, "空用户名");
      return;
    }
    if (controller.text.length > 10) {
      showToast(context, "用户名过长");
      return;
    }

    final model = Provider.of<GlobalModel>(context, listen: false);
    model.nickName = controller.text;
    popRoute();
  }


  @override
  void initState() {
    super.initState();
    controller.text = this.widget.name;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appBarColor,
        appBar: new HeaderBar(title: '修改显示名', rightDMActions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveName)
        ]),
        body: Column(
          children: [
            TextField(
              controller: controller,
            )
          ],
        ));
  }
}
