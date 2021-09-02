import 'package:flutter/material.dart';

class SlideButton extends StatelessWidget {
  bool isActive;
  SlideButton(this.isActive);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 75,
        child: RaisedButton(
          color: isActive ? Colors.white : Colors.red,
          child: Text(
            isActive ? "NEXT" : "START",
            style: TextStyle(
                color: isActive ? Colors.red : Colors.white, fontSize: 13,
                fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,

          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onPressed: (){

          },
        )
    );


  }
}