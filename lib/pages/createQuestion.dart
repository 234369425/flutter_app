import 'dart:convert';
import 'dart:io' as IO;

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/db/DBOpera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  final TextEditingController title = TextEditingController();
  final TextEditingController detail = TextEditingController();
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  final ImagePicker picker = ImagePicker();
  var _imagePath;

  @override
  void initState() {
    super.initState();
    prefs.then((value) => {
          title.text = value.getString(QuestionConstants.title),
          detail.text = value.getString(QuestionConstants.detail)
        });
  }

  void _submitQuestion() {
    DBOperator operator = DBOperator();
    String imageStr = '';
    if (_imagePath != null) {
      final bytes = IO.File(_imagePath).readAsBytesSync();
      imageStr = base64.encode(bytes);
      String suffix = _imagePath == null
          ? ''
          : _imagePath.substring(_imagePath.lastIndexOf('.') + 1);
      operator.insertQuestion(title.text,
          'data:image/' + suffix + ';base64,' + imageStr, detail.text);
    } else {
      operator.insertQuestion(title.text, null, detail.text);
    }
    prefs.then((value) => {
          value.remove(QuestionConstants.image),
          value.remove(QuestionConstants.detail),
          value.remove(QuestionConstants.title)
        });

    Navigator.pushNamedAndRemoveUntil(
        context, RouterPathConstants.index, (route) => false);
  }

  void _takePhoto() {}

  _showImagePicker(ImageSource source) async {
    var image = await picker.getImage(source: source);
    setState(() {
      _imagePath = image.path;
    });
    prefs.then(
        (value) => {value.setString(QuestionConstants.image, _imagePath)});
  }

  _detailChanged(String detail) async {
    prefs.then((value) => {value.setString(QuestionConstants.detail, detail)});
  }

  _titleChanged(String title) async {
    prefs.then((value) => {value.setString(QuestionConstants.title, title)});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter you question')),
      body: Column(
        children: [
          TextField(
            controller: title,
            onChanged: _titleChanged,
            decoration: InputDecoration(
              labelText: 'Problem Description ',
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
                  onPressed: () => {_showImagePicker(ImageSource.gallery)})
            ],
          ),
          TextField(
            maxLines: 10,
            controller: detail,
            onChanged: _detailChanged,
            decoration: InputDecoration(
                labelText: 'Detail', icon: Icon(Icons.text_snippet)),
          ),
          RaisedButton(onPressed: _submitQuestion, child: Text('Submit'))
        ],
      ),
    );
  }
}
