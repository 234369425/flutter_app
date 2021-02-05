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

  String _buildChildren() {
    String html = '<div>';
    html += '<table>';
    html += '<tr>';

    /**
        if (!self) {
        list.add(Container(
        width: 50,
        ));
        }


        list.add(Container(
        width: 600,
        child: ListView(
        children: _buildContent(),
        ),
        ));*/

    /**
        if (self) {
        list.add(Container(
        width: 50,
        ));
        }
     */
    html += '</tr>';
    html += '</table>';
    html += '</div>';
    return html;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class _MessageState extends State<Message> {
  bool _isVoice = false;
  bool _isMore = false;
  double keyboardHeight = 270.0;
  bool _emojiState = false;
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
