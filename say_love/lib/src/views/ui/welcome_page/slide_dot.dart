import 'package:flutter/material.dart';

class SlideDots extends StatelessWidget {
  bool isActive;
  SlideDots(this.isActive);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 30),
      child: AnimatedContainer(
        padding: EdgeInsets.only(left: 20),
        duration: Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        height: 4,
        width: isActive ? 12 : 4,
        decoration: BoxDecoration(
        color: isActive ? Colors.red : Colors.pinkAccent,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    )
    );
  }
}