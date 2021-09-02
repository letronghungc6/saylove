import 'package:flutter/material.dart';


class Slide {
  final String imageUrl;
  final String title;
  final String description;

  Slide({
    @required this.imageUrl,
    @required this.title,
    @required this.description,
  });
}

final slideList = [
  Slide(
    imageUrl: 'assets/images/screen1.png',
    title: 'Chỉnh sửa hồ sơ của bạn',
    description: 'Thiết lập hồ sơ để đối phương hiểu rõ hơn về bạn.',
  ),
  Slide(
    imageUrl: 'assets/images/screen2.png',
    title: 'Tải ghi âm lên',
    description: 'Một bản ghi âm ngọt ngào để thu hút đối phương.',
  ),
  Slide(
    imageUrl: 'assets/images/screen3.png',
    title: 'Khám phá nhiều người hơn',
    description: 'Cùng bắt tay cho một cuộc hẹn hò nào.',
  ),
];