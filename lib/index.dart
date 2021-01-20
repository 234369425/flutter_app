import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/db/DBOpera.dart';

import 'bean/Question.dart';

class Index extends StatefulWidget {
  final String title = "Welcome ";

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int _counter = 0;
  DBOperator _dbOperator = DBOperator();

  void _toAskQuestion() {
    Navigator.pushNamed(context, RouterPathConstants.createQuestion);
  }

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _listQuestion() {
    List result = List<Widget>();
    List<Question> data = List<Question>();
    //_dbOperator.listQuestion();
    data.add(Question(1, '世界人民大团结', '', true));
    print(data);
    data.forEach((e) {
      result.add(ListTile(
        title: Text(e.title),
      ));
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            RaisedButton(onPressed: _toAskQuestion, child: Text('Ask')),
            ListView(
              scrollDirection: Axis.vertical,
              children: _listQuestion(),
            ),
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
