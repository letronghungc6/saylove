import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:say_love/src/views/ui/login/login_screen.dart';
import 'package:say_love/src/views/ui/setting_profile/image_record/edit_record/select_record_page.dart';
import 'package:say_love/src/views/ui/setting_profile/setting_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageRecord extends StatefulWidget{

  @override
  _ImageRecord createState() => _ImageRecord();
  String media;
  String token;
  String id;
  String gender;
  String textRecord;
  ImageRecord({@required this.media, this.token, this.id, this.textRecord, this.gender});
}

class _ImageRecord extends State<ImageRecord>{
  bool isPlay = false;
  AudioPlayer audioPlayerRecord = AudioPlayer();

  @override
  Widget build(BuildContext context) {

    final back = Container(
      height: 50,
      width: 50,
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        child: Icon(Icons.arrow_back_ios,size: 24,),
        onTap: (){
          audioPlayerRecord.stop();
          setState(() {
            isPlay = false;
          });
//          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (
                    BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return SettingProfile(token: widget.token, id: widget.id);
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
    );


    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 20, left: 30, right: 20),
        child: ListView(
          children: [
            back,
            SizedBox(height: 20,),
            Text("Ảnh", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),),
            SizedBox(height: 40,),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.45,
                width: MediaQuery.of(context).size.width *0.7 ,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
//                      border: Border.all(color: Colors.blue, width: 1),
                    image: DecorationImage(
                      image: widget.gender == "0" ?
                      AssetImage("assets/images/background_male.jpg"):
                      AssetImage("assets/images/background_female.jpg"),
                      fit: BoxFit.cover,
                    )
                ),
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width *0.7,
                decoration: BoxDecoration(
                  color: Color(0xFfFF3377),
                  borderRadius: BorderRadius.circular(5)
                ),
                child: FlatButton(
                  child: Text("Chỉnh sửa", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                  onPressed: (){
                    audioPlayerRecord.stop();
                    setState(() {
                      isPlay = false;
                    });
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content:
                            Text(
                              "Chức năng này đang phát triển.",
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
                  },
                ),
              ),
            ),
            SizedBox(height: 40,),
            Text("Ghi âm", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),),
            SizedBox(height: 40,),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7 ,
                height: 100,
                decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0,4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white
                ),
                child: Row(
                  children: [
                    SizedBox(width: 20,),
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFE5EE),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: IconButton(
                        icon: isPlay ? Icon(Icons.stop, color: Color(0xFFFF3377),): Icon(Icons.play_arrow_rounded, color: Color(0xFFFF3377),),
                        iconSize: 64,
                        onPressed: () async{
                          if(isPlay){
                            audioPlayerRecord.stop();
                            setState(() {
                              isPlay = false;
                            });
                          }
                          else {
                            int result = await audioPlayerRecord.play(
                                widget.media, isLocal: true);
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
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7 - 120,
                      child: Center(
                        child: Text(widget.textRecord == null ? "Lời yêu" : widget.textRecord, style: TextStyle(fontSize: 16),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40,),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width *0.7,
                decoration: BoxDecoration(
                    color: Color(0xFfFF3377),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: FlatButton(
                  child: Text("Chỉnh sửa", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                  onPressed: (){
                    audioPlayerRecord.stop();
                    setState(() {
                      isPlay = false;
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SelectRecord(token: widget.token, id: widget.id)));
                  },
                ),
              ),
            ),
            SizedBox(height: 40,),
          ],
        ),
      ),
    );
  }

}