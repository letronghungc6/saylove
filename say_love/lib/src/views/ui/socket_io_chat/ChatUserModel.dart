

import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';

ChatUserModel chatUserModelFromJson(String str) => ChatUserModel.fromJson(json.decode(str));

String chatUserModelToJson(ChatUserModel data) => json.encode(data.toJson());

class ChatUserModel{
  ChatUserModel({
    this.author,
    this.message,
    this.timeCreate,
  });

  Author author;
  String message;
  String timeCreate;

  factory ChatUserModel.fromJson(Map<String, dynamic> json) => ChatUserModel(
    author: Author.fromJson(json["author"]),
    message: json["message"],
    timeCreate: json["timeCreate"],
  );

  Map<String, dynamic> toJson() => {
    "author": author.toJson(),
    "message": message,
    "timeCreate": timeCreate,
  };

}

class Author{
  Author({
    this.listName,
    this.firstName,
    this.media,
    this.id,
  });

  String listName;
  String firstName;
  String media;
  String id;

  factory Author.fromJson(Map<String, dynamic> json) => Author(
    listName: json["list_name"],
    firstName: json["first_name"],
    media: json["media"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "list_name": listName,
    "first_name": firstName,
    "media": media,
    "id": id,
  };

}
