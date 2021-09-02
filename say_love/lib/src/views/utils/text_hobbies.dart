import 'package:flutter/material.dart';
import 'package:say_love/src/views/ui/profile/hobbies.dart';

class TextHobbies extends StatefulWidget{
  String text;
//  TextHobbies(this.text);
//  TextHobbies({Key key, this.hobbyText,this.text}) : super(key: key);
  List hobbyText;
  TextHobbies( this.text, this.hobbyText);

  @override
  _TextHobbies createState() => _TextHobbies();
}

class _TextHobbies extends State<TextHobbies> {
  Color borderBox = Colors.pinkAccent;
  Color box = Colors.white;
  Color text = Colors.pinkAccent;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        width: 115,
        decoration: BoxDecoration(
          color: box,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: borderBox,)
        ),
        child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          child: Text(
            widget.text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: text, fontSize: 13
            ),
          ),
          onPressed: (){
            if(text == Colors.pinkAccent){
              setState(() {
                borderBox = Colors.green;
                box = Colors.green;
                text = Colors.white;
              });
              widget.hobbyText.add(widget.text);
              widget.hobbyText.forEach((element) {print(element);});
            }
            else {
              setState(() {
                borderBox = Colors.pinkAccent;
                box = Colors.white;
                text = Colors.pinkAccent;
              });
              widget.hobbyText.remove(widget.text);
              widget.hobbyText.forEach((element) {print(element);});
            }
          },
        )
    );
  }
}