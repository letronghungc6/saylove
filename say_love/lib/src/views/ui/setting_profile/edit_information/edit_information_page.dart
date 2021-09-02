
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:say_love/src/models/hobby.dart';
import 'package:say_love/src/utils/female_icons.dart';
import 'package:say_love/src/utils/male_icons.dart';
import 'package:say_love/src/views/ui/setting_profile/edit_information/edit_birthday.dart';
import 'package:say_love/src/views/ui/setting_profile/edit_information/edit_height_weight.dart';
import 'package:say_love/src/views/ui/setting_profile/edit_information/edit_school.dart';
import 'package:say_love/src/views/ui/setting_profile/setting_profile.dart';
import 'package:say_love/src/views/utils/text_hobbies.dart';
import 'package:say_love/src/views/utils/text_hobbies_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EditInformation extends StatefulWidget{
  EditInformation({@required this.token, this.id});
  String token;
  String id;
  @override
  _EditInformation createState() => _EditInformation();
}

class _EditInformation extends State<EditInformation>{
  bool isLoading ;
  String firstName;
  String lastName;
  int birthday;
  String gender;
  String height;
  String weight;
  String hobby;
  int schoolID;
  String school;
  TextEditingController controllerFirstName = TextEditingController();
  TextEditingController controllerLastName = TextEditingController();
  List hobbyProfile = new List();
  List hobbyText = new List();
  String textBirthday;
  DateTime datetime;
  List<String> hobbyTamp = new List();
  String tamp="";
  String hobbyPost="";

  @override
  void initState(){
    isLoading = true;
    super.initState();
    getHobby();
    getInformation();
    Future.delayed(Duration(seconds:1), ()=>
        setState(() {
          isLoading = false;
        })
    );
  }

  updateProfile() async{
    String id = widget.id;
    String token= widget.token;
    String url = "http://45.76.151.147:8091/api/user/$id/profile";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer $token',
    };
    Map<String, String> jsonPost = {
      "first_name":"${controllerFirstName.text}",
      "last_name":"${controllerLastName.text}",
      "birthday": "$textBirthday",
      "gender":"$gender",
      "height":"$height",
      "weight":"$weight",
      "university_id":"$schoolID",
      "hobby":"$hobbyPost"
    };
    print(id);
    print(token);
    try{
      Response r = await patch(
          url, headers: headers, body: jsonEncode(jsonPost));
      dynamic jsonBody = json.decode( utf8.decode(r.bodyBytes));
      print(utf8.decode(r.bodyBytes));
      String mess = jsonBody["status_message"];
      SharedPreferences prefs2 = await SharedPreferences.getInstance();
      if(jsonBody["status_code"] == 200){
//        Navigator.push(context, MaterialPageRoute(builder: (context)=> Birthday(token:token, id:id)));

        prefs2.setString("first_name", controllerFirstName.text);
        prefs2.setString("last_name", controllerLastName.text);
        prefs2.setInt("birthday", datetime.millisecondsSinceEpoch);
        prefs2.setString("gender", gender);
        prefs2.setString("height", height);
        prefs2.setString("weight", weight);
        prefs2.setInt("schoolID", schoolID);
        prefs2.setString("school", school);
        prefs2.setString("hobby", hobbyPost);
        ////Cập nhật lại prefs tất cả
//        int timeStamp  = dateTime.millisecondsSinceEpoch;
      }
    }
    catch(e){
      print(e);
    }
  }



  Future<void>getInformation() async{
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    firstName = prefs2.getString("first_name");
    lastName = prefs2.getString("last_name");
    birthday = prefs2.getInt("birthday");
    gender = prefs2.getString("gender");
    height = prefs2.getString("height");
    weight = prefs2.getString("weight");
    hobby = prefs2.getString("hobby");
    school = prefs2.getString("school");
    schoolID = prefs2.getInt("schoolID");
    controllerFirstName.text = firstName;
    controllerLastName.text = lastName;
    datetime = DateTime.fromMillisecondsSinceEpoch(birthday);
    textBirthday = DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(birthday)).toString();
//    setState(() {
//      isLoading = false;
//    });
    for(int i = 0; i<hobby.length;i++){
      if(hobby[i] == "," ){
        hobbyTamp.add(tamp.trim());
        tamp="";
      }
      else if(i == hobby.length -1){
        tamp = "${tamp}${hobby[i]}";
        hobbyTamp.add(tamp.trim());
        tamp="";
      }
      else{
        tamp = "${tamp}${hobby[i]}";
      }
    }
    hobbyTamp.forEach((element) {
      print(element);
    });



  }
  getHobby() async{
    String url = "http://45.76.151.147:8091/api/hobby/all";
    Map<String, String> headers = {
      "Content-type": "application/json"
    };
    try{
      Response r = await get(url,headers: headers);
      dynamic jsonBody = json.decode( utf8.decode(r.bodyBytes));
      print(utf8.decode(r.bodyBytes));
      String mess = jsonBody["status_message"];
      if(jsonBody["status_code"] == 200){
        var hobbyJson = jsonBody["data"] as List;
        List<Hobby> a = hobbyJson .map((i) => Hobby.fromJson(i)).toList();
        a.forEach((element) {
          print(element.value);
          hobbyProfile.add(element.value.trim());
        });
      }
    }
    catch(e){
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                "Lỗi không xác định",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15
                ),
              ),
            );
          }
      );
    }
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
//            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content:
                    Text(
                      "Bạn có muốn lưu thay đổi?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: "Arial"
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        child: Text("Có"),
                        onPressed: (){
                          if(hobbyTamp.length<3 || hobbyTamp.length >6 ){
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content:
                                    Text(
                                      "Vui lòng chọn từ 3 đến 6 sở thích.",
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
                          }
                          else {
                            for (int i = 0; i < hobbyTamp.length; i++) {
                              if (i == hobbyTamp.length - 1) {
                                hobbyPost = hobbyPost + hobbyTamp[i];
                              }
                              else
                                hobbyPost = hobbyPost + hobbyTamp[i] + ", ";
                            }
                            //////Call api xong pop
                            updateProfile();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        },
                      ),
                      ElevatedButton(
                        child: Text("Không"),
                        onPressed: (){
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                }
            );
          },
        ),
    );


    return Scaffold(
      body: GestureDetector(
          onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
        child: Padding(
          padding: EdgeInsets.only(top: 20, left: 30, right: 30),
            child: (isLoading == false) ?
            ListView(
              children: [
                back,
                SizedBox(height: 20,),
                Text("Chỉnh sửa", style: TextStyle(color: Color(0xFF16123D), fontSize: 30, fontWeight: FontWeight.bold)),
                Text("thông tin", style: TextStyle(color: Color(0xFF16123D), fontSize: 30, fontWeight: FontWeight.bold)),
                SizedBox(height: 30,),
                Text("Cơ bản", style: TextStyle(color: Color(0xFF16123D), fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 30,),
                Text("Tên của tôi", style: TextStyle(color: Color(0xFF16123D), fontSize: 16 , fontWeight: FontWeight.bold)),
                ///Xử lí tên
                Row(
                  children: [
                    Container(
                      width:MediaQuery.of(context).size.width *0.5 ,
                      child: TextField(
                        controller: controllerFirstName,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10.0,10.0,10.0,0.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Container(
                      width:MediaQuery.of(context).size.width *0.3 ,
                      child: TextField(
                        controller: controllerLastName,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10.0,10.0,10.0,0.0),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Sinh nhật", style: TextStyle(color: Color(0xFF16123D), fontSize: 16 , fontWeight: FontWeight.bold)),
                    Container(
                      width: MediaQuery.of(context).size.width *0.4,
                      height: 65,
                      decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0,4),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white
                      ),
                      ///Xử lí ngày sinh
                      child: GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) => EditBirthday()),
                          );
                          setState(() {
                            textBirthday = result[0];
                            datetime = result[1];
                          });
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFFF0F2F6)
                              ),
                              child: Icon(Icons.calendar_today_outlined, color: Colors.blueGrey,size: 16),
                            ),
                            Text(textBirthday, style: TextStyle(color: Color(0xFF16123D), fontSize: 16 , fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Giới tính", style: TextStyle(color: Color(0xFF16123D), fontSize: 16 , fontWeight: FontWeight.bold)),
                    Container(
                      width: MediaQuery.of(context).size.width *0.3,
                      height: 65,
                      decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0,4),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white
                      ),
                      ///Xử lí giới tính
                      child: GestureDetector(
                        onTap: (){
                          if(gender == "0"){
                            setState(() {
                              gender ="1";
                            });
                          }
                          else
                            setState(() {
                              gender = "0";
                            });
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFFFE5EE)
                              ),
                              child: Icon(gender == "0" ? Male.male : Female.female, color: Colors.red,size: 16),
                            ),
                            Text(gender == "0" ? "Nam" : "Nữ" , style: TextStyle(color: Color(0xFF16123D), fontSize: 16 , fontWeight: FontWeight.bold)),
                            SizedBox(width: 5,)
                          ],
                        ),
                      )
                    ),
                  ],
                ),
                ///Xử lí cân nặng chiều cao
                SizedBox(height: 30,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) => EditHeightWeight()),
                        );
                        setState(() {
                          height = result[0];
                          weight = result[1];
                        });
                      },
                      child: Container(
                        height: 150,
                        width: (MediaQuery.of(context).size.width - 90)/2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xFFFF9933)
                        ),
                        child:
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(weight, style: TextStyle(color: Colors.white, fontSize: 36 , fontWeight: FontWeight.bold)),
                                      Text("  kg", style: TextStyle(color: Colors.white, fontSize: 20 , fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                  Text("Nặng", style: TextStyle(color: Colors.white, fontSize: 20 , fontWeight: FontWeight.bold))
                                ],
                              ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) => EditHeightWeight()),
                        );
                        setState(() {
                          height = result[0];
                          weight = result[1];
                        });
                      },
                      child: Container(
                        height: 150,
                        width: (MediaQuery.of(context).size.width - 90)/2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFF5985FF)
                        ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(height, style: TextStyle(color: Colors.white, fontSize: 36 , fontWeight: FontWeight.bold)),
                                  Text("  cm", style: TextStyle(color: Colors.white, fontSize: 20 , fontWeight: FontWeight.bold))
                                ],
                              ),
                              Text("Cao", style: TextStyle(color: Colors.white, fontSize: 20 , fontWeight: FontWeight.bold))
                            ],
                          ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40,),
                Text("Vị trí và học vấn", style: TextStyle(color: Color(0xFF16123D), fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 30,),
                Text("Sống tại", style: TextStyle(color: Color(0xFF16123D), fontSize: 16 , fontWeight: FontWeight.bold)),
                ///Sống tại đâu
                TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10.0,10.0,10.0,0.0),
                  ),
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Trường học", style: TextStyle(color: Color(0xFF16123D), fontSize: 16 , fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width * 0.5,
                        child:
                          Text(school, style: TextStyle(color: Color(0xFF16123D), fontSize: 14 , fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),

                        ),
                        SizedBox(width: 10,),
                        ///Trường gì
                        GestureDetector(
                          child: Icon(Icons.arrow_forward_ios_outlined,size: 16,),
                          onTap: () async {
                            ///Bấm vào là chuyển mảng
                            final result = await Navigator.push(context,
                              MaterialPageRoute(builder: (context) => EditSchool()),
                            );
                            setState(() {
                              schoolID = result[0];
                              school = result[1];
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 40,),
                Text("Sở thích", style: TextStyle(color: Color(0xFF16123D), fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for(var i = 0; i<hobbyProfile.length;i++)
                      if(hobbyTamp.contains(hobbyProfile[i]) == true)
                        TextHobbiesProfile(hobbyProfile[i], hobbyTamp, true)
                      else
                        TextHobbiesProfile(hobbyProfile[i], hobbyTamp, false)
                  ],
                ),
                SizedBox(height: 100,),
              ],
            ):
            Center(
              child: CircularProgressIndicator(),
            ),
        ),
      )
    );
  }

}