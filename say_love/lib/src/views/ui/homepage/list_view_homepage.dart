
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:say_love/src/models/slide_homepage.dart';
import 'package:say_love/src/utils/cancel_icons.dart';
import 'package:say_love/src/utils/heart_icons.dart';
import 'dart:ui';

import 'package:say_love/src/views/ui/homepage/homepage_detail.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SlideItemHomePage extends StatefulWidget {
  final int index;
  CardController controllerCard = CardController();
  String check;
  AudioPlayer audioPlayerRecord1 = AudioPlayer();
  bool isPlay1 = false;
  List<SlideHomePage> listSlideHomePage = new List();
  List<List> listHobbyHomepage = new List();
  SlideItemHomePage( this.index, this.controllerCard, this.check, this.isPlay1, this.audioPlayerRecord1, this.listSlideHomePage, this.listHobbyHomepage);

  _SlideItemHomePage createState() => _SlideItemHomePage();
}

class _SlideItemHomePage extends State<SlideItemHomePage> {
  String textLikeNope=  "";
  String dataBackFromDetail = "";
  String imageMale = "https://saylove-dev-123.s3-ap-southeast-1.amazonaws.com/storage/img/Nam.jpg";
  String imageFemale = "https://saylove-dev-123.s3-ap-southeast-1.amazonaws.com/storage/img/nu.jpg";



  like() async{
    setState(() {
      textLikeNope = "LIKE";
    });
    await Future.delayed(Duration(milliseconds: 200));
    widget.controllerCard.triggerRight();
    await Future.delayed(Duration(milliseconds: 800));
    setState(() {
      textLikeNope = "";
    });
  }
  nope()async{
    setState(() {
      textLikeNope = "NOPE";
    });
    await Future.delayed(Duration(milliseconds: 200));
    widget.controllerCard.triggerLeft();
    await Future.delayed(Duration(milliseconds: 800));
    setState(() {
      textLikeNope = "";
    });
  }



  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height ,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
        ),
          child: Stack(
          children: [
            ////////////////////////////////////////////////////////////////////////Ảnh nền
            Positioned(
              child: Container(
                width: MediaQuery.of(context).size.width ,
                height: MediaQuery.of(context).size.height ,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(widget.listSlideHomePage[widget.index].gender == "0" ? "assets/images/background_male.jpg": "assets/images/background_female.jpg" ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
            //////////////////////////////////////////////////////////////////////////////////////Khung detail
            Positioned(
              top: MediaQuery.of(context).size.height *0.53,
              left: MediaQuery.of(context).size.width* 0.015,
              ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////Show detail
              child: GestureDetector(
                onTap: () async {
                  widget.audioPlayerRecord1.stop();
                  final result = await Navigator.push(context,
                      PageRouteBuilder(
                        pageBuilder: (
                            BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return HomePageDetail(widget.index, widget.listSlideHomePage, widget.listHobbyHomepage);
                        },
                        transitionDuration: Duration(milliseconds: 10),
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
                  setState(() {
                    dataBackFromDetail = result;
                  });
                  if(dataBackFromDetail == "LIKE"){
                    like();
                  }
                  else if(dataBackFromDetail == "NOPE"){
                    nope();
                  }
                  setState(() {
                    widget.isPlay1 = false;
                  });
                },
                child: Container(
                  height: MediaQuery.of(context).size.height *0.36,
                  width: MediaQuery.of(context).size.width* 0.9,
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(30),
//                    image: DecorationImage(
//                      image: AssetImage("assets/images/ic_bottom.png"),
//                      fit: BoxFit.fill,
//                      colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.1), BlendMode.srcATop ),
//                    ),
//                  ),
                  child: Stack(
                    children: [
                      Image(
                        height: 500,
                        width: 400,
                        image: AssetImage("assets/images/ic_bottom.png"),
                        fit: BoxFit.fill,
                        color: Colors.white.withOpacity(0.95),
                      ),
                      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Tên
                      Positioned(
                        top: 80,
                        left: 10,
                        child: Container(
                          height: 110,
                          width: 380,
                          decoration: BoxDecoration(//
  //                            border: Border.all(style: BorderStyle.solid, width: 2,color: Colors.blue),
  //                            color: Colors.white
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 10,),
                                  Text("${widget.listSlideHomePage[widget.index].firstName} ${widget.listSlideHomePage[widget.index].lastName}", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF16123D)), ),////////////////////////////////////////////////////////////////////////////
                                  SizedBox(width: 10,),
                                  Text("${DateTime.now().year - DateTime.fromMillisecondsSinceEpoch(widget.listSlideHomePage[widget.index].birthday).year}", style: TextStyle(fontSize: 22,color:Color(0xFF4E4B6F)), overflow: TextOverflow.ellipsis,),/////////////////////////////////////////////////////////////////////////////////////////////////////////
                                ],
                              ),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  SizedBox(width: 10,),
                                  Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF15D374),//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Text("Đang hoạt động", style: TextStyle(fontSize: 13, color:Color(0xFF4E4B6F)),),///////////////////////////////////////////////////////////////////////
                                ],
                              ),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  SizedBox(width: 0,),
                                  Icon(Icons.school_outlined),
                                  SizedBox(width: 10,),
                                  Text("${widget.listSlideHomePage[widget.index].universityName}", style: TextStyle(fontSize: 13, color:Color(0xFF4E4B6F) ),),///////////////////////////////////////////////////////////////////////
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Sở thích
                      Positioned(
                        top: 190,
                        left: 10,
                        child: Container(
                          height: 80,
                          width: 370,
                          decoration: BoxDecoration(//
  //                          border: Border.all(style: BorderStyle.solid, width: 2,color: Colors.blue),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(" Sở thích", style: TextStyle(fontSize: 13, color: Color(0xFF16123D), fontWeight: FontWeight.bold ),),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(3),
                                    height: 40,
                                    decoration: BoxDecoration(//
//                                        boxShadow: <BoxShadow>[
//                                          BoxShadow(
//                                            color: Colors.grey.withOpacity(0.3),
//                                            spreadRadius: 1,
//                                            blurRadius: 5,
//                                            offset: Offset(0,4),
//                                          ),
//                                        ],
                                        borderRadius: BorderRadius.horizontal(right: Radius.circular(20), left: Radius.circular(20)),
                                        color: Color(0xFFFFE9E6)
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                                      child: Text(widget.listHobbyHomepage[widget.index][0], style:TextStyle(color: Color(0xFFFF6F59))),///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    margin: EdgeInsets.all(3),
                                    decoration: BoxDecoration(//
//                                        boxShadow: <BoxShadow>[
//                                          BoxShadow(
//                                            color: Colors.grey.withOpacity(0.3),
//                                            spreadRadius: 1,
//                                            blurRadius: 5,
//                                            offset: Offset(0,4),
//                                          ),
//                                        ],
                                        borderRadius: BorderRadius.horizontal(right: Radius.circular(20), left: Radius.circular(20)),
                                        color: Color(0xFFE5F7FF)
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                                      child: Text(widget.listHobbyHomepage[widget.index][1], style:TextStyle(color: Color(0xFF33C0FF))),///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    margin: EdgeInsets.all(3),
                                    decoration: BoxDecoration(//
//                                        boxShadow: <BoxShadow>[
//                                          BoxShadow(
//                                            color: Colors.grey.withOpacity(0.3),
//                                            spreadRadius: 1,
//                                            blurRadius: 5,
//                                            offset: Offset(0,4),
//                                          ),
//                                        ],
                                        borderRadius: BorderRadius.horizontal(right: Radius.circular(20), left: Radius.circular(20)),
                                        color: Color(0xFFFFF2E5)
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                                      child: Text(widget.listHobbyHomepage[widget.index][2], style:TextStyle(color: Color(0xFFFF9933)),),///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ////////////////////////////////////////////////////////////////////////Nút xoá
            Positioned(
              top: MediaQuery.of(context).size.height *0.5,
              left: MediaQuery.of(context).size.width *0.125,
              child: Container(
                height:40,
                width: 40,
                decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0,4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top:10,
                      left: 10,
                      child:  Image(
                        height: 20,
                        width: 20,
                        image: AssetImage("assets/images/cancel.png"),
                        fit: BoxFit.fill ,
                      ),
                    ),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: (){
                        widget.audioPlayerRecord1.stop();
                        setState(() {
                          widget.isPlay1=false;
                        });
                        nope();
                      },
                    ),
                  ],
                )
//                IconButton(icon: Icon(Close.cancel, color: Colors.red,), onPressed: () async {
//                   nope();
//                }),
              ),
            ),
            ////////////////////////////////////////////////////////////////////////////Nút tym
            Positioned(
              top: MediaQuery.of(context).size.height *0.5,
              right: MediaQuery.of(context).size.width *0.125,
              child: Container(
                height:40,
                width: 40,
                decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0,4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
//                  border: Border.all(color: Colors.black, width: 1)

                ),
                child: Stack(
                  children: [
                    Positioned(
                      top:7.5,
                        left: 7.5,
                        child:  Image(
                          height: 25,
                          width: 25,
                          image: AssetImage("assets/images/heart.png"),
                          fit: BoxFit.fill ,
                        ),
                    ),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: (){
                        widget.audioPlayerRecord1.stop();
                        setState(() {
                          widget.isPlay1=false;
                        });
                        like();
                      },
                    ),
                  ],
                )
//                IconButton(icon: Icon(Heart.heart_filled, color: Colors.red,), onPressed: () async {
//                  like();
//                }),
              ),
            ),
            ////////////////////////////////////////////////////////////////////////////Nút play
            Positioned(
              top: MediaQuery.of(context).size.height *0.493,
              right: MediaQuery.of(context).size.width*0.3525,
              child: Container(
                height:100,
                width: 100,
                decoration: BoxDecoration(//
                  border: Border.all(style: BorderStyle.solid, width: 3,color: Colors.white),
                    borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(//
                        borderRadius: BorderRadius.circular(45),
                        color: Colors.white
                    ),
                    child: IconButton(
                      icon: Icon(widget.isPlay1 ? Icons.stop : Icons.play_arrow_sharp, color: Color(0xFFFF6666), size: 60,),
                      onPressed: () async {
                        if(widget.isPlay1){
                          widget.audioPlayerRecord1.stop();
                          setState(() {
                            widget.isPlay1 = false;
                          });
                        }
                        else {
                          int result = await widget.audioPlayerRecord1.play(
                              widget.listSlideHomePage[widget.index].media);
                          print(result);
                          if (result == 1) {
                            setState(() {
                              widget.isPlay1 = true;
                            });
                          }

                          ///Phát xong thì chuyển icon
                          widget.audioPlayerRecord1.onPlayerCompletion.listen((_) {
                            setState(() {
                              widget.isPlay1 = false;
                            });
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            (widget.check == "LIKE" || textLikeNope == "LIKE")?
                Positioned(
                    top: 20,
                    left: 20,
                    child: Transform.rotate(
                      angle: -0.5,
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green, width: 2
                          )
                        ),
                        child: Center(
                          child: Text("LIKE", style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),),
                        ),
                      ),
                    )
                ): (widget.check == "NOPE" || textLikeNope == "NOPE") ?
            Positioned(
              top: 20,
              right: 20,
              child: Transform.rotate(
                angle: 0.5,
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.red, width: 2
                      )
                  ),
                  child: Center(
                    child: Text("NOPE", style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),),
                  ),
                ),
              )
            ): Container()
          ],
        ),
      )
    );
  }
}

Widget _hobbyBox(String text, int colorText, int colorBox){
  return Container(
    margin: EdgeInsets.all(3),
    height: 40,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20), left: Radius.circular(20)),
        color: Color(colorBox)
    ),
    child: Padding(
      padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
      child: Text(text, style: TextStyle(color: Color(colorText), fontSize: 11),),
    ),
  );
}


