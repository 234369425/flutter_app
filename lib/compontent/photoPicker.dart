import 'dart:io';
import 'dart:html';

import 'package:flutter/material.dart';


typedef callback = void Function(List imgData);

class PhotoPicker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

/*
class _photoPickerState extends State<PhotoPicker> {

  final List images = List();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0
          ), itemBuilder: (context, index) {
        if (index == images.length - 1) {
          return button(context, state, data, pick)
        } else {
          return image(index, state, data, pick);
        }
      }),
    )
  }

  Widget button(context, state, data, pick) {
    return GestureDetector(
        child: Image(image: Jh)
    )
  }

  Widget image(index, state, data, pick) {
    return GestureDetector(
      child: Container(
          color: Colors.transparent,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              ConstrainedBox(
                  child: Image.file(File(images[index]), fit: BoxFit.cover),
                  constraints: BoxConstraints.expand()
              )
            ],
          )
      ),
    )
  }

}
*/