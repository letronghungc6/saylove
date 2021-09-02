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

class Birthday extends StatefulWidget {
  Birthday({@required this.token, this.id, this.checkBack});
  String token = "";
  String id="";
  bool checkBack;
  @override
  _Birthday createState() => _Birthday();
}

class _Birthday extends State<Birthday> {
  DateTime dateTime;

  updateBirthday() async{
    String birthday = DateFormat('yyyy-MM-dd').format(dateTime);
    int timeStamp  = dateTime.millisecondsSinceEpoch;
    print(dateTime);
    print(birthday);
    String id = widget.id;
    String token= widget.token;
    String url = "http://45.76.151.147:8091/api/user/$id/profile";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer $token',
    };
    Map<String, String> jsonPost = {
      "birthday": "$birthday"
    };
    try{
      Response r = await patch(
          url, headers: headers, body: jsonEncode(jsonPost));
      dynamic jsonBody = json.decode( utf8.decode(r.bodyBytes));
      print(utf8.decode(r.bodyBytes));
      String mess = jsonBody["status_message"];
      SharedPreferences prefs2 = await SharedPreferences.getInstance();
      if(jsonBody["status_code"] == 200){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Gender(token:token, id:id)));
        prefs2.setInt("birthday", timeStamp);
      }
      else
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(
                  mess,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15
                  ),
                ),
              );
            }
        );
    }
    catch(e){
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                "Lỗi không xác định",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15
                ),
              ),
            );
          }
      );
    }
  }

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
    final iconSelect = Container(
      padding: EdgeInsets.only(bottom: 30),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 6,
      width: 6,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
    //------------------------------------------------------------------------------------
    final iconNoneSelect = Container(
      padding: EdgeInsets.only(bottom: 30),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 6,
      width: 6,
      decoration: BoxDecoration(
        color: Color(0xffFF66FF),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
//------------------------------------------------------------------------------------
    final slideIcon = Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          iconNoneSelect,
          iconSelect,
          iconNoneSelect,
          iconNoneSelect,
          iconNoneSelect,
          iconNoneSelect,
          iconNoneSelect
        ],
      ),
    );
    //------------------------------------------------------------------------------------
    final nextButton = SizedBox(
      height: 50,
      child: RaisedButton(
        color: Colors.red,
        child: Text(
          "TIẾP TỤC",
          style: TextStyle(
              color: Colors.white, fontSize: 15
          ),
          textAlign: TextAlign.center,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: () {
            updateBirthday();

        },
      ),
    );



    if(widget.checkBack != true)
      return Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 0),
          child: ListView(
            children: <Widget>[
              back,
              SizedBox(height: 80),
              TextTitle("Sinh nhật của tôi là"),
              SizedBox(height: 20),
              TextDescription("Tuổi của bạn sẽ được hiển thị công khai"),
              SizedBox(height: 60),
              birthday,
              SizedBox(height: 100,),
              slideIcon,
              SizedBox(height: 10,),
              nextButton
            ],
          ),
        )
      );
    else
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
                SizedBox(height: 100,),
                slideIcon,
                SizedBox(height: 10,),
                nextButton
              ],
            ),
          )
      );
  }
}