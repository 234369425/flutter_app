import 'package:flutter/material.dart';
import 'package:flutter_app/bean/Question.dart';
import 'package:flutter_app/db/DBOpera.dart';

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
    return Container(
        height: 100.0,
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: RichText(
          text: TextSpan(
              text: _question.title,
              style: TextStyle(
                  color: Colors.black26,
                  fontSize: 35,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: _question.content == null ? '' : _question.content,
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 30
                )
                )
              ]),
        ));
  }

  @override
  void initState() {
    super.initState();
  }
}
