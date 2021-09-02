import 'dart:convert';
import 'dart:wasm';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:say_love/src/views/ui/profile/gender.dart';
import 'package:say_love/src/views/utils/text_description.dart';
import 'package:say_love/src/views/utils/text_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditBirthday extends StatefulWidget {
  @override
  _EditBirthday createState() => _EditBirthday();
}

class _EditBirthday extends State<EditBirthday> {
  DateTime dateTime;
  String textBirthday;
  @override
  Widget build(BuildContext context) {
    final back = Container(
        height: 50,
        width: 50,
        alignment: Alignment.centerLeft,
        child: IconButton(
            icon: Icon(Icons.arrow_back_sharp,
              color: Colors.black,
            ),
            iconSize: 24,
            onPressed: () {
              Navigator.pop(context);
            }
        )
    );
//--------------------------------------------------------------------------------------------------------
    CupertinoDatePicker datePicker = CupertinoDatePicker(
      minimumDate: DateTime(1980),
      maximumDate: DateTime(2003,12,31),
      initialDateTime: DateTime.utc(1999,),
      mode: CupertinoDatePickerMode.date,
      onDateTimeChanged: (date) {
        setState(() {
          dateTime = date;
        });
      },
    );
    //--------------------------------------------------------------------------------------------------------
    final birthday = Container(
      height: 300,
      child: datePicker,
    );

//--------------------------------------------------------------------------------------------------------
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
          textBirthday =  DateFormat('yyyy-MM-dd').format(dateTime);
          Navigator.pop(context, [textBirthday, dateTime]);
        },
      ),
    );

      return Scaffold(
          body: Padding(
            padding: EdgeInsets.only(left: 20, top: 120, right: 20, bottom: 0),
            child: ListView(
              children: <Widget>[
                TextTitle("Sinh nhật của tôi là"),
                SizedBox(height: 20),
                TextDescription("Tuổi của bạn sẽ được hiển thị công khai"),
                SizedBox(height: 60),
                birthday,
                SizedBox(height: 150,),
                nextButton
              ],
            ),
          )
      );
  }
}