import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/db/DBOpera.dart';
import 'package:flutter_app/bean/Question.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Index extends StatefulWidget {
  final String title = "Welcome ";

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  DBOperator _dbOperator = new DBOperator();
  final SlidableController slidableController = SlidableController();

  void _toAskQuestion() {
    Navigator.pushNamed(context, RouterPathConstants.createQuestion);
  }

  @override
  void initState() {
    super.initState();
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

  _showDetail(Question q) {
    dynamic s = <String, Question>{"q": q};
    Navigator.pushNamed(context, RouterPathConstants.showQuestion,
        arguments: s);
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
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: _toAskQuestion, icon: Icon(Icons.add_circle_sharp)),
        ],
      ),
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
                      actions: <Widget>[
                        IconSlideAction(
                          caption: 'Mark',
                          color: Colors.indigo,
                          icon: Icons.library_add,
                          onTap: () => _doMethod('Mark', q),
                        ),
                      ],
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
