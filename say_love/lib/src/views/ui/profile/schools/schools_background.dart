import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:say_love/src/views/ui/profile/schools/schools_page.dart';
import 'package:say_love/src/views/utils/text_description.dart';
import 'package:say_love/src/views/utils/text_title.dart';
import 'package:say_love/src/models/schools.dart';
import 'package:http/http.dart';

class School extends StatefulWidget{
  School({@required this.token, this.id, this.checkBack});
  String token = "";
  String id="";
  bool checkBack;
  _School createState() => _School();
}

class _School extends State<School> {
  List<Schools> school = new List();
  bool isLoading= true;

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
    //----------------------------------------------------------------------------------


      return Scaffold(
          body:(isLoading == true) ? Center(child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ),) : (widget.checkBack != true) ?
          GestureDetector(
              onTap: (){
                FocusScope.of(context).requestFocus(new FocusNode());
              },
            child : Padding(
              padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 0),
              child: ListView(
                children: [
                  back,
                  SizedBox(height: 80,),
                  TextTitle("Trường học"),
                  SizedBox(height: 20),
                  TextDescription("Chọn trường của bạn"),
                  SchoolPage(school, widget.token, widget.id),
                ],
              )
            )
          )
        : GestureDetector(
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
                  SchoolPage(school, widget.token, widget.id),
                ],
              )
            )
          )
      );
  }

}