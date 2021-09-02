import 'package:flutter/material.dart';
import 'package:say_love/src/models/slide_page.dart';


class SlideItem extends StatelessWidget {
  final int index;
  SlideItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:80),
      child: ListView(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(slideList[index].imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 30,),
          Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                slideList[index].title,
                style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 26
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                slideList[index].description,
                style: TextStyle(
                  fontSize: 16, color: Colors.black26
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}