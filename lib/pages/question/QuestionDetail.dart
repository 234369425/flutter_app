import 'dart:convert';
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
import 'package:flutter_app/utils/user_header.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_manager/keyboard_manager.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

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
  var myselfHead = headPortrait;
  var _loading = true;
  var canRelay = false;
  var keyBoardVisible = false;
  var relayTo = '';
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
                      RTMMessage.registerCurrent("", value.title, (relay){
                        this.setState(() {
                          relays.add(relay);
                        });
                      });
                      DBOperator.queryRelay(value.id).then((value) => {
                            this.setState(() {
                              if (value.isNotEmpty) {
                                canRelay = true;
                              }
                              value.forEach((element) {
                                if(element.user != null){
                                  relayTo = element.user;
                                }
                              });
                              this.setState(() {
                                relays.addAll(value);
                                _scrollToBottom();
                              });
                            })
                          });
                    })
                  })
            }
          else
            {
              canRelay = true,
              _question = this.widget.q,
              relayTo = this.widget.q.user,
              this.relays.add(_question.toRelay()),
              RTMMessage.registerCurrent(relayTo, _question.title, (relay){
                this.setState(() {
                  relays.add(relay);
                });
              }),
              DBOperator.queryRelay(_question.id).then((value) => {
                    this.setState(() {
                      relays.addAll(value);
                      _scrollToBottom();
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
    relay.image = imageStr;
    _sendRtmMessage(relay);
  }

  _sendRtmMessage(Relay relay){

    relay.questionId = _question.id;
    relay.title = this.widget.q.title;
    relay.time = DateTime.now().toString();
    relay.time = relay.time.substring(0, relay.time.indexOf('.'));
    relays.add(relay);

    RTMMessage.sendMessage(
        relayTo,
        relay.toJsonStr(),
            () => {
          Shared.instance.getString("role").then((value) => {
            if (value == "1")
              DBOperator.insertMyRelayQuestion(_question, relay)
            else
              DBOperator.insertRelay(relay)
          })
        },
            () => {FtToast.danger("消息发送失败！")});

    this.setState(() {
      _scrollToBottom();
    });
  }

  _sendMessage() {
    if (controller.text.trim() == "") {
      return;
    }
    var relay = Relay();
    relay.content = controller.text;
    controller.text = "";
    commit = false;
    _sendRtmMessage(relay);
//    focusNode.unfocus();
  }

  _scrollToBottom({height:0}) {
    Future.delayed(Duration(milliseconds: 50) ,(){
      scrollController.jumpTo(scrollController.position.maxScrollExtent - height);
    });
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
    Relay r = relays[index];
    var self = r.user == null;
    var targetHead = headPortrait;
    if(!self) {
      targetHead = UserHeader.get(r.user)??headPortrait;
    }
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
                        child: r.user != null
                            ? ImageUtils.dynamicAvatar(targetHead)
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
                        child: r.user == null
                            ? ImageUtils.dynamicAvatar(myselfHead)
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
              myselfHead = value;
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
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        this.setState(() {
          if(visible) {
            Future.delayed(Duration(milliseconds: 100) ,()
            {
              _scrollToBottom(height: 5);
            });
          }
          //keyBoardVisible = visible;
        });
      },
    );
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
    RTMMessage.unRegister();
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
                                onTap: canRelay ? _sendMessage : null,
                              )
                            : Row(children: [
                                IconButton(
                                  icon: Icon(Icons.camera_alt),
                                  onPressed: canRelay ? _openCamera : null,
                                ),
                                IconButton(
                                    icon: Icon(Icons.photo),
                                    onPressed: canRelay ? _openGallery : null)
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
