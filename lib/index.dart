import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';

class Index extends StatefulWidget {

  final String title = "Welcome ";

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int _counter = 0;

  void _toAskQuestion() {
    Navigator.pushNamed(context, RouterPathConstants.createQuestion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(onPressed: _toAskQuestion, child: Text('Ask')),
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
