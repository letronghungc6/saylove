import 'package:flutter/material.dart';
import 'package:say_love/src/utils/cancel_icons.dart';
import 'package:say_love/src/views/ui/setting_profile/image_record/edit_record/record_background.dart';

class SelectRecord extends StatefulWidget{
  String token;
  String id;
  SelectRecord({@required this.token, this.id});
  @override
  _SelectRecord createState() => _SelectRecord();
}

class _SelectRecord extends State<SelectRecord>{



  @override
  Widget build(BuildContext context) {

    final back = Container(
      height: 50,
      width: 50,
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        child: Icon(Cancel.cancel,size: 24,),
        onTap: (){
          Navigator.pop(context);
        },
      ),
    );


    return Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 40, left: 30, right: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              back,
              SizedBox(height: 30,),
              Text("Tạo mới", style: TextStyle(color: Color(0xFF16123D), fontSize: 30, fontWeight: FontWeight.bold)),
              Text("Chọn loại nội dung", style: TextStyle(color: Color(0xFF16123D), fontSize: 18)),
              SizedBox(height: 150,),
              Center(
                  child: GestureDetector(
                    child: Image(
                      image: AssetImage("assets/images/select_file.png"),
                    ),
                    onTap: (){
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content:
                              Text(
                                "Chức năng này đang phát triển.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    fontFamily: "Arial"
                                ),
                              ),
                            );
                          }
                      );
                    },
                  ),
              ),
              SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  child: Image(
                    image: AssetImage("assets/images/recording.png"),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RecordPage(token: widget.token, id: widget.id,)));
                  },
                ),
              ),


            ],
          ),
        )
    );

  }

}