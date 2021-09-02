import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:say_love/src/views/ui/profile/hobbies.dart';
import 'package:say_love/src/views/utils/text_description.dart';
import 'package:say_love/src/views/utils/text_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeightWeight extends StatefulWidget {
  HeightWeight({@required this.token, this.id, this.checkBack});
  String token = "";
  String id="";
  bool checkBack;
  @override
  _HeightWeight createState() => _HeightWeight();
}

class _HeightWeight extends State<HeightWeight> {
  String numberHeight1 ="160";
  String numberWeight1 ="50";
  String numberHeight2 ="5";
  String numberWeight2 ="5";

  updateHeightWeight() async{
    String id = widget.id;
    String token= widget.token;
    String height ="$numberHeight1.$numberHeight2";
    String weight = "$numberWeight1.$numberWeight2";
    String url = "http://45.76.151.147:8091/api/user/$id/profile";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer $token',
    };
    Map<String, String> jsonPost = {
      "height":"$height",
      "weight":"$weight"
    };
    try{
      Response r = await patch(
          url, headers: headers, body: jsonEncode(jsonPost));
      dynamic jsonBody = json.decode( utf8.decode(r.bodyBytes));
      print(utf8.decode(r.bodyBytes));
      String mess = jsonBody["status_message"];
      SharedPreferences prefs2 = await SharedPreferences.getInstance();
      if(jsonBody["status_code"] == 200){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Hobbies(token:token, id:id)));
        prefs2.setString("height", height);
        prefs2.setString("weight", weight);
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
          iconNoneSelect,
          iconSelect,
          iconNoneSelect,
          iconNoneSelect,
          iconNoneSelect,
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
          updateHeightWeight();
        },
      ),
    );
    if(widget.checkBack!=true)
      return Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 0),
          child: ListView(
            children: <Widget>[
              back,
              SizedBox(height: 80),
              TextTitle("Chiều cao và cân nặng của tôi là"),
              SizedBox(height: 20),
              TextDescription("Cân nặng và chiều cao của tôi"),
              SizedBox(height: 40),
              heightWeight,
              SizedBox(height: 85),
              slideIcon,
              SizedBox(height: 10,),
              nextButton
            ],
          ),
        ),
      );
    else return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 20, top: 120, right: 20, bottom: 0),
        child: ListView(
          children: <Widget>[
            TextTitle("Chiều cao và cân nặng của tôi là"),
            SizedBox(height: 20),
            TextDescription("Cân nặng và chiều cao của tôi"),
            SizedBox(height: 40),
            heightWeight,
            SizedBox(height: 85),
            slideIcon,
            SizedBox(height: 10,),
            nextButton
          ],
        ),
      ),
    );
  }
}