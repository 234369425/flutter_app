import 'package:flutter/material.dart';
import 'package:flutter_app/component/ui/header_bar.dart';
import 'package:flutter_app/db/DBOpera.dart';
import 'package:flutter_app/bean/Question.dart';
import 'package:flutter_app/pages/question/QuestionDetail.dart';
import 'package:flutter_app/pages/question/createQuestion.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_app/utils/route.dart';

class QuestionList extends StatefulWidget {
  final String title = "欢迎 ";

  @override
  _QuestionListState createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  DBOperator _dbOperator = new DBOperator();
  final SlidableController slidableController = SlidableController();

  void _toAskQuestion() {
    pushRoute(QuestionWidget(topButton: true), callback: () {
      setState(() {
        print('refresh state');
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose');
  }

  Widget _buildRow(Question q) {
    ListTile tile = ListTile(
        title: Text(q.title),
        leading: CircleAvatar(
          backgroundColor:
              q.newMessage == 0 ? Colors.indigoAccent : Colors.grey,
          child: Text(q.newMessage.toString()),
          foregroundColor: Colors.white,
        ),
        trailing: q.newMessage > 0 ? Icon(Icons.announcement_rounded) : null,
        subtitle: Text(q.createTime),
        onTap: () {
          _showDetail(q);
        });
    return tile;
  }

  _showDetail(Question qs) {
    pushRoute(new QuestionDetail(qs), callback: () {
        setState(() {
          print('refresh state');
        });
    });
  }

  _doMethod(String action, Question q) {
    if (action == 'Delete') {
      _dbOperator.deleteQuestion(q.id);
    }
    print(action);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new HeaderBar(title: '问题列表', rightDMActions: [
        IconButton(
          icon: Icon(Icons.add),
          color: Colors.blueAccent,
          onPressed: _toAskQuestion,
        )
      ]),
      body: FutureBuilder<List>(
        future: _dbOperator.listQuestion(),
        initialData: List(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? new ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    var q = snapshot.data[i];
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
                            snapshot.data.removeAt(i);
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
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                  ),
                                  FlatButton(
                                    child: Text('Ok'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      child:
                          Container(color: Colors.white, child: _buildRow(q)),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'View',
                          color: Colors.black45,
                          icon: Icons.more_horiz,
                          onTap: () => _showDetail(q),
                        ),
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () => _doMethod('Delete', q),
                        ),
                      ],
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
