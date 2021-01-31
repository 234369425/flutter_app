import 'package:flutter/material.dart';
import 'package:flutter_app/layout/TabBar.dart';
import 'package:flutter_app/pages/questionList.dart';

class ApplicationLayout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<ApplicationLayout> {

  @override
  Widget build(BuildContext context) {
    List<TabBarModel> pages = <TabBarModel>[
      new TabBarModel(
          title: "问题",
          icon: _LoadIcon("assets/images/tabbar_chat_c.webp"),
          selectIcon: _LoadIcon("assets/images/tabbar_chat_s.webp"),
          page: QuestionList()
      )
    ];
    return new Scaffold(
        body: new ApplicationTabBar(pages: pages)
    );
  }

}

class _LoadIcon extends StatelessWidget {
  final String img;

  _LoadIcon(this.img);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(bottom: 2.0),
      child: new Image.asset(img, fit: BoxFit.cover, gaplessPlayback: true),
    );
  }
}
