import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:say_love/src/models/profile.dart';
import 'package:say_love/src/views/ui/homepage/homepage.dart';
import 'package:say_love/src/views/ui/login/forgot_password_screen.dart';
import 'package:say_love/src/views/ui/login/register_screen.dart';
import 'package:say_love/src/views/ui/profile/birthday.dart';
import 'package:say_love/src/views/ui/profile/gender.dart';
import 'package:say_love/src/views/ui/profile/height_weight.dart';
import 'package:say_love/src/views/ui/profile/hobbies.dart';
import 'package:say_love/src/views/ui/profile/name.dart';
import 'package:say_love/src/views/ui/profile/schools/schools_background.dart';
import 'package:say_love/src/views/ui/profile/void/void_background.dart';
import 'package:say_love/src/views/ui/socket_io_chat/User.dart';
import 'package:say_love/src/views/ui/socket_io_chat/socket_utils.dart';
import 'package:say_love/src/views/utils/text_description.dart';
import 'package:say_love/src/views/utils/text_title.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({@required this.textEmail});
  String textEmail = "";
  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  bool check=true;
//  final _formKey = GlobalKey<FormState>();
  Color borderColorEmail = Colors.black26;
  Color borderColorPassword = Colors.black26;
  TextEditingController controllerTextEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  SocketUtils socketUtils;
  Socket socket;
  @override
  void initState(){
    super.initState();
    controllerTextEmail.text = widget.textEmail;
//    G.initDummyUsers();
  }
  @override
  void dispose(){
    controllerPassword.text = "";
    super.dispose();
  }

//  void connectSocket(String token) async {
//    if(socketUtils == null){
//      socketUtils = SocketUtils();
//    }
//    socket = socketUtils.socket;
//    await socketUtils.initSocket();
//    socketUtils.setConnectListener(onConnect, token, socket);
//
//  }
//
//  onConnect(data) {
//    print("Connected $data");
//  }



  //Gọi api login
  postAPI() async {
    String textEmail = controllerTextEmail.text;
    String textPassword = controllerPassword.text;
    String url = "http://45.76.151.147:8091/api/auth/login";
    Map<String, String> headers = {
      "Content-type": "application/json"
    };
    Map<String, String> jsonPost = {
      "username": "$textEmail",
      "password": "$textPassword"
    };
    try {
      Response r = await post(
          url, headers: headers, body: jsonEncode(jsonPost));
      dynamic jsonBody = json.decode( utf8.decode(r.bodyBytes));
//      Profile profileUser = new Profile.fromJson(jsonBody["data"]["user_profile"]);
//      print("${profileUser.firstName}--${profileUser.birthday}---${profileUser.gender}---${profileUser.height}---${profileUser.hobbies}");
      print(utf8.decode(r.bodyBytes));
      String mess = jsonBody["status_message"];
      if (jsonBody["status_code"] == 200) {
        Navigator.of(context).pop();
        String dataToken = jsonBody["data"]["token"];
        String refreshToken = jsonBody["data"]["refresh_token"];
        String id = jsonBody["data"]["user_profile"]["id"];
        SharedPreferences prefs2 = await SharedPreferences.getInstance();
        prefs2.setString("token", refreshToken);
        prefs2.setString("id", id);
        prefs2.setString("email", textEmail);
        bool checkBack = true;
        Profile profileUser = new Profile.fromJson(jsonBody["data"]["user_profile"]);
        prefs2.setString("first_name", profileUser.firstName);
        prefs2.setString("last_name", profileUser.lastName);
        prefs2.setInt("birthday", profileUser.birthday);
        prefs2.setString("gender", profileUser.gender);
        prefs2.setString("height", profileUser.height.toString());
        prefs2.setString("weight", profileUser.weight.toString());
        prefs2.setString("hobby", profileUser.hobbies);
        prefs2.setInt("schoolID", profileUser.schoolID);
        prefs2.setString("school", profileUser.school);
        prefs2.setString("media", profileUser.media);
///

//        User me = User(id: "$id",firstName: "${profileUser.firstName}", lastName: "${profileUser.lastName}");
//        print("$id --- ${profileUser.firstName} --- ${profileUser.lastName}");
//        G.loggedInUser = me;
        ///Gọi socket lấy list danh sách kết bạn add dô dummyUser
///
//        print(dataToken);
//        print(id);
        print("${profileUser.firstName}--${profileUser.birthday}---${profileUser.gender}---${profileUser.height}---${profileUser.hobbies}");
        if(profileUser.firstName == null) {
          prefs2.setString("first_name", null);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => Name(token: dataToken, id: id)));
        }
        else if(profileUser.birthday==null){
          prefs2.setInt("birthday", null);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context)=> Birthday(token:dataToken,id:id, checkBack:checkBack)));
        }
        else if(profileUser.gender == null) {
          prefs2.setString("gender", null);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) =>
                  Gender(token: dataToken, id: id, checkBack: checkBack)));
        }
        else if(profileUser.height == null) {
          prefs2.setString("height", null);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) =>
                  HeightWeight(
                      token: dataToken, id: id, checkBack: checkBack)));
        }
        else if(profileUser.hobbies == null){
          prefs2.setString("hobby", null);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) =>
                  Hobbies(token: dataToken, id: id, checkBack: checkBack)));
        }
        else if(profileUser.school == null){
          prefs2.setString("school", null);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) =>
                  School(token: dataToken, id: id, checkBack: checkBack)));
        }
        else if(profileUser.media == null){
          prefs2.setString("media", null);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context)=> Void(token: dataToken, id:id, checkBack: checkBack,)));
        }
        /////////////////////////////////////////////////////////////////////////////////////////////else if trường, void
        else{
//          connectSocket(dataToken);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => HomePage(token: dataToken, id:id)));
         }
      }
      else if(jsonBody["status_code"] == 401 ){//&& mess == "User Not Found with username: "+textEmail
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content:
                Text(
                  "Tài khoản không tồn tại.",
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
      //
      else if(jsonBody["status_code"] == 400 && mess == "Tên tài khoản hoặc mật khẩu sai."){
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
      print("Lỗi không xác định");
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

    AlertDialog alertPasswordForm = AlertDialog(
      content: Text(
        "Mật khẩu phải có chữ hoa, chữ thường và số",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15
        ),
      ),
    );

    AlertDialog alertPassword = AlertDialog(
      content: Text(
        "Bạn chưa nhập mật khẩu",
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

    //--------------------------------------------------------------------------------------------------------
    final email = Container(
      height: 50,
      width: MediaQuery.of(context).size.width*0.9,
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
//            width: 300,
          width: MediaQuery.of(context).size.width*0.7,
            child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                autofocus: false,
                controller: controllerTextEmail,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
                    border: InputBorder.none,
                    hintText: "Địa chỉ email",
                    hintStyle: TextStyle(color: Colors.black26),
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
                obscureText: check,
                controller: controllerPassword,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
                    border: InputBorder.none,
                    hintText: "Mật khẩu",
                  hintStyle: TextStyle(color: Colors.black26)
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
                  check = !check;
                });
              },
            ),
          ),
        ],
      ),
    );
//--------------------------------------------------------------------------------------------------------
    final forgot = Container(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordScreen()));
        },
        child: Text("Quên mật khẩu?",
          style: TextStyle(
              color: Colors.red, fontSize: 15
          ),
        ),
      ),
//      alignment: Alignment.centerRight,
//      child: FlatButton(
//        child: Text("Quên mật khẩu?",
//          style: TextStyle(
//              color: Colors.red, fontSize: 15
//          ),
//          textAlign: TextAlign.right,
//        ),
//        onPressed: () {},
//      ),
    );
    //--------------------------------------------------------------------------------------------------------
    final login = SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: RaisedButton(
        color: Colors.red,
        child: Text(
          "Đăng nhập tài khoản",
          style: TextStyle(
              color: Colors.white, fontSize: 15
          ),
          textAlign: TextAlign.center,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: () {
          if(borderColorEmail == Colors.black26) {
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
            else if(borderColorPassword == Colors.black26){
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
              }
            }
          }
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
                }
              }
            }
          }
          if(borderColorEmail == borderColorPassword && borderColorPassword == Colors.black26){
            showLoaderDialog(context);
            postAPI();
          }
        },
      ),
    );
    //--------------------------------------------------------------------------------------------------------
    final text3 = Container(
//      alignment: Alignment.centerLeft,
      child :Text(
      "Bạn chưa có tài khoản",
      style: TextStyle(
          color: Colors.black54, fontSize: 13
      ),
      )
    );

    //--------------------------------------------------------------------------------------------------------
    final buttonRegister = Center(
      child: GestureDetector(
        child: Text(
          "Đăng ký", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return RegisterScreen();
          })
          );
        },
      ),


//      children: <Widget>[
//        Align(
//          alignment: Alignment.centerLeft,
//          child: Row(
//            crossAxisAlignment: CrossAxisAlignment.center,
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: [
//            Text("Đăng kí",
//            style: TextStyle(
//              color: Colors.red,
//              fontSize: 15,
//              fontWeight: FontWeight.bold,
//            ),
//          ),
//            Icon(Icons.arrow_forward_ios_outlined, color: Colors.red,size: 16,)
//            ]
//          ),
//        ),
//        Positioned(
//          top: 0,
//          left: 0,
//          right: 290,
//          bottom: 0,
//          child: FlatButton(
//              onPressed: () {
//              Navigator.push(context, MaterialPageRoute(builder: (context){
//                    return RegisterScreen();
//              })
//              );
//              }
//          ),
//        )
//      ],
    );



    return Scaffold(
      body: Container(
        color: Colors.white,
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Padding(
            padding: EdgeInsets.only(left: 20, top: 0, right: 0, bottom: 0),
            child: ListView(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/background_login.png"),
                          fit: BoxFit.cover
                      ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 40.0),
                      email,
                      SizedBox(height: 10.0),
                      password,
                      SizedBox(height: 15.0),
                      forgot,
                      SizedBox(height: 60.0),
                      Center(
                        child: login,
                      ),
                      SizedBox(height: 30.0),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: Colors.black12)
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Text("Hoặc", style: TextStyle(color: Colors.red),),
                            ),
                            Container(
                              width: 80,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: Colors.black12)
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      buttonRegister
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )



//      body: GestureDetector(
//        onTap: (){
//          FocusScope.of(context).requestFocus(new FocusNode());
//        },
//        child:Padding(
//          padding: EdgeInsets.only(left: 20, top: 150, right: 20, bottom: 0),
//            child: ListView(
//              shrinkWrap: false,
//              children: <Widget>[
//                TextTitle("Đi đến với SayLove"),
//                SizedBox(height: 10.0),
//                TextDescription("Vui lòng đăng nhập để tiếp tục với ứng dụng"),
//                SizedBox(height: 40.0),
//                email,
//                SizedBox(height: 10.0),
//                password,
//                SizedBox(height: 15.0),
//                forgot,
//                SizedBox(height: 60.0),
//                login,
//                SizedBox(height: 30.0),
//                text3,
//                SizedBox(height: 10.0),
//                buttonRegister
//              ],
//            ),
//        ),
//      ),
    );
  }
}


