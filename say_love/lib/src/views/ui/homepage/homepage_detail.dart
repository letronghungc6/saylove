import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:intl/intl.dart';
import 'package:say_love/src/models/slide_homepage.dart';
import 'package:socket_io_client/socket_io_client.dart';

class HomePageDetail extends StatefulWidget{
  final int index;
  List<SlideHomePage> listSlideHomePage = new List();
  List<String> listHobby = new List();
  List<List> listHobbyHomepage = new List();
  HomePageDetail( this.index, this.listSlideHomePage, this.listHobbyHomepage);

  _HomePageDetail createState() => _HomePageDetail();
}

class _HomePageDetail extends State<HomePageDetail>{
  bool isPlay2 = false;
  AudioPlayer audioPlayerRecord2 = AudioPlayer();
  String fileRecord ="https://saylove-dev-123.s3.ap-southeast-1.amazonaws.com/storage/audio/cb3f9abc-5df1-4117-b0fa-d47418c14c2d_2021-05-05T00:01:28.063.m4a";
  String dataBackFromDetail="";
  List<Color> colorText = [Color(0xFFFF6F59), Color(0xFF33C0FF), Color(0xFFFF9933), Color(0xFF5985FF), Color(0xFF12B2B2), Color(0xFF33C0FF)];
  List<Color> colorBox= [Color(0xFFFFE9E6), Color(0xFFE5F7FF), Color(0xFFFFF2E5), Color(0xFFE5ECFF), Color(0xFFE0FFFF), Color(0xFFFFE9E6)];


//  like() async{
//    setState(() {
//      check = "LIKE";
//    });
//    Navigator.push(context, MaterialPageRoute(
//        builder: (context)=> HomePageDetail(widget.index, widget.controllerCard)));
//    widget.controllerCard.triggerRight();
//    await Future.delayed(Duration(milliseconds: 800));
//    setState(() {
//      check = "";
//    });
//  }
//  nope()async{
//    setState(() {
//      check = "NOPE";
//    });
//    widget.controllerCard.triggerLeft();
//    await Future.delayed(Duration(milliseconds: 800));
//    setState(() {
//      check = "";
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Positioned(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.94,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(widget.listSlideHomePage[widget.index].gender == "0" ? "assets/images/background_male.jpg": "assets/images/background_female.jpg" ),
                    fit: BoxFit.fill,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.3)),
                  ),
                ),
              ),
            ),
            ///////////////////////////////////////////////////Nút thoát detail
            Positioned(
              top: 40,
              right: 20,
              child: Container(
                  height: 60,
                  width: 60,
                  child: Stack(
                    children: [
                      Positioned(
                        top:17.5,
                        left: 17.5,
                        child:  Image(
                          height: 25,
                          width: 25,
                          image: AssetImage("assets/images/cancel.png"),
                          fit: BoxFit.fill ,
                          color: Colors.black,
                        ),
                      ),
                      FlatButton(
                        height:60,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onPressed: (){
                          Navigator.pop(context);
                          audioPlayerRecord2.stop();
                          isPlay2 =false;
                        },
                      ),
                    ],
                  )
              ),
            ),
            //////////////////////////////////////Ảnh khung detail
            Positioned(
              top: MediaQuery.of(context).size.height*0.29,
              left: MediaQuery.of(context).size.width-(MediaQuery.of(context).size.width-20),
              child: Container(
                height: MediaQuery.of(context).size.height *0.6,
                width: MediaQuery.of(context).size.width - 40,
//                                    decoration: BoxDecoration(
//                                      borderRadius: BorderRadius.circular(10),
//                                      image: DecorationImage(
//                                        image: AssetImage("assets/images/ic.png"),
//                                        fit: BoxFit.fill,
//                                      ),
//                                    ),
                child:Stack(
                    children: [
                      Image(
                        height: MediaQuery.of(context).size.height *0.6,
                        width: MediaQuery.of(context).size.width -40,
                        image: AssetImage("assets/images/ic.png"),
                        fit: BoxFit.fill,
                        color: Colors.white.withOpacity(0.95),
                      ),
                      /////////////////////////////////////////////////////////////////Thành phần trong khung detail
                      ListView(
                        children: [
                          ////////////////////////////////////////////////////////////////////////Tên detail
                          Container(
                            height : 60,
                            width : 300,
                            padding: EdgeInsets.only(top: 5, left: 20, right: 20),
//                                                  decoration: BoxDecoration(
//                                                      border: Border.all(color: Colors.black, width: 1)
//                                                  ),
                            child: Row(
                              children: [
                                Text("${widget.listSlideHomePage[widget.index].firstName} ${widget.listSlideHomePage[widget.index].lastName}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF16123D)), ),
                                SizedBox(width: 5,),
                                Container(
                                  height: 16,
                                  width: 16,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF15D374),//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ////////////////////////////////////////////////////////////////////////Thông tin detail
                          Container(
                            height: 120,
                            width: 300,
                            padding: EdgeInsets.only( left: 20, right: 20),
//                                                decoration: BoxDecoration(
//                                                    border: Border.all(color: Colors.black, width: 1)
//                                                ),
                            child: Stack(
                              children: [
                                Positioned(
                                  child: Container(
                                    height: 30,
                                    width:100,
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text("Thông tin", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF16123D)),),
//                                                        decoration: BoxDecoration(
//                                                            border: Border.all(color: Colors.blue, width: 1)
//                                                        ),
                                  ),
                                ),
                                Positioned(
                                  top: 30,
                                  child: Container(
                                    height: 90,
                                    width: 150,
//                                                        decoration: BoxDecoration(
//                                                            border: Border.all(color: Colors.blue, width: 1)
//                                                        ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${DateTime.now().year - DateTime.fromMillisecondsSinceEpoch(widget.listSlideHomePage[widget.index].birthday).year} Tuổi", style: TextStyle(fontSize: 11, color:Color(0xFF4E4B6F)),),
                                        Text((widget.listSlideHomePage[widget.index].gender == "0") ? "Con Trai" : "Con Gái", style: TextStyle(fontSize: 11, color:Color(0xFF4E4B6F)),),
                                        Text("${widget.listSlideHomePage[widget.index].height}cm", style: TextStyle(fontSize: 11, color:Color(0xFF4E4B6F)),),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 30,
                                  left: 150,
                                  child: Container(
                                    height: 90,
                                    width: 150,
//                                                        decoration: BoxDecoration(
//                                                            border: Border.all(color: Colors.blue, width: 1)
//                                                        ),     String birthday = DateFormat('yyyy-MM-dd').format(dateTime);
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(widget.listSlideHomePage[widget.index].birthday)).toString()}", style: TextStyle(fontSize: 11, color:Color(0xFF4E4B6F),),),
                                        Text("${widget.listSlideHomePage[widget.index].weight}kg", style: TextStyle(fontSize: 11, color:Color(0xFF4E4B6F)),),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ////////////////////////////////////////////////////////////////////////////////////Khung vị trí học vấn detail
                          Container(
                            height: 90,
                            width: 300,
                            padding: EdgeInsets.only( left: 20, right: 20),
//                                                decoration: BoxDecoration(
//                                                    border: Border.all(color: Colors.black, width: 1)
//                                                ),
                            child: Stack(
                              children: [
                                Positioned(
                                  child: Container(
                                    height: 30,
                                    width:200,
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text("Vị trí và học vấn", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF16123D)),),
//                                                        decoration: BoxDecoration(
//                                                            border: Border.all(color: Colors.blue, width: 1)
//                                                        ),
                                  ),
                                ),
                                Positioned(
                                  top: 30,
                                  child: Container(
                                    height: 60,
                                    width: 150,
//                                                        decoration: BoxDecoration(
//                                                            border: Border.all(color: Colors.blue, width: 1)
//                                                        ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Đà Nẵng", style: TextStyle(fontSize: 11, color:Color(0xFF4E4B6F)),),
                                        Text("${(widget.listSlideHomePage[widget.index].location).substring(0,4)} km", style: TextStyle(fontSize: 11, color:Color(0xFF4E4B6F)),),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 40,
                                  left: 150,
                                  child: Container(
                                    height: 120,
                                    width: 150,
//                                                        decoration: BoxDecoration(
//                                                            border: Border.all(color: Colors.blue, width: 1)
//                                                        ),
                                    child: Column(
//                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
//                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${widget.listSlideHomePage[widget.index].universityName}", style: TextStyle(fontSize: 11, color:Color(0xFF4E4B6F),),overflow: TextOverflow.clip,),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //////////////////////////////////////////////////////////////////////////Khung sở thích detail
                          Container(
                            height: 200,
                            width: 400,
                            padding: EdgeInsets.only( left: 20, right: 20),
//                                                decoration: BoxDecoration(
//                                                    border: Border.all(color: Colors.black, width: 1)
//                                                ),
                            child: Stack(
                              children: [
                                Positioned(
                                  child: Container(
                                    height: 30,
                                    width:200,
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text("Sở thích", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF16123D)),),
//                                                        decoration: BoxDecoration(
//                                                            border: Border.all(color: Colors.blue, width: 1)
//                                                        ),
                                  ),
                                ),
                                Positioned(
                                  top: 40,
                                  child: Container(
                                    height: 200,
                                    width: 350,
//                                                        decoration: BoxDecoration(
//                                                            color: Colors.red
//                                                        ),
                                    child: Wrap(
                                      spacing: 5,
                                      runSpacing: 5,
                                      children: <Widget>[
                                        for(int i=0; i<widget.listHobbyHomepage[widget.index].length; i++)
                                          _hobbyBox(widget.listHobbyHomepage[widget.index][i], colorText[i], colorBox[i])
//
//                                        _hobbyBox("Dance", 0xFFFF6F59, 0xFFFFE9E6),
//                                        _hobbyBox("Design", 0xFF33C0FF, 0xFFE5F7FF),
//                                        _hobbyBox("Photography", 0xFFFF9933, 0xFFFFF2E5),
//                                        _hobbyBox("Photography", 0xFF5985FF, 0xFFE5ECFF),
//                                        _hobbyBox("Desgin", 0xFF12B2B2, 0xFFE0FFFF)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]
                ),
              ),
            ),
            /////////////////////////////////////Khung Bottom detail
            Positioned(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height *0.9,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height *0.1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          color: Colors.white
                      ),
                    ),
                  ],
                )
            ),
            ////////////////////////////////////////////////Nút Xoá detail
            Positioned(
              bottom: MediaQuery.of(context).size.height *0.08,
              left: MediaQuery.of(context).size.width *0.25,
              child: Container(
                  height:60,
                  width: 60,
                  decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0,4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top:17.5,
                        left: 17.5,
                        child:  Image(
                          height: 25,
                          width: 25,
                          image: AssetImage("assets/images/cancel.png"),
                          fit: BoxFit.fill ,
                        ),
                      ),
                      FlatButton(
                        height:60,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onPressed: (){
                          audioPlayerRecord2.stop();
                          setState(() {
                            isPlay2 = false;
                          });
                          Navigator.pop(context, dataBackFromDetail="NOPE");
                        },
                      ),
                    ],
                  )
              ),
            ),
            ////////////////////////////////////////////////////////Nút tym detail
            Positioned(
              bottom: MediaQuery.of(context).size.height *0.08,
              right: MediaQuery.of(context).size.width *0.25,
              child: Container(
                  height:60,
                  width: 60,
                  decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0,4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top:15,
                        left: 15,
                        child:  Image(
                          height: 30,
                          width: 30,
                          image: AssetImage("assets/images/heart.png"),
                          fit: BoxFit.fill ,
                        ),
                      ),
                      FlatButton(
                        height:60,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onPressed: (){
                          audioPlayerRecord2.stop();
                          isPlay2 =false;
                          Navigator.pop(context, dataBackFromDetail="LIKE");
                        },
                      ),
                    ],
                  )
              ),
            ),
            //////////////////////////////////////////////////////////////Nút Play detail
            Positioned(
              top: MediaQuery.of(context).size.height *0.215,
              right: MediaQuery.of(context).size.width *0.205,
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
                      icon: Icon(isPlay2 ? Icons.stop : Icons.play_arrow_sharp, color: Color(0xFFFF6666), size: 60,),
                      onPressed: () async {
                        if(isPlay2){
                          audioPlayerRecord2.stop();
                          setState(() {
                            isPlay2 = false;
                          });
                        }
                        else {
                          int result = await audioPlayerRecord2.play(
                              widget.listSlideHomePage[widget.index].media);
                          print(result);
                          if (result == 1) {
                            setState(() {
                              isPlay2 = true;
                            });
                          }

                          ///Phát xong thì chuyển icon
                          audioPlayerRecord2.onPlayerCompletion.listen((_) {
                            setState(() {
                              isPlay2 = false;
                            });
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),

          ],
        )
    );
  }

}

Widget _hobbyBox(String text, Color colorText, Color colorBox){
  return Container(
    margin: EdgeInsets.all(3),
    height: 40,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20), left: Radius.circular(20)),
        color: colorBox
    ),
    child: Padding(
      padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
      child: Text(text, style: TextStyle(color: colorText, fontSize: 11),),
    ),
  );
}