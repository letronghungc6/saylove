import 'package:chat_ui_kit/chat_ui_kit.dart';

class ChatUser extends UserBase {
  String id;
  String name;
  String avatar;

  ChatUser({this.id, this.name, this.avatar});

}
final chatUserList= [
  ChatUser(id:"1", name: "Hùng", avatar: "assets/images/image1.png"),
  ChatUser(id:"2", name: "Tuấn", avatar: "assets/images/image2.png"),
  ChatUser(id:"3", name: "Hải", avatar: "assets/images/image3.png"),
  ChatUser(id:"4", name: "Toàn", avatar: "assets/images/image4.png"),
  ChatUser(id:"5", name: "Cường", avatar: "assets/images/image5.png"),
  ChatUser(id:"6", name: "Lộc", avatar: "assets/images/image6.png"),

];