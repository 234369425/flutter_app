import 'package:flutter/material.dart';
import 'package:flutter_app/layout/MainBody.dart';
import 'package:flutter_app/pages/my/MyPage.dart';
import 'package:flutter_app/pages/question/MyRelayQuestionList.dart';
import 'package:flutter_app/pages/question/questionList.dart';
import 'package:flutter_app/pages/question/createQuestion.dart';
import 'package:flutter_app/utils/shared_util.dart';

class ApplicationLayout extends StatefulWidget {
  final String role;

  ApplicationLayout(this.role);

  @override
  State<StatefulWidget> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<ApplicationLayout> {
  @override
  Widget build(BuildContext context) {
    Widget center;
    IconData centerIcon;
    if (this.widget.role == '1') {
      center = MyRelayQuestionList();
      centerIcon = Icons.accessibility;
    } else {
      center = QuestionWidget(topButton: false);
      centerIcon = Icons.add_circle;
    }

    List<TabBarModel> pages = <TabBarModel>[
      new TabBarModel(
          title: "Questions",
          icon: _LoadIcon("assets/images/tab/chat_c.webp"),
          selectIcon: _LoadIcon("assets/images/tab/chat_s.webp"),
          page: QuestionList()),
      new TabBarModel(
          title: "",
          icon: Icon(
            centerIcon,
            size: 38,
          ),
          page: center),
      new TabBarModel(
          title: "Me",
          icon: _LoadIcon("assets/images/tab/me_c.webp"),
          selectIcon: _LoadIcon("assets/images/tab/me_s.webp"),
          page: MyPage())
    ];
    return Scaffold(body: new ApplicationTabBar(pages: pages));
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
