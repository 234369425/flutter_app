import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/bean/Question.dart';
import 'package:flutter_app/bean/Relay.dart';
import 'package:flutter_app/component/ui/custom_button.dart';
import 'package:flutter_app/component/ui/header_bar.dart';
import 'package:flutter_app/db/DBOpera.dart';
import 'package:flutter_app/utils/system.dart';
import 'package:keyboard_manager/keyboard_manager.dart';

class QuestionDetail extends StatefulWidget {
  final Question q;

  QuestionDetail(this.q);

  @override
  State<StatefulWidget> createState() {
    return _QuestionDetailState(this.q.id);
  }
}

class _QuestionDetailState extends State<QuestionDetail> {
  Question _question = Question(-1, "loading", "loading", 2);
  TextEditingController controller = new TextEditingController();
  ScrollController scrollController = new ScrollController();
  var relays = <Relay>[];
  var commit = false;
  FocusNode focusNode = FocusNode();

  _QuestionDetailState(int id) {
    DBOperator.viewQuestion(id).then((value) => {
          this.setState(() {
            _question.id = value.id;
            _question.title = value.title;
            relays.add(value.toRelay());

            DBOperator.queryRelay(id).then((value) => {
              relays.addAll(value)
            });
          })
        });
  }

  _sendMessage() {
    var relay = Relay();
    relay.questionId = _question.id;
    relay.content = controller.text;
    relay.time = DateTime.now().toIso8601String();
    relays.add(relay);
    controller.text = "";
    commit = false;
    DBOperator.insertRelay(relay);
    this.setState(() {
      //scrollController.jumpTo(this.context.size.height - SystemUtil.keyBoardHeight(context));
    });
//    focusNode.unfocus();
  }

  _createRow(int index) {
    Relay q = relays[index];
    GlobalKey textKey = GlobalKey();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: new InkWell(
            child: q.user == null
                ? Text('')
                : new Image.asset('assets/images/def_head_portrait.png',
                    width: 25, fit: BoxFit.cover, gaplessPlayback: true),
          ),
        ),
        Expanded(
            flex: 8,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: q.user == null
                      ? LinearGradient(
                          colors: [Colors.lightGreen, Colors.lightGreen])
                      : LinearGradient(
                          colors: [Colors.black12, Colors.black12]),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Text(q.content, key: textKey),
                ))),
        Expanded(
            flex: 2,
            child: Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: Container(
                  child: q.user == null
                      ? new Image.asset('assets/images/def_head_portrait.png',
                          fit: BoxFit.cover, gaplessPlayback: true)
                      : Text(''),
                )))
      ],
    );
  }

  _addPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new HeaderBar(title: _question.title),
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: ListView.builder(
              itemCount: relays.length,
              itemBuilder: (context, i) => _createRow(i),
              controller: scrollController,
              shrinkWrap: true,
              padding: SystemUtil.keyBoardHeight(context),
            )),
        bottomNavigationBar: new BottomAppBar(
            child: SystemUtil.wrapperPadding(
                Row(
                  children: [
                    Expanded(
                      flex: 20,
                      child: TextField(
                        controller: controller,
                        onSubmitted: (s) => {_sendMessage()},
                        onChanged: (s) => {
                          this.setState(() {
                            this.commit = s != "";
                          })
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        style: TextStyle(),
                      ),
                    ),
                    Expanded(
                        flex: 5,
                        child: commit
                            ? CustomButton(
                                text: '发送',
                                width: 5,
                                style: TextStyle(color: Colors.white),
                                onTap: _sendMessage,
                              )
                            : IconButton(
                                icon: Icon(Icons.add),
                                onPressed: _addPressed,
                              ))
                  ],
                ),
                context)));
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) {
      return child;
    } else {
      return super.buildViewportChrome(context, child, axisDirection);
    }
  }
}
