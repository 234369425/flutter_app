import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_app/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Question extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  final TextEditingController title = TextEditingController();
  final TextEditingController detail = TextEditingController();
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    prefs.then((value) => {
          title.text = value.getString(QuestionConstants.title),
          detail.text = value.getString(QuestionConstants.detail)
        });
  }

  var _imagePath;

  void _submit() {}

  void _takePhoto() {}

  _showImagePicker(ImageSource source) async {
    var image = await picker.getImage(source: source);
    setState(() {
      _imagePath = image;
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
  void dispose() {}

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
          RaisedButton(onPressed: _submit, child: Text('Submit'))
        ],
      ),
    );
  }
}
