import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:say_love/src/utils/female_icons.dart';
import 'package:say_love/src/utils/male_icons.dart';
import 'package:say_love/src/views/ui/profile/height_weight.dart';
import 'package:say_love/src/views/utils/text_description.dart';
import 'package:say_love/src/views/utils/text_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Gender extends StatefulWidget {
  Gender({@required this.token, this.id, this.checkBack});
  String token = "";
  String id="";
  bool checkBack;
  @override
  _Gender createState() => _Gender();
}

class _Gender extends State<Gender> {
  bool check = false;
  String checkText = "";
  Color colorMale = Colors.grey;
  Color colorFemale = Colors.grey;
  String genderText;

  updateGender() async{
    String id = widget.id;
    String token= widget.token;
    String url = "http://45.76.151.147:8091/api/user/$id/profile";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer $token',
    };
    Map<String, String> jsonPost = {
      "gender":"$genderText"
    };
    try{
      Response r = await patch(
          url, headers: headers, body: jsonEncode(jsonPost));
      dynamic jsonBody = json.decode( utf8.decode(r.bodyBytes));
      print(utf8.decode(r.bodyBytes));
      String mess = jsonBody["status_message"];
      SharedPreferences prefs2 = await SharedPreferences.getInstance();
      if(jsonBody["status_code"] == 200){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HeightWeight(token:token, id:id)));
        prefs2.setString("gender", genderText);
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
    final male = Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          color: colorMale,
          borderRadius: BorderRadius.all(Radius.circular(80)),
        ),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(80.0)),
        child: Icon(
          Male.male,size: 80,),
        onPressed: (){
          if(colorMale == Colors.grey){
            setState(() {
              colorMale = Colors.red;
              colorFemale = Colors.grey;
              genderText = "0";
            });
          }
          else{
            setState(() {
              colorMale= Colors.grey;
              genderText="";
            });
          }
        },
      ),
    );
    //--------------------------------------------------------------------------------------------------------
    final female = Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          color: colorFemale,
          borderRadius: BorderRadius.all(Radius.circular(80)),
        ),
        child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80.0)),
          child: Icon(
            Female.female,size: 80,),
          onPressed: (){
            if(colorFemale == Colors.grey){
              setState(() {
                colorFemale = Colors.red;
                colorMale = Colors.grey;
                genderText="1";
              });
            }
            else {
              setState(() {
                colorFemale= Colors.grey;
                genderText="";
              });
            }
          },
        ),
    );
    //--------------------------------------------------------------------------------------------------------
    final gender = Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          male,
          SizedBox(width: 20,),
          female
        ],
      ),
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
          iconNoneSelect,
          iconSelect,
          iconNoneSelect,
          iconNoneSelect,
          iconNoneSelect,
          iconNoneSelect,
        ],
      ),
    );
    //------------------------------------------------------------------------------------
    final checkbox = Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.black12,
        )
      ),
      child: Stack(
        children: [
          Positioned(
            left: 5,
            child: Text(
              checkText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontSize: 15,
              ),
            ),
          ),
          FlatButton(
            focusColor: Colors.white,
            hoverColor: Colors.white,
            onPressed: (){
              if(check == false){
                setState(() {
                  check = true;
                  checkText = "x";
                });
              }
              else{
                setState(() {
                  check = false;
                  checkText = "";
                });
              }
              print(checkText);
              },
          ),
        ],
      )
    );

    //------------------------------------------------------------------------------------
    final text3 = Text(
        "Hiển thị giới tính trên hồ sơ của tôi",
        style: TextStyle(
            color: Colors.black26, fontSize: 15
        ),
        textAlign: TextAlign.left
    );
    //------------------------------------------------------------------------------------
    final textCheck = Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          checkbox,
          SizedBox(width: 5,),
          text3
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
          if(colorMale == Colors.grey && colorFemale == Colors.grey){
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(
                      "Bạn chưa chọn giới tính",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15
                      ),
                    ),
                  );
                }
            );
          }
          else{
            updateGender();
          }
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
              TextTitle("Tôi là"),
              SizedBox(height: 20),
              TextDescription("Đây là giới tính hiển thị cho người dùng"),
              SizedBox(height: 120),
              gender,
              SizedBox(height: 150),
              slideIcon,
              SizedBox(height: 10,),
              textCheck,
              SizedBox(height: 10,),
              nextButton
            ],
          ),
        ),
      );
    else
      return Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: 20, top: 120, right: 20, bottom: 0),
          child: ListView(
            children: <Widget>[
              TextTitle("Tôi là"),
              SizedBox(height: 20),
              TextDescription("Đây là giới tính hiển thị cho người dùng"),
              SizedBox(height: 120),
              gender,
              SizedBox(height: 150),
              slideIcon,
              SizedBox(height: 10,),
              textCheck,
              SizedBox(height: 10,),
              nextButton
            ],
          ),
        ),
      );
  }
}