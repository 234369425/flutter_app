import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class Message extends StatelessWidget {
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

  List _buildChildren() {
    List list = new List<Widget>();
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
    ));

    if (self) {
      list.add(Container(
        width: 50,
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final double width = shrinkWrap ? null : MediaQuery.of(context).size.width;
    return ListView(
      scrollDirection: Axis.horizontal,
      children: _buildChildren(),
    );
  }
}
