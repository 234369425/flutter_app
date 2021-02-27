import 'dart:convert';
import 'dart:io' as IO;

import 'package:flutter/material.dart';
import 'package:flutter_app/component/ui/header_bar.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/constants/urls.dart';
import 'package:flutter_app/db/DBOpera.dart';
import 'package:flutter_app/utils/http_client.dart';
import 'package:flutter_app/utils/route.dart';
import 'package:flutter_app/utils/shared_util.dart';
import 'package:flutter_app/utils/system.dart';
import 'package:flutter_app/utils/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';

class QuestionWidget extends StatefulWidget {
  QuestionWidget({this.topButton});

  final bool topButton;

  @override
  State<StatefulWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  final TextEditingController title = TextEditingController();
  final TextEditingController detail = TextEditingController();
  final Shared shared = Shared.instance;
  final ImagePicker picker = ImagePicker();
  var _imagePath;

  @override
  void initState() {
    super.initState();
    shared.getPrefs().then((value) => {
          title.text = value.getString(QuestionConstants.title),
          detail.text = value.getString(QuestionConstants.detail)
        });
  }

  void _submitQuestion() {
    String imageStr;
    if (_imagePath != null) {
      final bytes = IO.File(_imagePath).readAsBytesSync();
      imageStr = base64.encode(bytes);
      String suffix = _imagePath == null
          ? ''
          : _imagePath.substring(_imagePath.lastIndexOf('.') + 1);
      imageStr = 'data:image/' + suffix + ';base64,' + imageStr;
    }
    shared.getAccount().then((user) => HttpClient.send(url_post_question, {
          'user': user,
          'title': title.text,
          'content': detail.text,
          'image': imageStr
        }, (res) {
          DBOperator.insertQuestion(title.text, imageStr, detail.text);
          shared.getPrefs().then((value) => {
                value.remove(QuestionConstants.image),
                value.remove(QuestionConstants.detail),
                value.remove(QuestionConstants.title)
              });
          if (this.widget.topButton) {
            popRoute();
          } else {
            title.clear();
            detail.clear();
            FtToast.warning("问题已提交");
          }
        }, (cause) {}));
  }

  _showImagePicker(ImageSource source) async {
    var image = await picker.getImage(source: source);
    if (image == null) {
      return;
    }
    setState(() {
      _imagePath = image.path;
    });
    shared.getPrefs().then(
        (value) => {value.setString(QuestionConstants.image, _imagePath)});
  }

  _detailChanged(String detail) async {
    shared
        .getPrefs()
        .then((value) => {value.setString(QuestionConstants.detail, detail)});
  }

  _titleChanged(String title) async {
    shared
        .getPrefs()
        .then((value) => {value.setString(QuestionConstants.title, title)});
  }

  @override
  void dispose() {
    super.dispose();
  }

  _dropDownChanged(dynamic v) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: new HeaderBar(title: '新建问题'),
        body: SystemUtil.wrapperPadding(
            Column(
              children: [
                TextField(
                  controller: title,
                  onChanged: _titleChanged,
                  decoration: InputDecoration(
                    labelText: '问题简述',
                    icon: Icon(Icons.question_answer_outlined),
                  ),
                ),
                ButtonBar(
                  children: [
                    IconButton(
                      icon: Icon(Icons.camera_alt_outlined),
                      onPressed: () => {_showImagePicker(ImageSource.camera)},
                    ),
                    IconButton(
                        icon: Icon(Icons.photo),
                        onPressed: () =>
                            {_showImagePicker(ImageSource.gallery)})
                  ],
                ),
                DropdownButton(
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(
                        child: Text('数学'),
                      ),
                      DropdownMenuItem(
                        child: Text('英语'),
                      ),
                    ],
                    onChanged: _dropDownChanged),
                TextField(
                  maxLines: 8,
                  controller: detail,
                  onChanged: _detailChanged,
                  decoration: InputDecoration(
                      labelText: '详细描述', icon: Icon(Icons.text_snippet)),
                ),
                RaisedButton(onPressed: _submitQuestion, child: Text(' 提 交 '))
              ],
            ),
            context));
  }
}
