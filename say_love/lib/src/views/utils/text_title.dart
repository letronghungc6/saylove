import 'package:flutter/material.dart';

class TextTitle extends StatelessWidget{
  String text;
  TextTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        style: TextStyle(
            color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold),
        textAlign: TextAlign.left
    );
  }
}