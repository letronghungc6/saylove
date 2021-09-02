
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:say_love/src/models/hobby_homepage.dart';
import 'package:say_love/src/models/slide_homepage.dart';
import 'package:say_love/src/utils/transformers/transformers.dart';
import 'package:say_love/src/views/ui/chat_page/list_chat_page.dart';
import 'package:say_love/src/views/ui/homepage/list_view_homepage.dart';
import 'package:say_love/src/views/ui/login/login_screen.dart';
import 'package:say_love/src/views/ui/setting_profile/setting_profile.dart';
import 'package:say_love/src/views/ui/socket_io_chat/socket_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';


class HomePage extends StatefulWidget {
  HomePage({@required this.token, this.id});
  String token;
  String id;
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage>{
  int _currentPage = 0;
  PageController _pageController = PageController(
    viewportFraction: 0.9
  );
  CardController controllerCard = CardController();
  IndexController _controller;
  FixedExtentScrollController controller;
  int _index = 0;
  String check ="";
  bool isPlay1 = false;
  AudioPlayer audioPlayerRecord1 = AudioPlayer();
  Position currentPosition;
  bool isLoading = true;
  List<SlideHomePage> listSlideHomePage = new List();
  List<String> listHobbyTamp = ["Âm nhạc", "Chụp ảnh", "Du lịch"];
//  List<String> listHobbyTamp = new List();
  List<List> listHobbyHomepage = new List();
  SocketUtils socketUtils;

  @override
  void initState(){
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );
    _controller = new IndexController();
    controller = new FixedExtentScrollController();
    _getCurrentLocation();
  }

  connectSocket(String token) async {
    socketUtils = SocketUtils();

    await socketUtils.initSocket();
    socketUtils.setConnectListener(token);
//    await socketUtils.matching(id, token);
    socketUtils.setOnConnectionErrorListener(onConnectionError);
    socketUtils.setOnConnectErrorTimeOutListener(onConnectErrorTimeOut);
    socketUtils.setOnDisconnectListener(onDisconnect);
    socketUtils.setOnErrorListener(onError);
  }
//
//  onConnect(data) {
//    print("Connected $data");
//  }

  onConnectionError(data) {
    print("onConnectionError $data");
  }

  onConnectErrorTimeOut(data){
    print("onConnectErrorTimeOut $data");
  }

  onDisconnect(data){
    print("onDisconnect $data");
  }

  onError(data){
    print("onError $data");

  }


  _getCurrentLocation() async {
     connectSocket(widget.token);
     await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        currentPosition = position;
      });
      print("${currentPosition.latitude} và ${currentPosition.longitude}");
      getApi();
    }).catchError((e) {
      print(e);
    });
  }

  matching(int index) async{
//    socketUtils.matching(listSlideHomePage[index].id, widget.token);
//  socketUtils.initSocket();
    String id = listSlideHomePage[index].id;
    await socketUtils.matching(id);
    getApi();
    listSlideHomePage.removeAt(index);
    listHobbyHomepage.removeAt(index);
    print("Thích");
    setState(() {
      check = "";
    });
  }

  getApi() async {
    ///Call api
    String url = "http://45.76.151.147:8091/api/user/suggest?latitude=${currentPosition.latitude}&longitude=${currentPosition.longitude}";
    Map<String, String> headers = {
      "Authorization": 'Bearer ${widget.token}',
    };
//    try {
      Response r = await get(url, headers: headers);
      dynamic jsonBody = json.decode(utf8.decode(r.bodyBytes));
//      print(utf8.decode(r.bodyBytes));
      if(jsonBody["status_code"] == 200){
        var listJson = jsonBody["data"]["users"] as List;
        List<SlideHomePage> listTamp = listJson.map((i) => SlideHomePage.fromJson(i)).toList();
        listTamp.forEach((element) {
          listSlideHomePage.add(element);
//          listHobbyHomepage.add(listHobbyTamp);
//          if(element.hobby == null){
//            listHobbyHomepage.add(listHobbyTamp);
//          }
//          else {
            String a = element.hobby;
            String tamp="";
            List<String> listHobby = new List();
            for (int i = 0; i < a.length; i++) {
              if (a[i] == "," || i==a.length-1) {
                listHobby.add(tamp);
                tamp = "";
              }
              else {
                tamp = "$tamp${a[i]}";
              }
            }
            listHobbyHomepage.add(listHobby);
//          }
        });
        print(listSlideHomePage.length);
        print(listHobbyHomepage.length);
        setState(() {
          isLoading = false;
        });
      }
      else {
        print("Lỗi gì đó k biết");
      }
//    }
//    catch(e){
//      print("Lỗi gì đó k biết");
//    }
  }

  @override
  void dispose(){
    _pageController.dispose();

    super.dispose();
  }

  _onPageChanged(int index){
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:
          Stack(
            children: [
              (isLoading == false)?
                TinderSwapCard(
                  cardBuilder: (context, index) => Card(child: SlideItemHomePage(index, controllerCard, check, isPlay1, audioPlayerRecord1, listSlideHomePage, listHobbyHomepage)),
                  totalNum: listSlideHomePage.length,
                  maxWidth: MediaQuery.of(context).size.width ,
                  maxHeight: MediaQuery.of(context).size.height ,
                  minWidth: MediaQuery.of(context).size.width * 0.88,
                  minHeight: MediaQuery.of(context).size.height * 0.88,
                  swipeUp: false,
                  swipeDown: false,
                  cardController: controllerCard,
                  stackNum: 3,
                  swipeEdge: 4.0,
                  orientation: AmassOrientation.BOTTOM,
                  swipeUpdateCallback:
                      (DragUpdateDetails details, Alignment align) {
                    if (align.x < 0) {
                      audioPlayerRecord1.stop();
                      setState(() {
                        check = "NOPE";
                      });
                    } else if (align.x > 0) {
                      audioPlayerRecord1.stop();
                      setState(() {
                        check = "LIKE";
                      });
                    }
                  },
                  swipeCompleteCallback:
                      (CardSwipeOrientation orientation, int index) {
                    print(orientation.toString());
                    if (orientation == CardSwipeOrientation.LEFT) {
                      getApi();
                      listSlideHomePage.removeAt(index);
                      listHobbyHomepage.removeAt(index);
                      print("K Thích");
//                      audioPlayerRecord1.stop();
                      setState(() {
//                        isPlay1 = false;
                        check = "";
                      });
                    }
                    else if (orientation == CardSwipeOrientation.RIGHT) {
                      matching(index);
//                      socketUtils.matching(listSlideHomePage[index].id);
//                      getApi();
//                      listSlideHomePage.removeAt(index);
//                      listHobbyHomepage.removeAt(index);
////                      socketUtils.socket.emit("Matching", {"id":"${listSlideHomePage[index].id}"});
////                      socketUtils.socket.on("response-approve-new-contact", (data)=> print(data));
////                      socketUtils.socket.on('list-friend', (data)=> print(data));
//
//                      ///////////
//                      //////////////
//                      ///Chưa test
//                      ///////////
//                      ////////////
//                      print("Thích");
////                      audioPlayerRecord1.stop();
//                      setState(() {
////                        isPlay1 = false;
//                        check = "";
//                      });
                    }else if(orientation == CardSwipeOrientation.RECOVER){
                      setState(() {
                        check = "";
                      });
                    }
                  },
                ) :
                  Center(

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Text("Đang tìm kiếm đối tượng thích hợp với bạn", style: TextStyle(fontSize: 14),)
                      ],
                    )
                  ),
      //          TransformerPageView(
      ////            reverse: false,
      ////            physics: NeverScrollableScrollPhysics(),
      //            scrollDirection: Axis.horizontal,
      ////            controller: _pageController,
      //            transformer: transformers[0],
      //            curve: Curves.easeInOutCirc,
      //            onPageChanged: _onPageChanged,
      //            itemCount: slideHomePageList.length,
      //            itemBuilder: (BuildContext context, int i){
      //              return SlideItemHomePage(i);
      //            },
      //          ),

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
                                top:2,
                                left: 2,
                                child:  Image(
                                  height: 36,
                                  width: 36,
                                  image: AssetImage("assets/images/home.png"),
                                  fit: BoxFit.fill ,
                                ),
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
                                  if(socketUtils != null)
                                  socketUtils.closeConnection();
                                  Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (
                                            BuildContext context,
                                            Animation<double> animation,
                                            Animation<double> secondaryAnimation) {
//                                          getClient();
//                                          return StreamExample(
//                                            client: client,
//                                          );
                                        return ListChatPage(token:widget.token , id:widget.id);
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
                                  image: AssetImage("assets/images/user.png"),
                                  fit: BoxFit.fill ,
                                  color: Colors.black,
                                ),
                              ),
                              FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                onPressed: (){
                                  if(socketUtils != null)
                                  socketUtils.closeConnection();
                                  Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (
                                            BuildContext context,
                                            Animation<double> animation,
                                            Animation<double> secondaryAnimation) {
                                          return SettingProfile(token:widget.token , id:widget.id);
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
                    ],
                  ),
                ),
              )

            ],
          ),
//      bottomNavigationBar: BottomNavigationBar(
//        items: const <BottomNavigationBarItem>[
//          BottomNavigationBarItem(
//            icon: Icon(Icons.home),
//            label: '',
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.business),
//            label: '',
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.school),
//            label: '',
//          ),
//        ],
//        selectedItemColor: Colors.red,
//        iconSize: 30,
//        showSelectedLabels: false,
//      ),
    );
  }

}