import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:say_love/src/views/ui/login/forgot_password_screen.dart';
import 'package:say_love/src/views/ui/login/reset_password_screen.dart';
import 'package:say_love/src/views/ui/profile/name.dart';
import 'package:say_love/src/views/utils/text_description.dart';
import 'package:say_love/src/views/utils/text_title.dart';

class SendOTPPassword extends StatefulWidget {
  SendOTPPassword({@required this.textEmail});
  String textEmail="";
  @override
  _SendOTPPassword createState() => _SendOTPPassword();
}

class _SendOTPPassword extends State<SendOTPPassword> {

  TextEditingController controllerTextOTP1 = TextEditingController();
  TextEditingController controllerTextOTP2 = TextEditingController();
  TextEditingController controllerTextOTP3 = TextEditingController();
  TextEditingController controllerTextOTP4 = TextEditingController();
  TextEditingController controllerTextOTP5 = TextEditingController();
  TextEditingController controllerTextOTP6 = TextEditingController();
  Color colorTextResend = Colors.red;
  String textResend = "Bạn chưa có mã OTP?";
  bool isButtonResend=true;
  Timer _timer;

  //Xác thực API password
  verifyEmail() async{
    String textEmail = widget.textEmail;
    String textOTP = controllerTextOTP1.text + controllerTextOTP2.text + controllerTextOTP3.text +
        controllerTextOTP4.text + controllerTextOTP5.text + controllerTextOTP6.text;
    String url = "http://45.76.151.147:8091/api/user/password/forgot/verify/email-otp";
    Map<String, String> headers = {
      "Content-type": "application/json",
    };
    Map<String, String> jsonPost = {
      "email":"$textEmail",
      "codes":"$textOTP"
    };
    try{
      Response r = await post(
          url, headers: headers, body: jsonEncode(jsonPost));
      dynamic jsonBody = json.decode( utf8.decode(r.bodyBytes));
      print(utf8.decode(r.bodyBytes));
      if (jsonBody["status_code"] == 200) {
        Navigator.push(context, MaterialPageRoute(
              builder: (context)=> ResetPassword(textOTP : textOTP, textEmail :widget.textEmail)
        )
        );
      }
      else if(jsonBody["status_code"] == 400){
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(
                  jsonBody["status_message"],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
//                      fontFamily: "Times New Roman"
                  ),
                ),
              );
            }
        );
        setState(() {
          controllerTextOTP1.text="";
          controllerTextOTP2.text="";
          controllerTextOTP3.text="";
          controllerTextOTP4.text="";
          controllerTextOTP5.text="";
          controllerTextOTP6.text="";
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
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
//                      fontFamily: "Times New Roman"
                ),
              ),
            );
          }
      );
    }
  }
  //Send lại otp
  sendOTPAPI() async{
    String textEmail = widget.textEmail;
    String url = "http://45.76.151.147:8091/api/user/password/forgot/send-otp";
    Map<String, String> headers = {
      "Content-type": "application/json",
    };
    Map<String, String> jsonPost = {
      "email":"$textEmail",
      "method_send_otp":"1"
    };
    try{
      Response r = await post(
          url, headers: headers, body: jsonEncode(jsonPost));
      print(utf8.decode(r.bodyBytes));
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
    AlertDialog checkOTP = AlertDialog(
      content: Text(
        "Hãy nhập đầy đủ mã OTP.",
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
    final word1 =  Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(
              width: 1,
              color: Colors.black26
          )
      ),
      child: TextFormField(
        textAlign: TextAlign.center,
        autofocus: false,
        controller: controllerTextOTP1,
        style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black
        ),
        textInputAction: TextInputAction.next,
        onChanged: (_) => FocusScope.of(context).nextFocus(),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          new LengthLimitingTextInputFormatter(1),
          // ignore: deprecated_member_use
          WhitelistingTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 5, right: 5),
            border: InputBorder.none,
            hintText: "_",
            hintStyle: TextStyle(
              fontSize: 30,
              color: Colors.black26,
            )
        ),
      ),
    );
    //--------------------------------------------------------------------------------------------------------
    final word2 =  Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(
              width: 1,
              color: Colors.black26
          )
      ),
      child: TextFormField(
        textAlign: TextAlign.center,
        autofocus: false,
        controller: controllerTextOTP2,
        style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black
        ),
        textInputAction: TextInputAction.next,
        onChanged: (_) => FocusScope.of(context).nextFocus(),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          new LengthLimitingTextInputFormatter(1),
          // ignore: deprecated_member_use
          WhitelistingTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 5, right: 5),
            border: InputBorder.none,
            hintText: "_",
            hintStyle: TextStyle(
              fontSize: 30,
              color: Colors.black26,
            )
        ),
      ),
    );
    //--------------------------------------------------------------------------------------------------------
    final word3 =  Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(
              width: 1,
              color: Colors.black26
          )
      ),
      child: TextFormField(
        textAlign: TextAlign.center,
        autofocus: false,
        controller: controllerTextOTP3,
        style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black
        ),
        textInputAction: TextInputAction.next,
        onChanged: (_) => FocusScope.of(context).nextFocus(),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          new LengthLimitingTextInputFormatter(1),
          // ignore: deprecated_member_use
          WhitelistingTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 5, right: 5),
            border: InputBorder.none,
            hintText: "_",
            hintStyle: TextStyle(
              fontSize: 30,
              color: Colors.black26,
            )
        ),
      ),
    );
    //--------------------------------------------------------------------------------------------------------
    final word4 =  Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(
              width: 1,
              color: Colors.black26
          )
      ),
      child: TextFormField(
        textAlign: TextAlign.center,
        autofocus: false,
        controller: controllerTextOTP4,
        style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black
        ),
        textInputAction: TextInputAction.next,
        onChanged: (_) => FocusScope.of(context).nextFocus(),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          new LengthLimitingTextInputFormatter(1),
          // ignore: deprecated_member_use
          WhitelistingTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 5, right: 5),
            border: InputBorder.none,
            hintText: "_",
            hintStyle: TextStyle(
              fontSize: 30,
              color: Colors.black26,
            )
        ),
      ),
    );
    //--------------------------------------------------------------------------------------------------------
    final word5 =  Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(
              width: 1,
              color: Colors.black26
          )
      ),
      child: TextFormField(
        textAlign: TextAlign.center,
        autofocus: false,
        controller: controllerTextOTP5,
        style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black
        ),
        textInputAction: TextInputAction.next,
        onChanged: (_) => FocusScope.of(context).nextFocus(),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          new LengthLimitingTextInputFormatter(1),
          // ignore: deprecated_member_use
          WhitelistingTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 5, right: 5),
            border: InputBorder.none,
            hintText: "_",
            hintStyle: TextStyle(
              fontSize: 30,
              color: Colors.black26,
            )
        ),
      ),
    );
    //--------------------------------------------------------------------------------------------------------
    final word6 =  Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(
              width: 1,
              color: Colors.black26
          )
      ),
      child: TextFormField(
        textAlign: TextAlign.center,
        autofocus: false,
        controller: controllerTextOTP6,
        style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          new LengthLimitingTextInputFormatter(1),
          // ignore: deprecated_member_use
          WhitelistingTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 5, right: 5),
            border: InputBorder.none,
            hintText: "_",
            hintStyle: TextStyle(
              fontSize: 30,
              color: Colors.black26,
            )
        ),
      ),
    );
    //--------------------------------------------------------------------------------------------------------
    final input = Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          word1,
          word2,
          word3,
          word4,
          word5,
          word6
        ],
      ),
    );
    //--------------------------------------------------------------------------------------------------------
    final authen = SizedBox(
      height: 50,
      child: RaisedButton(
        color: Colors.red,
        child: Text(
          "Xác thực tài khoản",
          style: TextStyle(
              color: Colors.white, fontSize: 15
          ),
          textAlign: TextAlign.center,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: () {
          String textOTP = controllerTextOTP1.text + controllerTextOTP2.text + controllerTextOTP3.text +
              controllerTextOTP4.text + controllerTextOTP5.text + controllerTextOTP6.text;
          if(textOTP.length < 6){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return checkOTP;
              },
            );
          }
          else
          verifyEmail();
        },
      ),
    );
//--------------------------------------------------------------------------------------------------------
    final reSend = Container(
        alignment: Alignment.centerLeft,
        child: FlatButton(
          child: Text(
              textResend,
              style: TextStyle(
                color: colorTextResend, fontSize: 15,
              ),
              textAlign: TextAlign.left
          ),
          onPressed: () {
            print(isButtonResend);
            if(isButtonResend == true) {
              sendOTPAPI();
              setState(() {
                textResend = "Vui lòng đợi 60s để thử lại";
                colorTextResend = Colors.black26;
                isButtonResend = false;
              });
              _timer = new Timer(const Duration(seconds: 60), () {
                setState(() {
                  textResend = "Bạn chưa có mã OTP?";
                  colorTextResend = Colors.red;
                  isButtonResend = true;
                });
              });
            }
          },
        )
    );
    //--------------------------------------------------------------------------------------------------------
    return Scaffold(
      body: GestureDetector(
        onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
        },
        child:Padding(
          padding: EdgeInsets.only(left: 30, top: 20, right: 30, bottom: 150),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              back,
              SizedBox(height: 80),
              TextTitle("Gửi OTP!"),
              SizedBox(height: 10.0),
              TextDescription("Nhập 6 mã kí tự đã gửi đến "+ widget.textEmail +" của bạn. Hãy nhập đúng số"),
              SizedBox(height: 40.0),
              input,
              SizedBox(height: 40.0),
              authen,
              SizedBox(height: 40.0),
              reSend,
          ],
        ),
      ),
      ),
    );
  }
}
