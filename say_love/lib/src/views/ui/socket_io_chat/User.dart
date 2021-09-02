import 'package:say_love/src/views/ui/socket_io_chat/socket_utils.dart';
import 'package:scoped_model/scoped_model.dart';

class User{
  String id;
  String firstName;
  String lastName;
  String roomId;
  String avatar;


  User.fromJson(Map<String, dynamic> json):
    this.roomId = json["roomId"],
    this.id = json["id"],
    this.firstName = json["first_name"],
    this.lastName = json["last_name"],
        this.avatar = json["avatar"];


}
