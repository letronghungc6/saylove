import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:say_love/src/views/ui/profile/schools/schools_page.dart';
import 'package:say_love/src/views/utils/text_description.dart';
import 'package:say_love/src/views/utils/text_title.dart';
import 'package:say_love/src/models/schools.dart';
import 'package:http/http.dart';

class EditSchool extends StatefulWidget{
  _EditSchool createState() => _EditSchool();
}

class _EditSchool extends State<EditSchool> {
  List<Schools> school = new List();
  bool isLoading= true;
  TextEditingController controllerSearchBox = TextEditingController();
  int schoolId;
  String schoolName;
  List<Schools> listViewSchools =new List();
  bool checkSchool=false;



  @override
  void initState() {
    super.initState();
    getSchool();
    Future.delayed(Duration(seconds:1), ()=>
        setState(() {
          isLoading = false;
        })
    );

  }

  getSchool() async{
    String url = "http://45.76.151.147:8091/api/university/all";
    Map<String, String> headers = {
      "Content-type": "application/json"
    };
    try{
      Response r = await get(url,headers: headers);
      dynamic jsonBody = json.decode( utf8.decode(r.bodyBytes));
      print(utf8.decode(r.bodyBytes));
      String mess = jsonBody["status_message"];
      if(jsonBody["status_code"] == 200){
        var schoolList = jsonBody["data"] as List;
        List<Schools> a = schoolList .map((i) => Schools.fromJson(i)).toList();
        school = a;
        listViewSchools = a;
        school.forEach((element) {
          print("${element.id}-${element.name}-${element.code}");
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

  @override
  Widget build(BuildContext context) {
    //----------------------------------------------------------------------------------
    final searchBox = Container(
      width: 300,
      child: TextField(
        autofocus: false,
        controller: controllerSearchBox,
        onChanged: (value){
          List<Schools> tamp = new List();
          school.forEach((element) {
            String a =element.name.toLowerCase();
            if (a.contains(value) == true)
              tamp.add(element);
          });
          tamp.forEach((element) {
            print("${element.id}-${element.name}-${element.code}");
          });
//          else {
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
          school.forEach((element) {
            if(controllerSearchBox.text == "${element.name}-${element.code}") {
              setState(() {
                checkSchool = true;
              });
            }
          });
          if(checkSchool == true){
            Navigator.pop(context, [schoolId, schoolName]);
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

    return Scaffold(
        body:(isLoading == true) ? Center(child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),) : GestureDetector(
            onTap: (){
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child : Padding(
                padding: EdgeInsets.only(left: 20, top: 120, right: 20, bottom: 0),
                child: ListView(
                  children: [
                    TextTitle("Trường học"),
                    SizedBox(height: 20),
                    TextDescription("Chọn trường của bạn"),
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20,),
                          searchBox,
                          SizedBox(height: 10,),
                          schoolBox,
                          SizedBox(height: 130,),
                          nextButton
                        ],
                      ),
                    )
                  ],
                )
            )
        )
    );
  }

}