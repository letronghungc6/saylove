import 'package:flutter/material.dart';
import 'package:say_love/src/views/ui/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InformationLogout extends StatefulWidget{
  @override
  _InformationLogout createState() => _InformationLogout();

}

class _InformationLogout extends State<InformationLogout>{


  logout() async{
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    prefs2.setString("token", null);
    prefs2.setString("id", null);
    String email = prefs2.getString("email");
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(textEmail: email)));
//    Navigator.of(context)
//        .popUntil(ModalRoute.withName("/login"));
  }




  @override
  Widget build(BuildContext context) {

    final back = Container(
      height: 50,
      width: 50,
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        child: Icon(Icons.arrow_back_ios,size: 24,),
        onTap: (){
          Navigator.pop(context);
        },
      ),
    );

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 40, left: 40, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            back,
            SizedBox(height: 30,),
            Text("Cài đặt",style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF16123D)),),
            SizedBox(height: 30,),
            Text("Liên hệ với chúng tôi",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF16123D)),),
            SizedBox(height: 20,),
            Container(
              width: MediaQuery.of(context).size.width *0.8,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Color(0xFF4E4B6F)),
                borderRadius: BorderRadius.circular(5),
              ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FlatButton(
                      child: Text("Trợ giúp và Hỗ trợ", style: TextStyle(color: Color(0xFF4E4B6F), fontSize: 13),),
                    ),
                  ],
                )
            ),
            SizedBox(height: 30,),
            Text("Cộng đồng",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF16123D)),),
            SizedBox(height: 20,),
            Container(
              width: MediaQuery.of(context).size.width *0.8,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Color(0xFF4E4B6F)),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min ,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FlatButton(
                    child: Text("Quy tắc Cộng đồng", style: TextStyle(color: Color(0xFF4E4B6F), fontSize: 13),),
                  ),
                  FlatButton(
                    child: Text("Một vài lời khuyên về an toàn", style: TextStyle(color: Color(0xFF4E4B6F), fontSize: 13),),
                  ),
                ],
              )
            ),
            SizedBox(height: 30,),
            Text("Pháp lý",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF16123D)),),
            SizedBox(height: 20,),
            Container(
                width: MediaQuery.of(context).size.width *0.8,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Color(0xFF4E4B6F)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min ,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FlatButton(
                      child: Text("Giấy phép", style: TextStyle(color: Color(0xFF4E4B6F), fontSize: 13),),
                    ),
                    FlatButton(
                      child: Text("Chính sách Quyền riêng tư", style: TextStyle(color: Color(0xFF4E4B6F), fontSize: 13),),
                    ),
                    FlatButton(
                      child: Text("Điều khoản Sự dụng Dịch vụ", style: TextStyle(color: Color(0xFF4E4B6F), fontSize: 13),),
                    ),
                  ],
                )
            ),
            SizedBox(height: 30,),
            Container(
                width: MediaQuery.of(context).size.width *0.8,
                decoration: BoxDecoration(
                  color: Color(0xFFD51B0C),
                  borderRadius: BorderRadius.circular(5)
                ),
                child: FlatButton(
                  child:Text("Đăng xuất", style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    logout();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

}