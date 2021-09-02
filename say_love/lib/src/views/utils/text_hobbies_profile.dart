import 'package:flutter/material.dart';
import 'package:say_love/src/views/ui/profile/hobbies.dart';

class TextHobbiesProfile extends StatefulWidget{
  String text;
  List hobbyText;
  bool isBold;
  TextHobbiesProfile( this.text, this.hobbyText, this.isBold);

  @override
  _TextHobbiesProfile createState() => _TextHobbiesProfile();
}

class _TextHobbiesProfile extends State<TextHobbiesProfile> {
  Color borderBox = Color(0xFFE5ECFF);
  Color text = Color(0xFFE5ECFF);
//  bool isBold = false;


  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        width: MediaQuery.of(context).size.width *0.25,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: widget.isBold ? Border.all(color: Color(0xFF4E4B6F)) : Border.all(color: Color(0xFFE5ECFF))
        ),
        child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          child: Text(
            widget.text,
            overflow: TextOverflow.ellipsis,
            style: widget.isBold ?
            TextStyle(
                color: Color(0xFF4E4B6F), fontSize: 13, fontWeight: FontWeight.bold
            ):
            TextStyle(
                color: Color(0xFFE5ECFF), fontSize: 13
            )
          ),
          onPressed: (){
            if(widget.isBold == false){//xám
              setState(() {
                widget.isBold = true;
              });
              widget.hobbyText.add(widget.text);
              widget.hobbyText.forEach((element) {print(element);});
            }
            else {
              setState(() {
                widget.isBold = false;
              });
              widget.hobbyText.remove(widget.text);
              widget.hobbyText.forEach((element) {print(element);});
            }
          },
        )
    );
  }
}