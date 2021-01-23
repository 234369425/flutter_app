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
          backgroundColor: q.isNew ? Colors.indigoAccent : Colors.grey,
          child: q.isNew ? Text('1') : Text('0'),
          foregroundColor: Colors.white,
        ),
        trailing: q.isNew ? Icon(Icons.announcement_rounded) : null,
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

  _showSnackBar(String action, Question q) {
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
                      child:
                          Container(color: Colors.white, child: _buildRow(q)),
                      actions: <Widget>[
                        IconSlideAction(
                          caption: 'Mark',
                          color: Colors.indigo,
                          icon: Icons.library_add,
                          onTap: () => _showSnackBar('Mark', q),
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
                          onTap: () => _showSnackBar('Delete', q),
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
