import 'package:flutter/material.dart';
import 'package:flutter_app/bean/Question.dart';

class ShowQuestion extends StatefulWidget {
  final Question q;

  ShowQuestion({this.q});

  @override
  State<StatefulWidget> createState() {
    return _ShowQuestionState();
  }
}

class _ShowQuestionState extends State<ShowQuestion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.q.title)),
        body: Column(
          children: [Text(widget.q.title)],
        ));
  }

  @override
  void initState() {
    super.initState();
  }
}
