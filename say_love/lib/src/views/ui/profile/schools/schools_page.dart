import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:say_love/src/models/schools.dart';
import 'package:say_love/src/views/ui/profile/void/void_background.dart';
import 'package:shared_preferences/shared_preferences.dart';




class SchoolPage extends StatefulWidget{
  SchoolPage(@required this.school, this.token, this.id);
  List<Schools> school;
  String token = "";
  String id="";
  _SchoolPage createState() => _SchoolPage();
}

class _SchoolPage extends State<SchoolPage> {
  TextEditingController controllerSearchBox = TextEditingController();
  int schoolId;
  String schoolName;
  List<Schools> listViewSchools =new List();
  bool checkSchool=false;

  @override
  void initState() {
    super.initState();
    listViewSchools = widget.school;
  }
  ////////////////////////////////////////////////////////////////////////////////Func updateSchool
  updateSchool() async{
    String id = widget.id;
    String token= widget.token;
    String url = "http://45.76.151.147:8091/api/user/$id/profile";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer $token',
    };
    Map<String, String> jsonPost = {
      "university_id":"$schoolId"
    };

    try{
      Response r = await patch(
          url, headers: headers, body: jsonEncode(jsonPost));
      dynamic jsonBody = json.decode( utf8.decode(r.bodyBytes));
      print(utf8.decode(r.bodyBytes));
      String mess = jsonBody["status_message"];
      SharedPreferences prefs2 = await SharedPreferences.getInstance();
      if(jsonBody["status_code"] == 200){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Void(token:token, id:id)));
        prefs2.setString("school", schoolName);
        prefs2.setInt("schoolID", schoolId);
      }
//      else
//        showDialog(
//            context: context,
//            builder: (BuildContext context) {
//              return AlertDialog(
//                content: Text(
//                  mess,
//                  textAlign: TextAlign.center,
//                  style: TextStyle(
//                      color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15
//                  ),
//                ),
//              );
//            }
//        );
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
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    final searchBox = Container(
      width: 300,
      child: TextField(
        autofocus: false,
        controller: controllerSearchBox,
        onChanged: (value){
          List<Schools> tamp = new List();
            widget.school.forEach((element) {
              String a =element.name.toLowerCase();
              if (a.contains(value) == true)
                tamp.add(element);
            });
            tamp.forEach((element) {
              print("${element.id}-${element.name}-${element.code}");
            });
//          else {
//            widget.school.forEach((element) {
//              tamp.add(element);
//            });
//            tamp.forEach((element) {
//              print("${element.id}-${element.name}-${element.code}");
//            });
//          }
          setState(() {
            listViewSchools = tamp;
          });
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          hintText: "Tìm kiếm trường hoặc chọn",
          hintStyle: TextStyle(color: Colors.black26),
        ),
      ),
    );
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



    final schoolBox = Container(
      width: 300,
      height: 300,
      decoration:BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.black54
        )
      ),
      child: ListView(
        children: listViewSchools.map((e){
//          if(e.name.contains(controllerSearchBox.text)==true)
//            return Container(
//                child: FlatButton(
//                  child: Text(
//                    e.name,
//                    style: TextStyle(fontSize: 13),
//                    overflow: TextOverflow.ellipsis,
//                  ),
//                  onPressed: (){
//                    controllerSearchBox.text = "${e.name}-${e.code}";
//                    schoolId = e.id;
//                    schoolName=e.name;
//                  },
//                )
//            );
//          else if(controllerSearchBox.text == null)
            return Container(
              child: FlatButton(
                child: Text(
                  e.name,
                  style: TextStyle(fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
                onPressed: (){
                  controllerSearchBox.text = "${e.name}-${e.code}";
                  schoolId = e.id;
                  schoolName=e.name;
                },
              )
            );
        }).toList(),
      ),
    );
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    final nextButton = SizedBox(
      height: 50,
      width: 400,
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
          widget.school.forEach((element) {
            if(controllerSearchBox.text == "${element.name}-${element.code}") {
              setState(() {
                checkSchool = true;
              });
            }
          });
          if(checkSchool == true){
            updateSchool();
          }
          else
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(
                      "Bạn chưa chọn trường",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15
                      ),
                    ),
                  );
                }
            );
        },
      ),
    );
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
          iconNoneSelect,
          iconSelect,
          iconNoneSelect,
        ],
      ),
    );

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20,),
          searchBox,
          SizedBox(height: 10,),
          schoolBox,
          SizedBox(height: 80,),
          slideIcon,
          SizedBox(height: 10,),
          nextButton
        ],
      ),
    );
  }

}