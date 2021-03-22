import 'package:flutter/material.dart';
import 'package:flutter_app/bean/Relay.dart';
import 'package:flutter_app/component/ui/header_bar.dart';
import 'package:flutter_app/constants/urls.dart';
import 'package:flutter_app/db/DBOpera.dart';
import 'package:flutter_app/bean/Question.dart';
import 'package:flutter_app/pages/question/QuestionDetail.dart';
import 'package:flutter_app/pages/question/createQuestion.dart';
import 'package:flutter_app/utils/http_client.dart';
import 'package:flutter_app/utils/rtm_message.dart';
import 'package:flutter_app/utils/shared_util.dart';
import 'package:flutter_app/utils/toast.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_app/utils/route.dart';

class QuestionList extends StatefulWidget {
  final String title = "欢迎 ";

  @override
  _QuestionListState createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  final SlidableController slidableController = SlidableController();
  final ScrollController _scrollController = ScrollController();
  var dataList = [];
  var count = 0;
  var _loading = false;
  var role = "1";

  void _toAskQuestion() {
    pushRoute(QuestionWidget(topButton: true), callback: () {
      setState(() {
        dataList.clear();
        _queryQuestions();
        print('refresh state');
      });
    });
  }

  void _sortDataList() {
    dataList.sort((q, q1) => q1.ct - q.ct);
  }

  @override
  void initState() {
    _queryQuestions();

    Shared.instance.getString("role").then((value) => role = value);
    DBOperator.queryCount().then((value) => {count = value});
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        print('滑动到了最底部');

        if (!_loading) {
          double _position = _scrollController.position.maxScrollExtent - 10;
          _scrollController.animateTo(_position,
              duration: Duration(seconds: 1), curve: Curves.ease);
          _queryQuestions();
        }
//        getListData();
      }
    });
    RTMMessage.registerQuestionList((Relay r) {
      if(this.mounted)
      dataList.forEach((element) {
        if (element.title == r.title) {
          element.ct++;
          this.setState(() {
            _sortDataList();
          });
          return;
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    RTMMessage.unRegisterQuestionList();
    print('dispose');
  }

  Widget _buildRow(Question q) {
    ListTile tile = ListTile(
        title: Text(q.title),
        leading: role == "0" ? CircleAvatar(
          backgroundColor: q.ct == 0 ? Colors.grey : Colors.red,
          child: Text(q.ct.toString()),
          foregroundColor: Colors.white,
        ): null,
        trailing: q.ct > 0 ? Icon(Icons.announcement_rounded) : null,
        subtitle: Text(q.createTime ?? ''),
        onTap: () {
          _showDetail(q);
        });
    return tile;
  }

  _showDetail(Question qs) {
    pushRoute(new QuestionDetail(qs), callback: () {
      setState(() {
        dataList.clear();
        _queryQuestions();
        print('refresh state');
      });
    });
  }

  _doMethod(String action, Question q) {
    if (action == 'Delete') {
      DBOperator.deleteQuestion(q.id);
    }
    print(action);
  }

  _queryQuestions() {
    if (!_loading) {
      _loading = true;
      Shared.instance.getString("role").then((value) => {
            if (value == "1")
              {
                HttpClient.send(
                    url_query_question, {'cursor': dataList.length.toString()},
                    (d) {
                  _loading = false;
                  if (d["code"] == 0) {
                    var list = d["list"];
                    for (var data in list) {
                      var question = data["map"];
                      var q = Question(
                          question["id"],
                          question["title"],
                          question["create_time"]
                              .toString()
                              .replaceAll("T", " "),
                          0);
                      q.content = question["content"];
                      q.image = question["image"];
                      q.user = question["user"];
                      dataList.add(q);
                    }
                    if(this.mounted)
                    this.setState(() {
                      _sortDataList();
                    });
                  }
                }, (e) {
                  _loading = false;
                  FtToast.danger(e.toString());
                })
              }
            else
              {
                DBOperator.listQuestion(dataList.length).then((value) => {
                      if (this.mounted)
                        {
                          this.setState(() {
                            dataList.addAll(value);
                            _sortDataList();
                          })
                        }
                      else
                        {dataList.addAll(value),
                        _sortDataList()},
                      _loading = false
                    })
              }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    var actions = role == "1"
        ? <Widget>[]
        : <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.blueAccent,
              onPressed: _toAskQuestion,
            )
          ];

    return Scaffold(
        appBar: new HeaderBar(title: '问题列表', rightDMActions: actions),
        body: dataList.isEmpty? new Center(child: Text('暂无问题'),) : new ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: dataList.length,
          controller: _scrollController,
          itemBuilder: (context, i) {
            var q = dataList[i];
            return Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              key: Key(q.id.toString()),
              controller: slidableController,
              closeOnScroll: true,
              dismissal: SlidableDismissal(
                child: SlidableDrawerDismissal(),
                onDismissed: (actionType) {
                  /**
                      _showSnack(
                      context,
                      actionType == SlideActionType.primary
                      ? 'Dismiss Archive'
                      : 'Dimiss Delete');
                      setState(() {
                      list.removeAt(index);
                      });**/
                  setState(() {
                    dataList.removeAt(i);
                  });
                },
                onWillDismiss: (actionType) {
                  return showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Delete'),
                        content: Text('Item will be deleted'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          FlatButton(
                            child: Text('Ok'),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              child: Container(color: Colors.white, child: _buildRow(q)),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'View',
                  color: Colors.black45,
                  icon: Icons.more_horiz,
                  onTap: () => _showDetail(q),
                ),
                /**
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () => _doMethod('Delete', q),
                ),*/
              ],
            );
          },
        ));
  }
}
