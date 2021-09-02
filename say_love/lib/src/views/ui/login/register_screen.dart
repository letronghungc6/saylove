import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:say_love/src/views/ui/login/send_otp_register_screen.dart';
import 'package:say_love/src/views/utils/text_description.dart';
import 'package:say_love/src/views/utils/text_title.dart';


class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreen createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  bool checkPassword=true;
  bool checkConfirmPassword=true;
  Color borderColorEmail = Colors.black26;
  Color borderColorPassword = Colors.black26;
  Color borderColorConfirmPassword = Colors.black26;
  TextEditingController controllerTextEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerConfirmPassword = TextEditingController();

  //Api send_otp_verify
  sendOTPAPI() async{
    String textEmail = controllerTextEmail.text;
    String url = "http://45.76.151.147:8091/api/auth/register/send_otp_verify";
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
      dynamic jsonBody = json.decode(utf8.decode(r.bodyBytes));
      if (jsonBody["status_code"] == 200) {
        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=> SendOTPRegister(textEmail: textEmail)
        )
        );
      }
    }
    catch(e){
      Navigator.of(context).pop();
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
  //gọi api register
  postAPI() async{
    String textEmail = controllerTextEmail.text;
    String textPassword = controllerPassword.text;
    String url = "http://45.76.151.147:8091/api/auth/register";
    Map<String, String> headers = {
      "Content-type": "application/json",

    };
    print(headers);
    Map<String, String> jsonPost = {
      "username": "$textEmail",
      "password": "$textPassword"
    };
    try{
      Response r = await post(url, headers: headers, body:jsonEncode(jsonPost));
      print(utf8.decode(r.bodyBytes));
      dynamic jsonBody = json.decode(utf8.decode(r.bodyBytes));
      String mess = jsonBody["status_message"];
      // Tài khoản mới thì chuyển trang OTP
      if (jsonBody["status_code"] == 200) {
        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=> SendOTPRegister(textEmail: textEmail)
        )
        );
      }
      //Tài khoản đã tồn tại
      else if(jsonBody["status_code"] == 400 && mess == "Email này đã được đăng kí."){
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(
                  "\n"+mess+"\n",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              );
            }
        );
      }
      //Tài khoản chưa xác thực if(mess == "Email này chưa được xác thực.")
      else if( jsonBody["status_code"] == 400 && mess == "Email này chưa được xác thực."){
        Navigator.of(context).pop();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(mess),
                content: Text(
                  "Bạn có muốn xác thực tài khoản?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                actions: [
                  ElevatedButton(
                    child: Text("Có"),
                    onPressed: () {
                        Navigator.of(context).pop();
                        showLoaderDialog(context);
                        sendOTPAPI();
                    },
                  ),
                  ElevatedButton(
                    child: Text("Không"),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  )
                ],
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



  //ProgessDialog
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

  //kiểm tra email
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(controllerTextEmail.text);
  }
  //Kiểm tra mật khẩu
  bool isValidPassWord(){
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$').hasMatch(controllerPassword.text);
  }


  @override
  Widget build(BuildContext context) {

    AlertDialog alertEmail = AlertDialog(
      content: Text(
        "Bạn chưa nhập email.",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15
        ),
      ),
    );

    AlertDialog alertEmailCheck = AlertDialog(
      content: Text(
        "Email không hợp lệ.",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15
        ),
      ),
    );

    AlertDialog alertPassword = AlertDialog(
      content: Text(
        "Bạn chưa nhập mật khẩu.",
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
    var email = Container(
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
                    ),
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
                    hintText: "Mật khẩu",
                    hintStyle: TextStyle(
                        color: Colors.black26
                    )
                ),
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
                controller: controllerConfirmPassword,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
                    border: InputBorder.none,
                    hintText: "Xác nhận mật khẩu",
                    hintStyle: TextStyle(
                        color: Colors.black26
                    )
                ),
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
    final register = SizedBox(
      height: 50,
      child: RaisedButton(
        color: Colors.red,
        child: Text(
          "Đăng kí tài khoản",
          style: TextStyle(
              color: Colors.white, fontSize: 15
          ),
          textAlign: TextAlign.center,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: () {
          ///////////////////////////////////////////////////////////////////////////////////////Check sau khi nhập email
          if(borderColorEmail == Colors.black26) {
            /////////////////////////////////////////////////////////////////////////////////Kiểm tra coi nhập email chưa
            if (controllerTextEmail.text.isEmpty) {
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
            ////////////////////////////////////////////////////////////////////////////////Kiểm tra email hợp lệ hay chưa
            else if (isValidEmail() == false) {
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
            /////////////////////////////////////////////////////////////////Nếu email đúng rồi thì kiểm tra password
            else if(borderColorPassword == Colors.black26){
              ///////////////////////////////////////////////////////////Kiểm tra coi nhập pass chưa
              if(controllerPassword.text.isEmpty){
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
              ////////////////////////////////////////////////////////Kiểm tra độ dài của pass
              else if(controllerPassword.text.length < 8){
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
              ///////////////////////////////////////////////////////////////////Kiểm tra pass đúng form chưa
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
              //////////////////////////////////////////////////////////////////Nếu pass đúng thì kiểm tra confirm
              else if(borderColorConfirmPassword == Colors.black26){
                ///////////////////////////////////////////////////////////Kiểm tra confirm đúng chưa
                if(controllerConfirmPassword.text != controllerPassword.text){
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
              }
              //////////////////////////////////////////////////Kiểm tra sau khi nhập lại
              else {
                ///////////////////////////////////////////////////////////Kiểm tra confirm đúng chưa
                if(controllerConfirmPassword.text != controllerPassword.text){
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
                ///////////////////////////////////////////////////////////Nếu confirm đúng
                else {
                  setState(() {
                    borderColorConfirmPassword = Colors.black26;
                  });
                }
              }
            }
            ////////////////////////////////////////////////////////////////////////Nếu nhập pass sai thì quay lại check tiếp
            else if(borderColorPassword == Colors.red){
              if(controllerPassword.text.isEmpty){
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
              else if(controllerPassword.text.length < 8){
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
                if(borderColorConfirmPassword == Colors.black26){
                  if(controllerConfirmPassword.text != controllerPassword.text){
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
                }
                else {
                  if(controllerConfirmPassword.text != controllerPassword.text){
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
                  else{
                    setState(() {
                      borderColorConfirmPassword = Colors.black26;
                    });
                  }
                }
              }
            }
          }
          ////////////////////////////////////Nếu email sai nhập lại thì quay lại check tiếp
          else if(borderColorEmail == Colors.red){
            if (controllerTextEmail.text.isEmpty) {
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
            else if (isValidEmail() == false) {
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
              if(borderColorPassword == Colors.black26){
                if(controllerPassword.text.isEmpty){
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
                else if(controllerPassword.text.length < 8){
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
                else if(borderColorConfirmPassword == Colors.black26){
                  if(controllerConfirmPassword.text != controllerPassword.text){
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
                }
                else {
                  if(controllerConfirmPassword.text != controllerPassword.text){
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
                  else{
                    setState(() {
                      borderColorConfirmPassword = Colors.black26;
                    });
                  }
                }
              }
              else if(borderColorPassword == Colors.red){
                if(controllerPassword.text.isEmpty){
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
                else if(controllerPassword.text.length < 8){
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
                  if(borderColorConfirmPassword == Colors.black26){
                    if(controllerConfirmPassword.text != controllerPassword.text){
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
                  }
                  else {
                    if(controllerConfirmPassword.text != controllerPassword.text){
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
                    else{
                      setState(() {
                        borderColorConfirmPassword = Colors.black26;
                      });
                    }
                  }
                }
              }
            }
          }
          if(borderColorEmail == borderColorPassword && borderColorPassword ==borderColorConfirmPassword && borderColorConfirmPassword == Colors.black26){
            showLoaderDialog(context);
            postAPI();
          }
        },
      ),
    );
//--------------------------------------------------------------------------------------------------------
    final text3 = Text(
      "Bạn đã có tài khoản?",
      style: TextStyle(
          color: Colors.black54, fontSize: 13
      ),
      textAlign: TextAlign.left,
    );
    //--------------------------------------------------------------------------------------------------------
    final buttonLogin = Stack(
      children:<Widget> [
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Đăng nhập",
                  style: TextStyle(
                      color: Colors.red, fontSize: 15,fontWeight: FontWeight.bold
                  ),
                ),
                Icon(Icons.arrow_forward_ios_outlined, color: Colors.red,size: 16,)
              ]
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 280,
          bottom: 0,
          child: FlatButton(
              onPressed: (){
                Navigator.pop(context);
              }
          ),
        )
      ],
    );

    return Scaffold(
      body: GestureDetector(
        onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
        },
        child:Padding(
          padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 0),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                back,
                SizedBox(height: 80),
                TextTitle("Đến với SayLove"),
                SizedBox(height: 10.0),
                TextDescription("Thông tin cần thiết cho tài khoản của bạn"),
                SizedBox(height: 40.0),
                email,
                SizedBox(height: 10.0),
                password,
                SizedBox(height: 10.0),
                confirmPassword,
                SizedBox(height: 60.0),
                register,
                SizedBox(height: 30.0),
                text3,
                SizedBox(height: 10.0),
                buttonLogin
          ],
        ),
      ),
      ),
    );
  }
}