


import 'package:flutter/material.dart';
import 'package:say_love/src/views/ui/profile/void/void_page.dart';
import 'package:say_love/src/views/utils/text_description.dart';
import 'package:say_love/src/views/utils/text_title.dart';

//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      home: Void(),
//    );
//  }
//}

class Void extends StatefulWidget{
  Void({@required this.token, this.id, this.checkBack});
  String token = "";
  String id="";
  bool checkBack;


  _Void createState() => _Void();
}

class _Void extends State<Void> {





  @override
  Widget build(BuildContext context) {
    final back = Container(
        height: 50,
        width: 50,
        alignment: Alignment.centerLeft,
        child: IconButton(
            icon: Icon(Icons.arrow_back_sharp,
              color: Colors.black,
            ),
            iconSize: 24,
            onPressed: () {
              Navigator.pop(context);
            }
        )
    );
    //----------------------------------------------------------------------------------

    return Scaffold(
        body: (widget.checkBack!=true)?
        Padding(
            padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 0),
            child: ListView(
              children: [
                back,
                SizedBox(height: 40,),
                TextTitle("Lời yêu"),
                SizedBox(height: 10,),
                TextDescription("Hãy sử dụng giọng nói của bạn để truyền đạt cho nửa còn lại thấu hiểu về bạn hơn."),
                VoidPage(widget.token, widget.id),
              ],
            )
        ):
        Padding(
            padding: EdgeInsets.only(left: 20, top: 120, right: 20, bottom: 0),
            child: ListView(
              children: [
                TextTitle("Lời yêu"),
                SizedBox(height: 10,),
                TextDescription("Hãy sử dụng giọng nói của bạn để truyền đạt cho nửa còn lại thấu hiểu về bạn hơn."),
                VoidPage(widget.token, widget.id ),
              ],
            )
        )
    );
  }

}