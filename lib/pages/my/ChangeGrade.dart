import 'package:flutter/material.dart';
import 'package:flutter_app/component/dialog/show_toast.dart';
import 'package:flutter_app/component/ui/header_bar.dart';
import 'package:flutter_app/constants/color.dart';
import 'package:flutter_app/provider/global_model.dart';
import 'package:flutter_app/utils/route.dart';
import 'package:provider/provider.dart';

class ChangeGrade extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChangeNameState();
  }
}

class _ChangeNameState extends State<ChangeGrade> {
  TextEditingController controller = TextEditingController();

  _saveName() {
    if (controller.text == null || controller.text == "") {
      showToast(context, "empty user name");
      return;
    }
    if (controller.text.length > 10) {
      showToast(context, "too long");
      return;
    }

    final model = Provider.of<GlobalModel>(context, listen: false);
    model.nickName = controller.text;
    popRouter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appBarColor,
        appBar: new HeaderBar(title: 'Change Grade', rightDMActions: [
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
