import 'dart:io';

import 'package:say_love/src/views/ui/socket_io_chat/User.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:say_love/src/views/ui/socket_io_chat/ChatUserModel.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketUtils{
  ///10.0.2.2   167.179.70.213
  static String connectUrl = 'http://167.179.70.213:3000';
  ///
  Socket socket;
  List<User> userList = new List();

  initSocket() async{
    socket = io(connectUrl, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
    });
    print("Đang kết nối...");
    await _init();
  }

  _init() {
    print("Connecting to socket...");
    socket.on("connect", (_) {
      print("Socket connect");
    });
  }
///

///
  setConnectListener(String token) {
    socket.onConnect((data) {
//      onConnect(data);
    print("Đang authen");
      socket.emit('authenticate', {"Authorization": "$token"});
      socket.on('notify-authenticate', (data)=> print(data));
//      socket.on('list-friend', (data)=> print(data));
    });
    socket.connect();
  }
  
  List<User> getListFriend(String token){
//    List<User> userList = new List();
    User user;
    socket.onConnect((data){
      socket.emit('authenticate', {"Authorization": "$token"});
      print("Đang lấy list friend");
      socket.on('list-friend', (data){
        print(data);
        user = User.fromJson(data);
//        if(userList.indexOf(user,0) == -1){
//          userList.add(user);
//        }
        bool checkDuplicate = false;
        userList.forEach((element) {
          if(element.id == user.id){
            checkDuplicate = true;
          }
        });
        if(checkDuplicate == false){
          userList.add(user);
        }
      });
    });
    socket.connect();
    return userList;
  }
  ///
  getMessage(String roomId) async {
      print("Lấy tin nhắn");
      socket.emit("user-send-idroom", roomId);
      socket.on("joinRoom",(data)=> print(data));
      socket.on("notification",(data)=> print(data));
      socket.on("App\\Events\\MessageCreated", (data) {
        print(data);
      });

  }
  
///
  matching(String id){
//    socket.onConnect((data) {
//      print("Đang authen");
//      socket.emit('authenticate', {"Authorization": "$token"});
//      socket.on('notify-authenticate', (data)=> print(data));
      print("Đang connect để matching");
      socket.emit("Matching", id);
      socket.on("response-approve-new-contact", (data)=> print(data));
//      socket.on('list-friend', (data)=> print(data));
//    });
//    socket.connect();
  }
///
  setOnConnectErrorTimeOutListener(Function onConnectTimeout){
    socket.onConnectTimeout((data) {
      onConnectTimeout(data);
    });
  }
///
  setOnConnectionErrorListener(Function onConnectError){
    socket.onConnectError((data) {
      onConnectError(data);
    });
  }



///
  setOnErrorListener(Function onError){
    socket.onError((data) {
      onError(data);
    });
  }
///
  setOnDisconnectListener(Function onDisconnect){
    socket.onDisconnect((data) {
      onDisconnect(data);
    });
  }
///
  closeConnection(){
    if(socket != null){
      print("Ngắt kết nối");
      socket.disconnect();
    }
    socket.disconnect();
  }
///






}