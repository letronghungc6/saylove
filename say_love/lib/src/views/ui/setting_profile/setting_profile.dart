import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:say_love/src/views/ui/chat_page/list_chat_page.dart';
import 'package:say_love/src/views/ui/homepage/homepage.dart';
import 'package:say_love/src/views/ui/login/login_screen.dart';
import 'package:say_love/src/views/ui/setting_profile/edit_information/edit_information_page.dart';
import 'package:say_love/src/views/ui/setting_profile/image_record/image_record_page.dart';
import 'package:say_love/src/views/ui/setting_profile/information_logout/information_logout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SettingProfile extends StatefulWidget{
  SettingProfile({@required this.token, this.id});
  String token;
  String id;
  @override
  _SettingProfile createState() => _SettingProfile();

}

class _SettingProfile extends State<SettingProfile>{
  String firstName;
  String lastName;
  String gender;
  String media;
  bool isLoading;
  bool isPlay=false;
  AudioPlayer audioPlayerRecord = AudioPlayer();

  @override
  void initState(){
    isLoading = true;
    super.initState();
    getInformation();

  }
  Future<void>getInformation() async{
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
      firstName = prefs2.getString("first_name");
      lastName = prefs2.getString("last_name");
      gender = prefs2.getString("gender");
      media = prefs2.getString("media");
      setState(() {
        isLoading = false;
      });
      print(media);
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          (isLoading == false) ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width *0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
//                      border: Border.all(color: Colors.blue, width: 1),
                      image: DecorationImage(
                        image: gender == "0" ?
                        AssetImage("assets/images/background_male.jpg"):
                        AssetImage("assets/images/background_female.jpg"),
                        fit: BoxFit.cover,
                      )
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFFEDEDED), width: 2),
                    )
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFE5EE),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      icon: isPlay ? Icon(Icons.stop, color: Color(0xFFFF3377),): Icon(Icons.play_arrow_rounded, color: Color(0xFFFF3377),),
                      iconSize: 72,
                      onPressed: () async{
                        if(isPlay){
                          audioPlayerRecord.stop();
                          setState(() {
                            isPlay = false;
                          });
                        }
                        else {
                          int result = await audioPlayerRecord.play(
                              media, isLocal: true);
                          print(result);
                          if (result == 1) {
                            setState(() {
                              isPlay = true;
                            });
                          }

                          ///Phát xong thì chuyển icon
                          audioPlayerRecord.onPlayerCompletion.listen((_) {
                            setState(() {
                              isPlay = false;
                            });
                          });
                        }
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.only(left: 30),
                child: Column(
                  children: [
                    Text(firstName, style: TextStyle(color: Color(0xFF16123D),fontSize: 36, fontWeight: FontWeight.bold),),
                    Text(lastName, style: TextStyle(color: Color(0xFF94979F),fontSize: 36),),
                  ],
                )
              ),
              SizedBox(height: 40,),
              ///////////////////////////////////////////////////////Chỉnh sửa thông tin
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFFE5F7FF),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(Icons.emoji_people_sharp, color: Color(0xFF5985FF),size: 36,),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width *0.4,
                    child: Text("Chỉnh sửa thông tin", style:   TextStyle(color: Color(0xFF4E4B6F), fontSize: 17),),
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black26,),
                      iconSize: 24,
                      onPressed: (){
                        audioPlayerRecord.stop();
                        setState(() {
                          isPlay = false;
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>EditInformation(token: widget.token, id: widget.id)));

                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),
              ///////////////////////////////////////////////////////Ảnh/ Ghi âm
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFFE5F7FF),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(Icons.camera_alt, color: Color(0xFF5985FF),size: 36,),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width *0.4,
                    child: Text("Ảnh/Ghi âm", style:   TextStyle(color: Color(0xFF4E4B6F), fontSize: 17),),
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black26,),
                      iconSize: 24,
                      onPressed: (){
                        audioPlayerRecord.stop();
                        setState(() {
                          isPlay = false;
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageRecord(media : media, token: widget.token, id: widget.id, gender: gender, )));//socket: widget.socket

                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),
              ///////////////////////////////////////////////////////Cài đặt
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF2E5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(Icons.settings, color: Color(0xFFFF9933),size: 36,),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width *0.4,
                    child: Text("Cài đặt", style:   TextStyle(color: Color(0xFF4E4B6F), fontSize: 17),),
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black26,),
                      iconSize: 24,
                      onPressed: (){
                        audioPlayerRecord.stop();
                        setState(() {
                          isPlay = false;
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>InformationLogout()));
                      },
                    ),
                  )
                ],
              )
            ],
          ): Center(
            child: CircularProgressIndicator(),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height - 50,
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  color: Colors.white
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      height:40,
                      width: 40,
                      child: Stack(
                        children: [
                          Positioned(
                            top:6.5,
                            left: 6.5,
                            child:  Image(
                              height: 24,
                              width: 24,
                              image: AssetImage("assets/images/home.png"),
                              fit: BoxFit.fill ,
                              color: Colors.black,
                            ),
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: (){
                              audioPlayerRecord.stop();
                              setState(() {
                                isPlay = false;
                              });
                              Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (
                                        BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation) {
                                      return HomePage(token: widget.token, id: widget.id);
                                    },
                                    transitionDuration: Duration(milliseconds: 100),
                                    transitionsBuilder: (
                                        BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation,
                                        Widget child) {
                                      return Align(
                                        child: FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        ),
                                      );
                                    },
                                  )
                              );
                            },
                          ),
                        ],
                      )
                  ),
                  Container(
                      height:40,
                      width: 40,
                      child: Stack(
                        children: [
                          Positioned(
                            top:6.5,
                            left: 6.5,
                            child:  Image(
                              height: 24,
                              width: 24,
                              image: AssetImage("assets/images/chat.png"),
                              fit: BoxFit.fill ,
                              color: Colors.black,
                            ),
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: (){
                              audioPlayerRecord.stop();
                              setState(() {
                                isPlay = false;
                              });
                              Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (
                                        BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation) {
                                      return ListChatPage(token: widget.token, id: widget.id);
                                    },
                                    transitionDuration: Duration(milliseconds: 100),
                                    transitionsBuilder: (
                                        BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation,
                                        Widget child) {
                                      return Align(
                                        child: FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        ),
                                      );
                                    },
                                  )
                              );
                            },
                          ),
                        ],
                      )
                  ),
                  Container(
                      height:40,
                      width: 40,
                      child: Stack(
                        children: [
                          Positioned(
                            top:2,
                            left: 2,
                            child:  Image(
                              height: 36,
                              width: 36,
                              image: AssetImage("assets/images/user.png"),
                              fit: BoxFit.fill ,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}