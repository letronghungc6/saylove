import 'package:say_love/src/models/message.dart';
import 'package:say_love/src/models/user.dart';
import 'package:say_love/src/views/ui/socket_io_chat/ChatUserModel.dart';
import 'package:say_love/src/views/ui/socket_io_chat/socket_chat.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart';


class ChatModel extends Model{
//  List<UserChat> users = [
//    UserChat("Lộc", "111"),
//    UserChat("Tuấn", "222"),
//    UserChat("Toàn", "333"),
//    UserChat("Hải", "444"),
//    UserChat("Cường", "555"),
//  ];
//  UserChat currentUser;
//  List<UserChat> listUser = List<UserChat>();
  List<Message> messages = List<Message>();
  List<Message> messTamp = List<Message>();
  SocketChat socketChat = SocketChat();
  Message message;
//  SocketIO socketIO;
//  //Khởi tạo các biến và socket
//  void init(){
//    currentUser = users[0];
//    listUser = users.where((user) => user.chatID != currentUser.chatID).toList();
//    socketIO = SocketIOManager().createSocketIO(
//        '<ENTER_YOUR_SERVER_URL_HERE>', '/',
//        query: 'chatID=${currentUser.chatID}');
//    socketIO.init();
//    socketIO.subscribe('receive_message', (jsonData) {
//      Map<String, dynamic> data = json.decode(jsonData);
//      messages.add(Message(
//          data['content'], data['senderChatID'], data['receiverChatID']));
//      notifyListeners();
//    });
//    socketIO.connect();
//  }
  //Gửi tin nhắn đến máy chủ và thêm vào danh sách tin nhắn
  void sendMessage(String text, String receiverChatID, String senderID, Socket socket){
    messages.add(Message(text, senderID, receiverChatID));
    notifyListeners();
    socket.emit("App\\Events\\MessageCreate", text);
  }

  //Lấy tin nhắn từ cuộc trò chuyện hiện tại
   List<Message> getMessages(Socket socket, String receiveID, String senderID) {
     socket.on("App\\Events\\MessageCreated", (data) {
       print(data);
       ChatUserModel messReceive = new ChatUserModel.fromJson(data);
       ///Lúc này người nhận là senderID , người gởi là receiveID
       if(messReceive.author.id == receiveID)
        messages.add(Message(messReceive.message, messReceive.author.id, senderID));
       if(messages.length >1) {
         for (int i = 0; i < messages.length-1; i++) {
           if (messages[i].text == messages[i + 1].text) {
             messages.remove(messages[i + 1]);
           }
         }
       }
       notifyListeners();
     });
     return messages;

  }

//  Message getMessage(Socket socket, String receiveID, String senderID) {
//    socket.on("App\\Events\\MessageCreated", (data) {
//      print(data);
//      ChatUserModel messReceive = new ChatUserModel.fromJson(data);
//      ///Lúc này người nhận là senderID , người gởi là receiveID
//      if(messReceive.author.id == receiveID)
////        messages.add(Message(messReceive.message, messReceive.author.id, senderID));
//        message = Message(messReceive.message, messReceive.author.id, senderID);
//      notifyListeners();
//    });
//    return message;
//  }


}