import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:say_love/src/views/ui/profile/birthday.dart';
import 'package:say_love/src/views/utils/text_description.dart';
import 'package:say_love/src/views/utils/text_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Name extends StatefulWidget {
//  MyAppOne({});
  Name({@required this.token, this.id, this.checkBack});
  String token = "";
  String id="";
  bool checkBack;
  @override
  _Name createState() => _Name();
}

class _Name extends State<Name> {
  final _formKey = GlobalKey<FormState>();
  Color borderColorHo = Colors.black26;
  Color borderColorTen = Colors.black26;
  TextEditingController controllerTextHo= TextEditingController();
  TextEditingController controllerTextTen = TextEditingController();

  updateName() async{
    String firstName = controllerTextHo.text;
    String lastName = controllerTextTen.text;
    String id = widget.id;
    String token= widget.token;
    String url = "http://45.76.151.147:8091/api/user/$id/profile";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer $token',
    };
    Map<String, String> jsonPost = {
      "first_name":"$firstName",
      "last_name":"$lastName"
    };
    print(id);
    print(token);
    try{
      Response r = await patch(
          url, headers: headers, body: jsonEncode(jsonPost));
      dynamic jsonBody = json.decode( utf8.decode(r.bodyBytes));
      print(utf8.decode(r.bodyBytes));
      String mess = jsonBody["status_message"];
      SharedPreferences prefs2 = await SharedPreferences.getInstance();
      if(jsonBody["status_code"] == 200){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Birthday(token:token, id:id)));
        prefs2.setString("first_name", firstName);
        prefs2.setString("last_name", lastName);
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
                "L???i kh??ng x??c ?????nh",
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
    AlertDialog alertCheckHo = AlertDialog(
      content: Text(
        "B???n ch??a nh???p h??? v?? t??n l??t.",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15
        ),
      ),
    );

    AlertDialog alertCheckHoTen = AlertDialog(
      content: Text(
        "Vui l??ng nh???p h??? v?? t??n c???a b???n.",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15
        ),
      ),
    );

    AlertDialog alertCheckTen = AlertDialog(
      content: Text(
        "B???n ch??a nh???p t??n.",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15
        ),
      ),
    );

    //--------------------------------------------------------------------------------------------------------
    final ho = Container(
        height: 50,
        width: 310,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: borderColorHo,
            )
        ),
        child: TextFormField(
            autofocus: false,
            controller: controllerTextHo,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: InputBorder.none,
              hintText: "H??? v?? t??n l??t",
              hintStyle: TextStyle(color: Colors.black26),
            ),
        )
    );
    //--------------------------------------------------------------------------------------------------------
    final ten = Container(
        height: 50,
        width: 310,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: borderColorTen,
            )
        ),
        child: TextFormField(
          autofocus: false,
          controller: controllerTextTen,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: InputBorder.none,
            hintText: "T??n c???a b???n",
            hintStyle: TextStyle(color: Colors.black26),
          ),
        )
    );
    //------------------------------------------------------------------------------------
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
        iconSelect,
        iconNoneSelect,
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
          "TI???P T???C",
          style: TextStyle(
              color: Colors.white, fontSize: 15
          ),
          textAlign: TextAlign.center,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: () {
          if(controllerTextTen.text == "" && controllerTextHo.text==""){
            setState(() {
              borderColorTen = Colors.red;
              borderColorHo =Colors.red;
            });
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alertCheckHoTen;
              },
            );
          }
          else if(controllerTextHo.text == ""){
            setState(() {
              borderColorTen = Colors.black26;
              borderColorHo =Colors.red;
            });
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alertCheckHo;
              },
            );
          }
          else if(controllerTextTen.text == ""){
            setState(() {
              borderColorHo = Colors.black26;
              borderColorTen =Colors.red;
            });
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alertCheckTen;
              },
            );
          }
          else if(controllerTextTen.text != null && controllerTextHo.text!=null){
            setState(() {
              borderColorHo = Colors.black26;
              borderColorTen =Colors.black26;
            });
          }
          if(borderColorHo == borderColorTen && borderColorTen == Colors.black26){
            updateName();
//            print(controllerTextHo.text+" "+ controllerTextTen.text);
//            print(widget.token);
//            print(widget.id);
          }
        },
      ),
    );





    return Scaffold(
      body: GestureDetector(
        onTap: (){
      FocusScope.of(context).requestFocus(new FocusNode());
    },
        child: Padding(
          padding: EdgeInsets.only(left: 20, top: 120, right: 20, bottom: 0),
                child: ListView(
                  children: <Widget>[
                    TextTitle("T??n c???a t??i l??"),
                    SizedBox(height: 20),
                    TextDescription("????y l?? t??n hi???n th??? c???a b???n tr??n SayLove v?? b???n kh??ng th??? ?????i t??n ???????c"),
                    SizedBox(height: 10,),
                    ho,
                    SizedBox(height: 10,),
                    ten,
                    SizedBox(height: 350,),
                    slideIcon,
                    SizedBox(height: 10,),
                    nextButton
                  ],
                ),
        )
      )
    );
  }
}