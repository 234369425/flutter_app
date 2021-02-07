import 'package:flutter/material.dart';
import 'package:flutter_app/layout/TabBar.dart';
import 'package:flutter_app/pages/my/MyPage.dart';
import 'package:flutter_app/pages/question/questionList.dart';
import 'package:flutter_app/pages/question/createQuestion.dart';

class ApplicationLayout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<ApplicationLayout> {
  @override
  Widget build(BuildContext context) {
    List<TabBarModel> pages = <TabBarModel>[
      new TabBarModel(
          title: "Questions",
          icon: _LoadIcon("assets/images/tab/chat_c.webp"),
          selectIcon: _LoadIcon("assets/images/tab/chat_s.webp"),
          page: QuestionList()),
      new TabBarModel(
          title: "",
          icon: Icon(
            Icons.add_circle,
            size: 38,
          ),
          page: QuestionWidget()),
      new TabBarModel(
          title: "Me",
          icon: _LoadIcon("assets/images/tab/me_c.webp"),
          selectIcon: _LoadIcon("assets/images/tab/me_s.webp"),
          page: MyPage())
    ];
    return new Scaffold(body: new ApplicationTabBar(pages: pages));
  }
}

class _LoadIcon extends StatelessWidget {
  final String img;

  _LoadIcon(this.img);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 35,
        child: Container(
          margin: EdgeInsets.only(bottom: 2.0),
          child: Image.asset(img, fit: BoxFit.cover, gaplessPlayback: true),
        ));
  }
}
