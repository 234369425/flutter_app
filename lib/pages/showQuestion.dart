import 'package:flutter/material.dart';
import 'package:flutter_app/bean/Question.dart';
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
            <div class=".time">${_question.createTime}</div>
            <img src="${_question.image}">
            <blockquote>${_question.content}</blockquote>
          ''',
              style: {
                "div": Style(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    textAlign: TextAlign.center),
                "blockquote": Style(margin: EdgeInsets.fromLTRB(0, 8, 0, 0)),
              },
            )
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
  }
}
