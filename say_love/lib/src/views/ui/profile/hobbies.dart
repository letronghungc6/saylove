import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:say_love/src/models/hobby.dart';
import 'package:say_love/src/views/ui/homepage/homepage.dart';
import 'package:say_love/src/views/ui/profile/schools/schools_background.dart';
import 'package:say_love/src/views/utils/text_description.dart';
import 'package:say_love/src/views/utils/text_hobbies.dart';
import 'package:say_love/src/views/utils/text_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Hobbies extends StatefulWidget {
  Hobbies({@required this.token, this.id, this.checkBack});
  String token = "";
  String id="";
  bool checkBack;
  @override
  _Hobbies createState() => _Hobbies();
}

class _Hobbies extends State<Hobbies> {
  List hobby = new List();
  List hobbyText = new List();
  bool isLoading= true;

  @override
  void initState() {
    super.initState();
       getHobby();
      Future.delayed(Duration(seconds:1), ()=>
          setState(() {
            isLoading = false;
          })
      );
  }


   getHobby() async{
    String url = "http://45.76.151.147:8091/api/hobby/all";
    Map<String, String> headers = {
      "Content-type": "application/json"
    };
    try{
      Response r = await get(url,headers: headers);
      dynamic jsonBody = json.decode( utf8.decode(r.bodyBytes));
      print(utf8.decode(r.bodyBytes));
      String mess = jsonBody["status_message"];
      if(jsonBody["status_code"] == 200){
        var hobbyJson = jsonBody["data"] as List;
        List<Hobby> a = hobbyJson .map((i) => Hobby.fromJson(i)).toList();
        a.forEach((element) {
          print(element.value);
          hobby.add(element.value);
        });
      }
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

  updateHobby() async{
    String id = widget.id;
    String token= widget.token;
    String textPost="";
    for(int i = 0; i< hobbyText.length; i++){
      if(i == hobbyText.length - 1){
        textPost = textPost + hobbyText[i];
      }
      else
        textPost = textPost + hobbyText[i]+", ";
    }
    print (textPost);
    String url = "http://45.76.151.147:8091/api/user/$id/profile";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer $token',
    };
    Map<String, String> jsonPost = {
      "hobby":"$textPost"

    };
    try{
      Response r = await patch(
          url, headers: headers, body: jsonEncode(jsonPost));
      dynamic jsonBody = json.decode( utf8.decode(r.bodyBytes));
      print(utf8.decode(r.bodyBytes));
      String mess = jsonBody["status_message"];
      SharedPreferences prefs2 = await SharedPreferences.getInstance();
      if(jsonBody["status_code"] == 200){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> School(token:token, id:id)));
        prefs2.setString("hobby", textPost);
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
          iconNoneSelect,
          iconSelect,
          iconNoneSelect,
          iconNoneSelect,
        ],
      ),
    );
    //-------------------------------------------------------------------------------------------------------
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
          if(hobbyText.length<3 || hobbyText.length >6 ){
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content:
                    Text(
                      "Vui lòng chọn từ 3 đến 6 sở thích.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: "Arial"
                      ),
                    ),
                  );
                }
            );
          }
          else
          updateHobby();
//          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
        },
      ),
    );



//      if (widget.checkBack != true)
        return Scaffold(
            body: (isLoading == true) ? Center(child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),)
                : (widget.checkBack!=true) ?
            Padding(
                padding: EdgeInsets.only(
                    left: 20, top: 20, right: 20, bottom: 0),
                child: ListView(
                    children: <Widget>[
                      back,
                      SizedBox(height: 80),
                      TextTitle("Sở thích"),
                      SizedBox(height: 20),
                      TextDescription("Hãy chọn sở thích của bạn"),
                      SizedBox(height: 20),
                      Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: [
                          for(var i = 0; i<hobby.length;i++)
                            TextHobbies(hobby[i], hobbyText)
                        ],
                      ),
//                      Row(
//                        mainAxisSize: MainAxisSize.min,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: [
//                          TextHobbies(hobby[0], hobbyText),
//                          SizedBox(width: 5,),
//                          TextHobbies(hobby[1], hobbyText),
//                          SizedBox(width: 5,),
//                          TextHobbies(hobby[2], hobbyText),
//                        ],
//                      ),
//                      SizedBox(height: 10,),
//                      Row(
//                        mainAxisSize: MainAxisSize.min,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: [
//                          TextHobbies(hobby[3], hobbyText),
//                          SizedBox(width: 10,),
//                          TextHobbies(hobby[4], hobbyText),
//                          SizedBox(width: 10,),
//                          TextHobbies(hobby[5], hobbyText),
//                        ],
//                      ),
//                      SizedBox(height: 10,),
//                      Row(
//                        mainAxisSize: MainAxisSize.min,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: [
//                          TextHobbies(hobby[6], hobbyText),
//                          SizedBox(width: 10,),
//                          TextHobbies(hobby[7], hobbyText),
//
//                        ],
//                      ),
                      SizedBox(height: 268,),
                      slideIcon,
                      SizedBox(height: 10,),
                      nextButton
                    ]
                )
            )
        : Padding(
                padding: EdgeInsets.only(
                    left: 20, top: 120, right: 20, bottom: 0),
                child: ListView(
                    children: <Widget>[
                      TextTitle("Sở thích"),
                      SizedBox(height: 20),
                      TextDescription("Hãy chọn sở thích của bạn"),
                      SizedBox(height: 20),
                      Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: [
                          for(var i = 0; i<hobby.length;i++)
                            TextHobbies(hobby[i], hobbyText)
                        ],
                      ),
//                      Row(
//                        mainAxisSize: MainAxisSize.min,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: [
//                          TextHobbies(hobby[0], hobbyText),
//                          SizedBox(width: 5,),
//                          TextHobbies(hobby[1], hobbyText),
//                          SizedBox(width: 5,),
//                          TextHobbies(hobby[2], hobbyText),
//                        ],
//                      ),
//                      SizedBox(height: 10,),
//                      Row(
//                        mainAxisSize: MainAxisSize.min,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: [
//                          TextHobbies(hobby[3], hobbyText),
//                          SizedBox(width: 10,),
//                          TextHobbies(hobby[4], hobbyText),
//                          SizedBox(width: 10,),
//                          TextHobbies(hobby[5], hobbyText),
//                        ],
//                      ),
//                      SizedBox(height: 10,),
//                      Row(
//                        mainAxisSize: MainAxisSize.min,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: [
//                          TextHobbies(hobby[6], hobbyText),
//                          SizedBox(width: 10,),
//                          TextHobbies(hobby[7], hobbyText),
//
//                        ],
//                      ),
                      SizedBox(height: 268,),
                      slideIcon,
                      SizedBox(height: 10,),
                      nextButton
                    ]
                )
            )
        );
  }
}