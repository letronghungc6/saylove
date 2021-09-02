import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:say_love/src/views/ui/profile/hobbies.dart';
import 'package:say_love/src/views/utils/text_description.dart';
import 'package:say_love/src/views/utils/text_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditHeightWeight extends StatefulWidget {
  @override
  _EditHeightWeight createState() => _EditHeightWeight();
}

class _EditHeightWeight extends State<EditHeightWeight> {
  String numberHeight1 ="160";
  String numberWeight1 ="50";
  String numberHeight2 ="5";
  String numberWeight2 ="5";
  String height;
  String weight;
  @override
  Widget build(BuildContext context) {
//--------------------------------------------------------------------------------------------------------
    CupertinoPicker height1 = CupertinoPicker(
      itemExtent: 30,
      scrollController: FixedExtentScrollController(initialItem: 20),
      children: [
        for(int i=140; i < 220; i++)
          Text('$i'),
      ],
      onSelectedItemChanged: (value){
        setState(() {
          int a = value+140;
          numberHeight1="$a";
        });
      },
    );
//--------------------------------------------------------------------------------------------------------
    CupertinoPicker height2 = CupertinoPicker(
      itemExtent: 30,
      scrollController: FixedExtentScrollController(initialItem: 5),
      children: [
        for(int i=0; i < 10; i++)
          Text('$i'),
      ],
      onSelectedItemChanged: (value){
        setState(() {
          numberHeight2="$value";
        });
      },
    );
    //--------------------------------------------------------------------------------------------------------
    CupertinoPicker weight1 = CupertinoPicker(
      itemExtent: 30,
      scrollController: FixedExtentScrollController(initialItem: 20),
      children: [
        for(int i=30; i < 150; i++)
          Text('$i'),
      ],
      onSelectedItemChanged: (value){
        setState(() {
          int a = value+30;
          numberWeight1="$a";
        });
      },
    );
    //--------------------------------------------------------------------------------------------------------
    CupertinoPicker weight2 = CupertinoPicker(
      itemExtent: 30,
      scrollController: FixedExtentScrollController(initialItem: 5),
      children: [
        for(int i=0; i < 10; i++)
          Text('$i'),
      ],
      onSelectedItemChanged: (value){
        setState(() {
          numberWeight2="$value";
        });
      },
    );
    //--------------------------------------------------------------------------------------------------------
    final heightWeight = Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 300,
            child: height1,
          ),
          SizedBox(width: 5),
          Text(",", style: TextStyle(color: Colors.black, fontSize: 15),),
          SizedBox(width: 5),
          Container(
            width: 50,
            height: 300,
            child: height2,
          ),
          SizedBox(width: 10,),
          Text("cm", style: TextStyle(color: Colors.black, fontSize: 15),),
          Container(
            width: 50,
            height: 300,
            child: weight1,
          ),
          SizedBox(width: 5),
          Text(",", style: TextStyle(color: Colors.black, fontSize: 15),),
          SizedBox(width: 5),
          Container(
            width: 50,
            height: 300,
            child: weight2,
          ),
          SizedBox(width: 10,),
          Text("kg", style: TextStyle(color: Colors.black, fontSize: 15),),
        ],
      ),
    );

//------------------------------------------------------------------------------------
    final nextButton = SizedBox(
      height: 50,
      child: RaisedButton(
        color: Colors.red,
        child: Text(
          "XONG",
          style: TextStyle(
              color: Colors.white, fontSize: 15
          ),
          textAlign: TextAlign.center,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: () {
          height ="$numberHeight1.$numberHeight2";
          weight = "$numberWeight1.$numberWeight2";
          Navigator.pop(context, [height, weight]);
        },
      ),
    );


  return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 20, top: 120, right: 20, bottom: 0),
        child: ListView(
          children: <Widget>[
            TextTitle("Chiều cao và cân nặng của tôi là"),
            SizedBox(height: 20),
            TextDescription("Cân nặng và chiều cao của tôi"),
            SizedBox(height: 40),
            heightWeight,
            SizedBox(height: 135,),
            nextButton
          ],
        ),
      ),
    );
  }
}