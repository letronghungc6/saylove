import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:say_love/src/views/ui/login/login_screen.dart';
import 'package:say_love/src/views/utils/text_title.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({@required this.textOTP, this.textEmail});
  String textOTP="";
  String textEmail = "";
  @override
  _ResetPassword createState() => _ResetPassword();
}

class _ResetPassword extends State<ResetPassword>{


  final _formKey = GlobalKey<FormState>();
  bool checkPassword=true;
  bool checkConfirmPassword=true;
  Color borderColorPassword = Colors.black26;
  Color borderColorConfirmPassword = Colors.black26;
  TextEditingController controllerPassword = TextEditingController();
  //Call api reset password
  postAPI() async{
    String textPassword = controllerPassword.text;
    String textOTP = widget.textOTP;
    String url = "http://45.76.151.147:8091/api/user/password/reset";
    Map<String, String> headers = {
      "Content-type": "application/json"
    };
    Map<String, String> jsonPost = {
      "codes":"$textOTP",
      "password":"$textPassword"
    };
    print(textOTP);
    print(textPassword);
    try {
      Response r = await post(
          url, headers: headers, body: jsonEncode(jsonPost));
      dynamic jsonBody = json.decode(utf8.decode(r.bodyBytes));
      print(utf8.decode(r.bodyBytes));
      String mess = jsonBody["status_message"];
      if(jsonBody["status_code"]==200){
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
                actions: [
                  ElevatedButton(
                    child: Text("Đăng nhập"),
                    onPressed: (){
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (c) => LoginScreen(textEmail: widget.textEmail,)),
                      (route) => false);
                    },
                  )
                ],
              );
            }
        );
      }
      else if(jsonBody["status_code"]==400){
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(
                  mess,
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


  //Kiểm tra mật khẩu
  bool isValidPassWord(){
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$').hasMatch(controllerPassword.text);
  }

  @override
  Widget build(BuildContext context) {

    AlertDialog alertPassword = AlertDialog(
      content: Text(
        "Bạn chưa nhập password.",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15
        ),
      ),
    );

    AlertDialog alertPasswordLength = AlertDialog(
      content: Text(
        "Mật khẩu phải lớn hơn 8 kí tự.",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15
        ),
      ),
    );

    AlertDialog alertPasswordForm = AlertDialog(
      content: Text(
        "Mật khẩu phải có chữ hoa, chữ thường và số",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15
        ),
      ),
    );

    AlertDialog alertPasswordCheckConfirm = AlertDialog(
      content: Text(
        "Xác nhận mật khẩu không chính xác.",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15
        ),
      ),
    );

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

    final password = Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            color: borderColorPassword,
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
              autofocus: false,
              obscureText: checkPassword,
              controller: controllerPassword,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
                  border: InputBorder.none,
                  hintText: "Mật khẩu mới",
                  hintStyle: TextStyle(
                      color: Colors.black26
                  )
              ),
              validator: (value) {
                if(value.isEmpty){
                  setState(() {
                    borderColorPassword = Colors.red;
                  });
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alertPassword;
                    },
                  );
                }
                else if(value.length < 8){
                  setState(() {
                    borderColorPassword = Colors.red;
                  });
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alertPasswordLength;
                    },
                  );
                }
                else if(isValidPassWord()==false){
                  setState(() {
                    borderColorPassword = Colors.red;
                  });
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alertPasswordForm;
                    },
                  );
                }
                else {
                  setState(() {
                    borderColorPassword = Colors.black26;
                  });
                  return null;
                }
              },
            ),
          ),
          Padding(
            padding:
            EdgeInsets.only(left: 0, right: 0.0),
            child: IconButton(
              icon: Icon(Icons.lock_outline,
                color: Colors.black26,
              ),
              iconSize: 24,
              onPressed: () {
                setState(() {
                  checkPassword = !checkPassword;
                });
              },
            ),
          ),
        ],
      ),
    );
    //--------------------------------------------------------------------------------------------------------
    final confirmPassword = Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            color: borderColorConfirmPassword,
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
              autofocus: false,
              obscureText: checkConfirmPassword,
//                initialValue: "",
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
                  border: InputBorder.none,
                  hintText: "Xác nhận mật khẩu",
                  hintStyle: TextStyle(
                      color: Colors.black26
                  )
              ),
              validator: (value) {
                if(value != controllerPassword.text){
                  setState(() {
                    borderColorConfirmPassword = Colors.red;
                  });
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alertPasswordCheckConfirm;
                    },
                  );
                }
                else {
                  setState(() {
                    borderColorConfirmPassword = Colors.black26;
                  });
                  return null;
                }
              },
            ),
          ),
          Padding(
            padding:
            EdgeInsets.only(left: 0, right: 0.0),
            child: IconButton(
              icon: Icon(Icons.lock_outline,
                color: Colors.black26,
              ),
              iconSize: 24,
              onPressed: () {
                setState(() {
                  checkConfirmPassword = !checkConfirmPassword;
                });
              },
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
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
          }
          if(borderColorConfirmPassword == borderColorPassword && borderColorPassword == Colors.black26){
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
            padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 0),
            child: Form(
              key: _formKey ,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  back,
                  SizedBox(height: 80.0),
                  TextTitle("Thay đổi mật khẩu"),
                  SizedBox(height: 40.0),
                  password,
                  SizedBox(height: 10.0),
                  confirmPassword,
                  SizedBox(height: 200),
                next
                ],
              ),
            )
        ),
      ),
    );


  }

}