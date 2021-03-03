import 'package:flutter/material.dart';
import 'package:flutter_app/component/ui/header_bar.dart';
import 'package:flutter_app/constants/urls.dart';
import 'package:flutter_app/db/DBOpera.dart';
import 'package:flutter_app/bean/Question.dart';
import 'package:flutter_app/pages/question/QuestionDetail.dart';
import 'package:flutter_app/pages/question/createQuestion.dart';
import 'package:flutter_app/utils/http_client.dart';
import 'package:flutter_app/utils/shared_util.dart';
import 'package:flutter_app/utils/toast.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_app/utils/route.dart';

class MyRelayQuestionList extends StatefulWidget {
  final String title = "欢迎 ";

  @override
  _MyRelayQuestionListState createState() => _MyRelayQuestionListState();
}

class _MyRelayQuestionListState extends State<MyRelayQuestionList> {
  final SlidableController slidableController = SlidableController();
  final ScrollController _scrollController = ScrollController();
  var dataList = [];
  var count = 0;
  var _loading = false;

  void _toAskQuestion() {
    pushRoute(QuestionWidget(topButton: true), callback: () {
      setState(() {
        print('refresh state');
      });
    });
  }

  @override
  void initState() {
    _queryQuestions();
    DBOperator.queryMyRelayCount().then((value) => {count = value});
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
        subtitle: Text(q.createTime ?? ''),
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

  _queryQuestions() {
    if (!_loading) {
      _loading = true;
      DBOperator.listMyRelayQuestion(dataList.length).then((value) => {
            if (this.mounted)
              {
                this.setState(() {
                  dataList.addAll(value);
                })
              }
            else
              {dataList.addAll(value)},
            _loading = false
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new HeaderBar(title: '我关注的问题', rightDMActions: [
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.blueAccent,
            onPressed: _toAskQuestion,
          )
        ]),
        body: new ListView.builder(
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
              child: Container(color: Colors.white, child: _buildRow(q)),
            );
          },
        ));
  }
}
