import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:say_love/src/views/ui/login/send_otp_password_screen.dart';
import 'package:say_love/src/views/utils/text_description.dart';
import 'package:say_love/src/views/utils/text_title.dart';


class ForgotPasswordScreen extends StatefulWidget {
//  MyAppOne({});
  @override
  _ForgotPasswordScreen createState() => _ForgotPasswordScreen();
}

class _ForgotPasswordScreen extends State<ForgotPasswordScreen>{
  Color borderColorEmail = Colors.black26;
//  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerTextEmail = TextEditingController();

  //Call API forgot password
  postAPI() async{
    String textEmail = controllerTextEmail.text;
    String url = "http://45.76.151.147:8091/api/user/password/forgot";
    Map<String, String> headers = {
      "Content-type": "application/json"
    };
    Map<String, String> jsonPost = {
      "email": "$textEmail"
    };
    try {
      Response r = await post(
          url, headers: headers, body: jsonEncode(jsonPost));
      dynamic jsonBody = json.decode(utf8.decode(r.bodyBytes));
      print(utf8.decode(r.bodyBytes));
      String mess = jsonBody["status_message"];
      if (jsonBody["status_code"] == 200) {
        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=> SendOTPPassword(textEmail: controllerTextEmail.text
            )
        )
        );
      }
      else if(jsonBody["status_code"] == 400){
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content:
                Text(
                  mess,
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
    }
    catch(e){
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content:
              Text(
                "Lỗi không xác định",
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
  }


  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
        ],),
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext builderContext) {
          return alert;
        }
    );
  }

  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(controllerTextEmail.text);
  }


  @override
  Widget build(BuildContext context) {

    AlertDialog alertEmailCheck = AlertDialog(
      content: Text(
        "Email không hợp lệ.",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15
        ),
      ),
    );

    AlertDialog alertEmail = AlertDialog(
      content: Text(
        "Bạn chưa nhập email.",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15
        ),
      ),
    );

    //--------------------------------------------------------------------------------------------------------
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
    final email = Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            color: borderColorEmail,
          )
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width*0.7,
            child: TextFormField(
                controller: controllerTextEmail,
                keyboardType: TextInputType.emailAddress,
                autofocus: false,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
                    border: InputBorder.none,
                    hintText: "Địa chỉ email",
                    hintStyle: TextStyle(
                        color: Colors.black26
                    )
                ),
            ),
          ),
          Padding(
            padding:
            EdgeInsets.only(left: 10, right: 15.0),
            child: Icon(
              Icons.email_outlined,
              color: Colors.black26,
            ),
          ),
        ],
      ),
    );
//--------------------------------------------------------------------------------------------------------
    final next = SizedBox(
      height: 50,
      child: RaisedButton(
        color: Colors.red,
        child: Text(
          "Tiếp tục",
          style: TextStyle(
              color: Colors.white, fontSize: 15
          ),
          textAlign: TextAlign.center,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: () {
            if(controllerTextEmail.text.isEmpty){
            setState(() {
              borderColorEmail = Colors.red;
            });
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alertEmail;
                },
            );
          }
            else if(isValidEmail()== false){
              setState(() {
                borderColorEmail = Colors.red;
              });
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alertEmailCheck;
                },
              );
            }
          else {
            setState(() {
              borderColorEmail = Colors.black26;
            });
          }
          if(borderColorEmail == Colors.black26){
            showLoaderDialog(context);
            postAPI();
          }
        },
      ),
    );
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child:Padding(
          padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 150),
          child: Form(
//            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                back,
                SizedBox(height: 80),
                TextTitle("Quên mật khẩu"),
                SizedBox(height: 10.0),
                TextDescription("Nhập thông tin tài khoản đã tạo"),
                SizedBox(height: 40.0),
                email,
                SizedBox(height: 200.0),
                next,
          ],
        ),
        ),
      ),
      ),
    );
  }

}
