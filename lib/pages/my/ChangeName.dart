import 'package:flutter/material.dart';
import 'package:flutter_app/component/ui/header_bar.dart';
import 'package:flutter_app/constants/color.dart';
import 'package:provider/provider.dart';

class ChangeName extends StatefulWidget {
  final String name;

  ChangeName({this.name});

  @override
  State<StatefulWidget> createState() {
    return _ChangeNameState();
  }
}

class _ChangeNameState extends State<ChangeName> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        child: new Scaffold(
            backgroundColor: appBarColor,
            appBar: new HeaderBar(title: 'Change Name'),
            body: Column(
              children: [
                TextField(
                  controller: controller,
                )
              ],
            )));
  }
}
