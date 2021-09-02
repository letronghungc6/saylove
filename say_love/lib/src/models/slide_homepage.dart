
import 'package:flutter/material.dart';

class SlideHomePage {
  final num birthday;
  final String id;
  final String gender;
  final double weight;
  final double height;
  final String media;
  final String hobby;
  final String email;
  final String firstName;
  final String lastName;
  final String placeOfBirth;
  final String universityName;
  final String location;

  SlideHomePage.fromJson(Map<String, dynamic> json):
        this.id = json["uuid"],
        this.birthday = json["birthday"],
        this.gender = json["gender"],
        this.weight = json["weight"],
        this.height = json["height"],
        this.media = json["media"],
        this.hobby = json["hobby"],
        this.email = json["email"],
        this.firstName = json["first_name"],
        this.lastName = json["last_name"],
        this.placeOfBirth = json["place_of_birth"],
        this.universityName = json["university_name"],
        this.location = json["location"];




//  SlideHomePage({
//    @required this.image,
//    @required this.name,
//  });
}

//final slideHomePageList = [
//  SlideHomePage(image: "assets/images/image6.png", name: "Phạm Y Đức Bản"),
//  SlideHomePage(image: "assets/images/image7.png", name: "Phan Thanh Kiệt"),
//  SlideHomePage(image: "assets/images/image8.png", name: "Hồ Nhật Bằng"),
//  SlideHomePage(image: "assets/images/image9.png", name: "Nguyễn Gia Lâm"),
//  SlideHomePage(image: "assets/images/image10.png", name: "Diệp Duy Cường"),
//  SlideHomePage(image: "assets/images/image1.png", name: "Đỗ Anh Tuấn"),
//  SlideHomePage(image: "assets/images/image2.png", name: "Nguyễn Quốc Toàn"),
//  SlideHomePage(image: "assets/images/image3.png", name: "Ngô Thế Cường"),
//  SlideHomePage(image: "assets/images/image4.png", name: "Lê Văn Hải"),
//  SlideHomePage(image: "assets/images/image5.png", name: "Trần Bảo Lộc"),
//
//];


