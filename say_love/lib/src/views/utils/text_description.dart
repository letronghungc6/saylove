import 'package:flutter/material.dart';

class TextDescription extends StatelessWidget{
  String text;
  TextDescription(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        style: TextStyle(
            color: Colors.black54, fontSize: 13
        ),
        textAlign: TextAlign.left
    );
  }
}