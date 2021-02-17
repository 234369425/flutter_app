import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants/color.dart';

class ApplicationTabBar extends StatefulWidget {
  ApplicationTabBar({this.pages, this.currentIndex = 0});

  final List<TabBarModel> pages;
  final int currentIndex;

  @override
  State<StatefulWidget> createState() => new _ApplicationTabBarState();
}

class _ApplicationTabBarState extends State<ApplicationTabBar> {
  var pages = new List<BottomNavigationBarItem>();
  int currentIndex;
  var contents = new List<Offstage>();
  PageController pageController;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
    pageController = PageController(initialPage: currentIndex);
    for (int i = 0; i < widget.pages.length; i++) {
      TabBarModel model = widget.pages[i];
      pages.add(
        new BottomNavigationBarItem(
          icon: model.icon,
          activeIcon: model.selectIcon,
          title: new Text(model.title, style: new TextStyle(fontSize: 12.0)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar bottomNavigationBar = new BottomNavigationBar(
      items: pages,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      fixedColor: Colors.green,
      unselectedItemColor: Color.fromRGBO(115, 115, 115, 1.0),
      onTap: (int index) {
        setState(() => currentIndex = index);
        pageController.jumpToPage(currentIndex);
      },
      iconSize: 35.0,
      unselectedFontSize: 10.0,
      selectedFontSize: 10.0,
      elevation: 0,
    );

    return new Scaffold(
      bottomNavigationBar: SizedBox(
          height: 65,
          child: Theme(
            data: ThemeData(
              canvasColor: Colors.grey[50],
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: lineColor))),
              child: bottomNavigationBar,
            ),
          )),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: new PageView.builder(
              itemBuilder: (BuildContext context, int index) =>
                  widget.pages[index].page,
              controller: pageController,
              itemCount: pages.length,
              physics: Platform.isAndroid
                  ? new ClampingScrollPhysics()
                  : new NeverScrollableScrollPhysics(),
              onPageChanged: (int index) {
                setState(() {
                  FocusScope.of(context).requestFocus(FocusNode());
                  currentIndex = index;
                });
              },
            )),
      ),
    );
  }
}

class TabBarModel {
  const TabBarModel({this.title, this.page, this.icon, this.selectIcon});

  final String title;
  final Widget icon;
  final Widget selectIcon;
  final Widget page;
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) {
      return child;
    } else {
      return super.buildViewportChrome(context, child, axisDirection);
    }
  }
}
