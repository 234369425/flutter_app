import 'package:flutter/material.dart';
import 'package:flutter_app/bean/Question.dart';
import 'package:flutter_app/bean/Relay.dart';
import 'package:flutter_app/component/ui/header_bar.dart';
import 'package:flutter_app/db/DBOpera.dart';
import 'package:flutter_app/utils/system.dart';

class QuestionDetail extends StatefulWidget {
  final Question q;

  QuestionDetail(this.q);

  @override
  State<StatefulWidget> createState() {
    return _QuestionDetailState(this.q.id);
  }
}

class _QuestionDetailState extends State<QuestionDetail> {
  final DBOperator dbOperator = new DBOperator();
  Question _question = Question(-1, "loading", "loading", 2);
  TextEditingController controller = new TextEditingController();
  ScrollController scrollController = new ScrollController();
  var relays = <Relay>[];

  _QuestionDetailState(int id) {
    dbOperator.viewQuestion(id).then((value) => {
          this.setState(() {
            _question = value;
          })
        });
  }

  _createRow(int index) {
    Relay q = relays[index];
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 160.0),
              child: Container(
                child: q.userId == null
                    ? Text('')
                    : new Image.asset('assets/images/def_head_portrait.png',
                        fit: BoxFit.cover, gaplessPlayback: true),
              )),
        ),
        Expanded(
            flex: 8,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: q.userId == null
                      ? LinearGradient(
                          colors: [Colors.lightGreen, Colors.lightGreen])
                      : LinearGradient(
                          colors: [Colors.black12, Colors.black12]),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Text(
                      '''确定如何在垂直方向摆放子组件，以及如何解释 start 和 end，指定 height 可以看到效果，可选值有：
                  VerticalDirection.up：Row 从下至上开始摆放子组件，此时我们看到的底部其实是顶部。
                  VerticalDirection.down：Row 从上至下开始摆放子组件，此时我们看到的顶部就是顶部。'''),
                ))),
        Expanded(
            flex: 2,
            child: Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 160.0),
                child: Container(
                  child: q.userId != null
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
        body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: ListView.builder(
              itemCount: relays.length,
              itemBuilder: (context, i) => _createRow(i),
              controller: scrollController,
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
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: _addPressed,
                        ))
                  ],
                ),
                context)));
  }

  @override
  void initState() {
    super.initState();
  }
}
