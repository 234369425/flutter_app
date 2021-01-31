import 'package:flutter/material.dart';
import 'package:flutter_app/bean/Question.dart';
import 'package:flutter_app/component/message.dart';
import 'package:flutter_app/db/DBOpera.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class ShowQuestion extends StatefulWidget {
  final Question q;

  ShowQuestion({this.q});

  @override
  State<StatefulWidget> createState() {
    return _ShowQuestionState(this.q.id);
  }
}

class _ShowQuestionState extends State<ShowQuestion> {
  final DBOperator dbOperator = new DBOperator();
  Question _question = Question(-1, "loading", "loading", 2);

  _ShowQuestionState(int id) {
    dbOperator.viewQuestion(id).then((value) => {
          this.setState(() {
            _question = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_question.title),
        ),
        body: Column(
          children: [
            Html(
              data: '''
            <h1>${_question.title}</h1>
            <div style="text-align:center;padding-bottom:15;color:blue;">${_question.createTime}</div>
            <img style="margin:15px 0" src="${_question.image}">
            <div>${_question.content}</div>
            
            <hr/>
            <div style="text-align:center;">
            <table>
              <tr>
                <td style="alignment">左面</td>
                <td width="45.5">中间</td>
                <td width="15.5">右面</td>
              </tr>
            </table>
            </div>
            <div>
              <div style="float:left;width:22.9;">
                问题额
              </div>
              <div style="float:left:width:70%">
              回答一
              </div>
              <div style="float:left:width:15%">
              </div>
            </div>
          ''',
              style: {
                "blockquote": Style(margin: EdgeInsets.fromLTRB(0, 8, 0, 0)),
              },
            ),
            //Message()
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
  }
}
