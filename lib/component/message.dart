import 'package:flutter/material.dart';
import 'package:flutter_app/component/ui/header_bar.dart';
import 'package:flutter_app/pages/detail/MainBody.dart';
import 'package:flutter_html/flutter_html.dart';

class Message extends StatefulWidget {
  final String message;
  final String time;
  final String image;
  final bool self;
  final bool shrinkWrap;

  Message({
    Key key,
    this.message,
    this.time,
    this.image,
    this.self = true,
    this.shrinkWrap = false,
  }) : super(key: key);

  List _buildContent() {
    List content = new List<Widget>();

    if (this.time != null) {
      content.add(Text(
        this.time,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      ));
    }
    if (this.image != null) {
      content.add(Html(data: '<img src="$image">'));
    }
    if (this.message != null) {
      content.add(Text(this.message));
    }
    return content;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class _MessageState extends State<Message> {
  double keyboardHeight = 270.0;
  String newGroupName;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new HeaderBar(title: 'detail'),
      body: new MainBody(
        decoration: BoxDecoration(color: Color(0xffefefef)),
        child: new Column(
          children: [],
        ),
      ),
    );
  }
}
