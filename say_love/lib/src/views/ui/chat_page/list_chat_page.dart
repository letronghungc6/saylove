import 'package:flutter/material.dart';
import 'package:say_love/src/models/chat_model.dart';
import 'package:say_love/src/models/user.dart';
import 'package:say_love/src/views/ui/chat_page/chat_page.dart';
import 'package:say_love/src/views/ui/homepage/homepage.dart';
import 'package:say_love/src/views/ui/setting_profile/setting_profile.dart';
import 'package:say_love/src/views/ui/socket_io_chat/User.dart';
import 'package:say_love/src/views/ui/socket_io_chat/socket_utils.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import "dart:collection";


//class RunChatPage extends StatelessWidget {
//  RunChatPage({@required this.token, this.id});
//  String token;
//  String id;
//  @override
//  Widget build(BuildContext context) {
//    return ScopedModel(
//      model: UserModel(),
//      child: MaterialApp(
//        debugShowCheckedModeBanner: false,
//        home: ListChatPage(token: token, id: id),
//      ),
//    );
//  }
//}

class ListChatPage extends StatefulWidget {
  ListChatPage({@required this.token, this.id});
  String token;
  String id;
  @override
  _ListChatPage createState() => _ListChatPage();
}

class _ListChatPage extends State<ListChatPage>{
    bool _connectedToSocket;
    String _connectMessage;
    String id;
    String firstName;
    String lastName;
    SocketUtils socketUtils2;
//    List<User> userList;
    List<User> userList;
    List<User> userListTamp;


  @override
  void initState() {
    super.initState();
    _connectedToSocket = false;
    _connectMessage = "Đang kết nối...";
    waitingCallUserList();
  }


  waitingCallUserList() async {
    await connectSocket(widget.token);

    Future.delayed(Duration(milliseconds: 3000), () {
      setState(() {
        _connectedToSocket= true;
      });
      print("List có ${userList.length} bạn");
    });
  }

  connectSocket(String token) async {
    socketUtils2 = SocketUtils();

    await socketUtils2.initSocket();
//    socketUtils2.setConnectListener(onConnect, token);
    userList = socketUtils2.getListFriend(token);
    socketUtils2.setOnConnectionErrorListener(onConnectionError);
    socketUtils2.setOnConnectErrorTimeOutListener(onConnectErrorTimeOut);
    socketUtils2.setOnDisconnectListener(onDisconnect);
    socketUtils2.setOnErrorListener(onError);
  }

  onConnect(data) {
    print("Connected $data");
  }

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

  @override
  void dispose() {
    super.dispose();
    _connectMessage ="";
    _connectedToSocket = false;
  }


  getInfo() async{
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
     id = prefs2.getString("id");
     firstName = prefs2.getString("first_name");
     lastName = prefs2.getString("last_name");
//    User me = User(id: "$id",firstName: "$firstName", lastName: "$lastName");
//    print("$id --- $firstName --- $lastName");
//    G.loggedInUser = me;
  }



//  _connectToSocket(String token) async {
//    socketUtils = SocketUtils();
//
//    await socketUtils.initSocket();
//    socketUtils.setConnectListener(onConnect, token);
//    socketUtils.getListFriend(userList);
//    socketUtils.setOnConnectionErrorListener(onConnectionError);
//    socketUtils.setOnConnectErrorTimeOutListener(onConnectErrorTimeOut);
//    socketUtils.setOnDisconnectListener(onDisconnect);
//    socketUtils.setOnErrorListener(onError);
//  }

//  onConnect(data) {
//    print("Connected $data");
////    setState(() {
////      _connectedToSocket = true;
////      _connectMessage = "Connected";
////    });
//
//  }
//
//  onConnectionError(data) {
//    print("onConnectionError $data");
////    setState(() {
////      _connectedToSocket = false;
////      _connectMessage = "Connection Error";
////    });
//  }
//
//  onConnectErrorTimeOut(data){
//    print("onConnectErrorTimeOut $data");
////    setState(() {
////      _connectedToSocket = false;
////      _connectMessage = "Connection Timed out";
////    });
//  }
//
//  onDisconnect(data){
//    print("onDisconnect $data");
////    setState(() {
////      _connectedToSocket = false;
////      _connectMessage = "Disconnected";
////    });
//  }
//
//  onError(data){
//    print("onError $data");
////    setState(() {
////      _connectedToSocket = false;
////      _connectMessage = "Connection Error";
////    });
//  }




///Click vào từng tin nhắn thì qua trang tin nhắn riêng
  void userClicked(User user, String token) async {
    await socketUtils2.closeConnection();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ChatPageModel(user, token, widget.id);
        },
      ),
    );
  }

  Widget buildAllChatList() {
    return
      Padding(
            padding: EdgeInsets.only(top: 30, left: 0, right: 0),
            child: Column(
            children: [
              SizedBox(height: 30,),
              Container(
                padding: EdgeInsets.only(left:50, right:50),
                height: 60,
                width: MediaQuery.of(context).size.width,
                  child: Text("Nhắn tin", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)
              ),
              (_connectedToSocket == false) ?
                  Container(
                    height: MediaQuery.of(context).size.height-170,
                    child: Center(child: Text(_connectMessage),),
                  ) : (userList.length != 0)?
              Container(
                padding: EdgeInsets.only(left:50, right:50),
                height: MediaQuery.of(context).size.height-170,
                        child: ListView.builder(
                          itemCount: userList.length,
                            itemBuilder: (context, index){
                              User user = userList[index];
                              return Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: ListTile(
                                  leading:
                                  Container(
                                    height: 50,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        //border: Border.all(width: 1, color: Colors.black),
                                    ),
                                    child: Image.network(
                                      userList[index].avatar,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("${userList[index].firstName} ${userList[index].lastName}", style: TextStyle(color: Color(0xFF16123D), fontWeight: FontWeight.bold, fontSize: 18),),
//                                    Text("Hôm qua 11h", style:TextStyle(color: Color(0xFF16123D), fontWeight: FontWeight.bold, fontSize: 14) ,)
                                    ],
                                  ),
//                                subtitle: Text("Tin nhắn mới", style: TextStyle(color:Color(0xFF16123D)),),
                                onTap: () => userClicked(user, widget.token),
                                ),
                              );
                            }
                ),
              ):
                  Container(
                    height: MediaQuery.of(context).size.height-170,
                    child: Center(
                      child: Text("Bạn chưa có người kết nối."),
                    ),
                  ),

              ///
              Container(
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
                                  socketUtils2.closeConnection();
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
                                top:2,
                                left: 2,
                                child:  Image(
                                  height: 36,
                                  width: 36,
                                  image: AssetImage("assets/images/chat.png"),
                                  fit: BoxFit.fill ,
                                  color: Colors.red,
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
                                  image: AssetImage("assets/images/user.png"),
                                  fit: BoxFit.fill ,
                                  color: Colors.black,
                                ),
                              ),
                              FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                onPressed: (){
                                  socketUtils2.closeConnection();
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
                            ],
                          )
                      ),
                    ],
                  ),
                ),
            ],
          )
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildAllChatList(),
    );
  }
}