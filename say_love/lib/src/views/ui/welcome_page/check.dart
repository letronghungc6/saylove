import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:say_love/src/views/ui/homepage/homepage.dart';
import 'package:say_love/src/views/ui/login/login_screen.dart';
import 'package:say_love/src/views/ui/profile/birthday.dart';
import 'package:say_love/src/views/ui/profile/gender.dart';
import 'package:say_love/src/views/ui/profile/height_weight.dart';
import 'package:say_love/src/views/ui/profile/hobbies.dart';
import 'package:say_love/src/views/ui/profile/name.dart';
import 'package:say_love/src/views/ui/profile/schools/schools_background.dart';
import 'package:say_love/src/views/ui/profile/void/void_background.dart';
import 'package:say_love/src/views/ui/socket_io_chat/socket_utils.dart';
import 'package:say_love/src/views/ui/welcome_page/welcome_page_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CheckRunningApp(),
      routes: <String, WidgetBuilder> {
        '/login': (BuildContext context) => new LoginScreen(),
      },
    );
  }
}
//@required this.textEmail, this.textPassword
class CheckRunningApp extends StatefulWidget {
//  MyAppOne({});
  @override
  _CheckRunningApp createState() => _CheckRunningApp();
}

class _CheckRunningApp extends State<CheckRunningApp> {
  int count;
  String token;
  String id;
  String firstName;
  int birthday;
  String gender;
  String height;
  String hobby;
  String school;
  String media;
  SocketUtils socketUtils;
  Socket socket;

  @override
  void initState() {
    super.initState();
    checkRunning();

  }

//  void connectSocket(String token) async {
//    if(socketUtils == null){
//      socketUtils = SocketUtils();
//    }
//    socket = socketUtils.socket;
//    await socketUtils.initSocket();
//    socketUtils.setConnectListener(onConnect, token, socket);
//  }
//
//  onConnect(data) {
//    print("Connected $data");
//  }



  Future<Null> checkRunning() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    int i = prefs.getInt('number_check') ?? 0;
    this.setState(() {
      count = i;
      token = prefs2.getString("token") ?? null;
      id = prefs2.getString("id") ?? null;
      firstName = prefs2.getString("first_name") ?? null;
      birthday = prefs2.getInt("birthday") ?? null;
      gender = prefs2.getString("gender") ?? null;
      height = prefs2.getString("height") ?? null;
      hobby = prefs2.getString("hobby") ?? null;
      school = prefs2.getString("school") ?? null;
      media = prefs2.getString("media") ?? null;
    });
//    print(count);
//    print(token);
//    print(id);
//    print("$firstName -- $birthday -- $gender -- $height -- $hobby--$school--$media");
  }

   Future<Null> postAPI() async{
    String url = "http://45.76.151.147:8091/api/auth/refresh_token";
    Map<String, String> headers = {
      "Content-type": "application/json"
    };
    Map<String, String> jsonPost = {
      "token": "$token"
    };
    try{
      Response r = await post(
          url, headers: headers, body: jsonEncode(jsonPost));
      dynamic jsonBody = json.decode( utf8.decode(r.bodyBytes));
      print(utf8.decode(r.bodyBytes));
      if(jsonBody["status_code"] == 200){
        String accessToken = jsonBody["data"]["access_token"];
        bool checkBack = true;
        print(accessToken);
        if(firstName == null)
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => Name(token: accessToken, id: id)));
        else if(birthday == null)
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context)=> Birthday(token:accessToken,id:id, checkBack:checkBack)));
        else if(gender == null)
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => Gender(token: accessToken, id: id, checkBack: checkBack)));
        else if(height == null)
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => HeightWeight(token: accessToken, id: id, checkBack: checkBack)));
        else if(hobby == null) {
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) =>
                  Hobbies(token: accessToken, id: id, checkBack: checkBack)));
          print("Trang hobby");
        }
        else if(school == null)
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => School(token: accessToken, id: id, checkBack: checkBack)));
        else if(media == null)
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => Void(token: accessToken, id: id, checkBack: checkBack)));
        /////////////////////////////////////////////////////////////////////////////////////////////////////////else if trương , void
        else {
//          connectSocket(accessToken);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(token: accessToken, id: id)));
        }
      }
      else Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
    catch(e){
      print("Lỗi");
    }
  }


  getBody() {
    if (count == 0) {
      return WelcomePage();
    }
    else if(count == 1){
      postAPI();
    }
    return Scaffold(
        body: Container(
        ),
      );
  }
  @override
  Widget build(BuildContext context) {
      return getBody();
  }
}
