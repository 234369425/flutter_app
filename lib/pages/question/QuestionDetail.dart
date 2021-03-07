import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/bean/Question.dart';
import 'package:flutter_app/bean/Relay.dart';
import 'package:flutter_app/component/ui/custom_button.dart';
import 'package:flutter_app/component/ui/header_bar.dart';
import 'package:flutter_app/constants/defaults.dart';
import 'package:flutter_app/db/DBOpera.dart';
import 'package:flutter_app/utils/Image.dart';
import 'package:flutter_app/utils/rtm_message.dart';
import 'package:flutter_app/utils/shared_util.dart';
import 'package:flutter_app/utils/system.dart';
import 'package:flutter_app/utils/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_manager/keyboard_manager.dart';

class QuestionDetail extends StatefulWidget {
  final Question q;

  QuestionDetail(this.q);

  @override
  State<StatefulWidget> createState() {
    return _QuestionDetailState(this.q.id);
  }
}

class _QuestionDetailState extends State<QuestionDetail> {
  Question _question = Question(-1, "loading", "loading", 2);
  TextEditingController controller = new TextEditingController();
  ScrollController scrollController = new ScrollController();
  var relays = <Relay>[];
  var commit = false;
  var head = headPortrait;
  var _loading = true;
  FocusNode focusNode = FocusNode();
  final ImagePicker picker = ImagePicker();

  _QuestionDetailState(int id) {
    Shared.instance.getString("role").then((value) => {
          if (value != "1")
            {
              DBOperator.viewQuestion(id).then((value) => {
                    this.setState(() {
                      _question.id = value.id;
                      _question.title = value.title;
                      relays.add(value.toRelay());
                      DBOperator.queryRelay(value.id).then((value) => {
                            this.setState(() {
                              relays.addAll(value);
                            })
                          });
                    })
                  })
            }
          else
            {
              _question = this.widget.q,
              this.relays.add(_question.toRelay()),
              DBOperator.queryRelay(_question.id).then((value) => {
                    this.setState(() {
                      relays.addAll(value);
                    })
                  })
            }
        });
  }

  _openCamera() async {
    _openGallery(type: ImageSource.camera);
  }

  _openGallery({type: ImageSource.gallery}) async {
    var image;
    try {
      image = await picker.getImage(source: type);
    } catch (e) {
      FtToast.danger("请授予相机相册访问权限！");
      return;
    }
    if (image == null) {
      return;
    }
    String imageStr = await compressToString(File(image.path));

    var relay = Relay();
    relay.questionId = _question.id;
    relay.image = imageStr;
    relay.time = DateTime.now().toString();
    relay.time = relay.time.substring(0, relay.time.indexOf('.'));
    relays.add(relay);
    DBOperator.insertRelay(relay);
  }

  _sendMessage() {
    if (controller.text.trim() == "") {
      return;
    }

    var relay = Relay();
    relay.questionId = _question.id;
    relay.content = controller.text;
    relay.time = DateTime.now().toString();
    relay.time = relay.time.substring(0, relay.time.indexOf('.'));
    relays.add(relay);
    controller.text = "";
    commit = false;

    RTMMessage.sendMessage(_question.user, controller.text.trim());
    Shared.instance.getString("role").then((value) => {
          if (value == "1")
            DBOperator.insertMyRelayQuestion(_question, relay)
          else
            DBOperator.insertRelay(relay)
        });
    this.setState(() {
      scrollController.jumpTo(
          this.context.size.height - SystemUtil.keyBoardHeight(context).bottom);
    });
//    focusNode.unfocus();
  }

  _scrollToBottom() {
    scrollController.jumpTo(
        this.context.size.height - SystemUtil.keyBoardHeight(context).bottom);
  }

  List<Widget> _createRowContent(int index, double width) {
    Relay q = relays[index];
    var res = <Widget>[];
    var current = relays[index];
    var showTime = q.timeString();
    if (index != 0) {
      var last = relays[index - 1];
      showTime = q.showTime(last.time);
    }
    if (showTime != "") {
      res.add(
        Container(
          margin: EdgeInsets.only(bottom: 3.0),
          alignment: Alignment.center,
          child: Text(
            showTime,
            style: TextStyle(color: Colors.black54),
          ),
        ),
      );
    }
    res.add(Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: q.user == null
              ? LinearGradient(colors: [Colors.lightGreen, Colors.lightGreen])
              : LinearGradient(colors: [Colors.black12, Colors.black12]),
        ),
        child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: current.content != null
                ? Text(
                    current.content,
                    softWrap: true,
                  )
                : ImageUtils.dynamicAvatar(current.image))));
    return res;
  }

  _createRow(BuildContext context, int index) {
    var size = MediaQuery.of(context).size;
    var width = size.width / 12 * 7.8;
    Relay q = relays[index];
    GlobalKey textKey = GlobalKey();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            flex: 2,
            child: Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: Container(
                    alignment: Alignment.topCenter,
                    child: new SizedBox(
                      width: 40.0,
                      height: 40.0,
                      child: new ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: q.user != null
                            ? ImageUtils.dynamicAvatar(head)
                            : Text(''),
                      ),
                    )))),
        Expanded(
            flex: 8,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Wrap(children: _createRowContent(index, width)),
            )),
        Expanded(
            flex: 2,
            child: Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: Container(
                    alignment: Alignment.topCenter,
                    child: new SizedBox(
                      width: 40.0,
                      height: 40.0,
                      child: new ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: q.user == null
                            ? ImageUtils.dynamicAvatar(head)
                            : Text(''),
                      ),
                    ))))
      ],
    );
  }

  @override
  void initState() {
    Shared.instance.getString("head").then((value) => {
          this.setState(() {
            if (value != null) {
              head = value;
            }
          })
        });
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        print('滑动到了最底部');

        if (!_loading) {
          double _position = scrollController.position.maxScrollExtent - 10;
          scrollController.animateTo(_position,
              duration: Duration(seconds: 1), curve: Curves.ease);
          _loading = true;
        }
//        getListData();
      }
    });
    super.initState();
  }

  _addPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new HeaderBar(title: _question.title),
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: ListView.builder(
              itemCount: relays.length,
              itemBuilder: (context, i) => _createRow(context, i),
              controller: scrollController,
              shrinkWrap: true,
              padding: SystemUtil.keyBoardHeight(context),
            )),
        bottomNavigationBar: new BottomAppBar(
            child: SystemUtil.wrapperPadding(
                Row(
                  children: [
                    Expanded(
                      flex: 15,
                      child: TextField(
                        controller: controller,
                        onSubmitted: (s) => {_sendMessage()},
                        onChanged: (s) => {
                          this.setState(() {
                            this.commit = s != "";
                          })
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        style: TextStyle(),
                      ),
                    ),
                    Expanded(
                        flex: 5,
                        child: commit
                            ? CustomButton(
                                text: '发送',
                                width: 5,
                                style: TextStyle(color: Colors.white),
                                onTap: _sendMessage,
                              )
                            : Row(children: [
                                IconButton(
                                  icon: Icon(Icons.camera_alt),
                                  onPressed: _openCamera,
                                ),
                                IconButton(
                                    icon: Icon(Icons.photo),
                                    onPressed: _openGallery)
                              ]))
                  ],
                ),
                context)));
  }
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
