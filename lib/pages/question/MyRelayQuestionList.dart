import 'package:flutter/material.dart';
import 'package:flutter_app/bean/Relay.dart';
import 'package:flutter_app/component/ui/header_bar.dart';
import 'package:flutter_app/db/DBOpera.dart';
import 'package:flutter_app/bean/Question.dart';
import 'package:flutter_app/pages/question/QuestionDetail.dart';
import 'package:flutter_app/utils/rtm_message.dart';
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

  void _sortDataList() {
    dataList.sort((q, q1) => q1.ct - q.ct);
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
        leading: CircleAvatar(
          backgroundColor: q.ct == 0 ? Colors.black12 : Colors.orangeAccent,
          child: Text(q.ct.toString()),
          foregroundColor: Colors.white,
        ),
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
        _queryQuestions();
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
                  _sortDataList();
                })
              }
            else
              {dataList.addAll(value)},
            _sortDataList(),
            _loading = false
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new HeaderBar(title: '我关注的问题', rightDMActions: []),
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
