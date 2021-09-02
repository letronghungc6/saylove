
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:http/http.dart' as http;
//import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:say_love/src/views/ui/homepage/homepage.dart';
import 'package:say_love/src/views/ui/profile/void/Records.dart';
import 'package:say_love/src/views/ui/socket_io_chat/socket_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/multipart_file.dart';
import 'package:socket_io_client/socket_io_client.dart';


class VoidPage extends StatefulWidget{
  VoidPage( this.token, this.id);
  String token = "";
  String id = "";

  _VoidPage createState() => _VoidPage();
}

class _VoidPage extends State<VoidPage>{
  FlutterAudioRecorder audioRecorder;
  RecordingStatus _currentStatus = RecordingStatus.Unset; ///Status hiện tại của ghi âm
  Recording _current;
  bool stop = false;
  String statusButton = "Chưa cho phép"; ///Text của button tiếp tục
  ///
  bool checkRecord = false; /// Kiểm tra coi record xong chưa
  Directory appDirectory;
  String fileRecord;/////Dùng để gọi phát nhạc
  String tenFile;
  String textButton = "Tiếp tục";
  String textDateCard;/////Gán tên file cho hộp thoại phát nhạc
  bool isPlay = false; //Nút phát nhạc
  AudioPlayer audioPlayerRecord = AudioPlayer();
  String _path;////path khi chọn từ file
  SocketUtils socketUtils;
  Socket socket;

//  void connectSocket(String token) async {
//    if(socketUtils == null){
//      socketUtils = SocketUtils();
//    }
//    socket = socketUtils.socket;
//    await socketUtils.initSocket();
//    socketUtils.setConnectListener(onConnect, token, socket);
//  }
//
//  onConnect(data) {
//    print("Connected $data");
//  }

  updateVoid() async{
//    String id = widget.id;
    String token= widget.token;
    String url = "http://45.76.151.147:8091/api/storage/upload-audio";
    File file = File(fileRecord);
      try{
//        Dio dio = new Dio();
//        FormData formData = new FormData.fromMap({"file":fileRecord});
//        Map<String, String> headers = {
//          "Authorization": "Bearer $token",
//          "Content-Type": "multipart/form-data"
//        };
//        await dio.post(url, data: formData,
//            options: Options(
//                method: 'POST',
//                headers: headers,
//                responseType: ResponseType.json));

//    try{
//      var r = await dioRequest.post(url, data: formData);
//      dynamic jsonBody = json.decode( utf8.decode(r.data));

      var r = http.MultipartRequest("POST", Uri.parse(url));
      r.headers["Authorization"] ="Bearer $token";
      r.headers["Content-Type"] = "multipart/form-data";

      r.files.add(await http.MultipartFile.fromPath("file",file.path,));
      var response = await r.send();
      print(fileRecord);
      print(file.path);
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
          print(value);
        });
      SharedPreferences prefs2 = await SharedPreferences.getInstance();
      if(response.statusCode == 200){
//        connectSocket(widget.token);
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => HomePage(token: widget.token, id: widget.id)));

        prefs2.setString("media", file.path);
        ////////////////////////////////////Lưu lại audio
      }
      else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(
                  "Không thể lưu trữ tệp",
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
  void initState()  {
    super.initState();
    FlutterAudioRecorder.hasPermissions.then((hasPermision) {
      print(hasPermision);
      if (hasPermision) {
        setState(() {
          _currentStatus = RecordingStatus.Initialized;
        });
      }
      else {
        setState(() {
          textButton = "Chưa cho phép";
        });
      }
    });
  }

  @override
  void dispose() {
    _currentStatus = RecordingStatus.Unset;
    audioRecorder = null;
    appDirectory = null;
    super.dispose();
  }
/////Hàm xét trạng thái
  Future<void> _onRecordButtonPressed() async {
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          _recordo();
          break;
        }
      case RecordingStatus.Recording:
        {
          _stop();
          break;
        }
//      case RecordingStatus.Paused:
////        {
////          _resume();
////          break;
////        }
      case RecordingStatus.Stopped:
        {
          _recordo();
          break;
        }
      default:
        break;
    }
  }
//////Trạng thái ban đầu
  _initial() async {
    ////Khai bao 1 danh muc
//    Directory appDir = await getExternalStorageDirectory();
//    Directory appDir = await getApplicationDocumentsDirectory();
//    String jrecord = 'Audiorecords';
//    var pathRoot = await ExtStorage.getExternalStorageDirectory();
    Directory appDir = await getExternalStorageDirectory();
    String pathRoot = appDir.path;
    print(pathRoot);
    ///Ten file
    DateTime a = DateTime.now();
    String dato = DateFormat('yyyy-MM-dd-hh--mm--ss').format(a);
//    String pathMain = "";
    Directory appDirec = Directory("${pathRoot}/RecordTest/");
    //Neu nhu thu muc nay da ton tai thi tao 1 cai ghi am ten patho
    if (await appDirec.exists()) {
      print("Tồn tại");
      String patho = "${appDirec.path}$dato";
      print(patho);
      setState(() {
//        tenFile = "/data/user/0/com.example.say_love/cache/file_picker/$dato.m4a";
      tenFile = "$patho.m4a";
        textDateCard=dato;
      });
      audioRecorder = FlutterAudioRecorder(patho,audioFormat: AudioFormat.AAC);
      await audioRecorder.initialized;
    } else {
      print("Tạo mới file");
      appDirec.create(recursive: true);
      //Fluttertoast.showToast(msg: "Start Recording , Press Start");
      String patho = "${appDirec.path}$dato";
      setState(() {
        tenFile = "$patho.m4a";
        textDateCard=dato;
      });
      audioRecorder = FlutterAudioRecorder(patho, audioFormat: AudioFormat.AAC);
      await audioRecorder.initialized;
    }
  }
/////Trạng thái bắt đầu
  _start() async {
    await audioRecorder.start();
    var recording = await audioRecorder.current(channel: 0);
    setState(() {
      _current = recording;
    });

    const tick = const Duration(milliseconds: 1000);
    //Nhảy số thời gian
    new Timer.periodic(tick, (Timer t) async {
      if (_currentStatus == RecordingStatus.Stopped) {
        t.cancel();
    }
      var current = await audioRecorder.current(channel: 0);
//      print(current.status);
      setState(() {
        _current = current;
        _currentStatus = _current.status;
      });
    });
  }
///Trạng thái tiếp tục
  _resume() async {
      await audioRecorder.resume();
      Fluttertoast.showToast(msg: "Resume Recording");
      setState(() {

      });
    }
///Trạng thái dừng
  _pause() async {
    await audioRecorder.pause();
    Fluttertoast.showToast(msg: "Pause Recording");
    setState(() {

    });
  }
///Trạng thái đóng
  _stop() async {
    var result = await audioRecorder.stop();
//    Fluttertoast.showToast(msg: "Stop Recording , File Saved");
    //viết 1 hàm để hiện file ghi âm đó lên widget
    //    widget.save();
    setState(() {
      _current = result;
      _currentStatus = _current.status;
      _current.duration = null;
//      statusButton = "Ghi âm";
      textButton = "Tiếp tục";
      stop = false;
      checkRecord = true;
      fileRecord = tenFile;
    });
    print(fileRecord);

  }

  //// Khi ở trạng thái ban đầu
  Future<void> _recordo() async {
    //Nếu được cho phép
    if (await FlutterAudioRecorder.hasPermissions) {
      await _initial();
      await _start();
//      Fluttertoast.showToast(msg: "Start Recording");
      setState(() {
        _currentStatus = RecordingStatus.Recording;
//        statusButton = "Dừng";
        textButton= "Dừng";
        stop = true;
      });
    } else {
      Fluttertoast.showToast(msg: "Allow App To Use Mic");
    }
  }







  @override
  Widget build(BuildContext context) {
    //--------------------------------------------------------------------------------------------------------
    final iconSelect = Container(
      padding: EdgeInsets.only(bottom: 30),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 6,
      width: 6,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
    //------------------------------------------------------------------------------------
    final iconNoneSelect = Container(
      padding: EdgeInsets.only(bottom: 30),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 6,
      width: 6,
      decoration: BoxDecoration(
        color: Color(0xffFF66FF),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
//------------------------------------------------------------------------------------
    final slideIcon = Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          iconNoneSelect,
          iconNoneSelect,
          iconNoneSelect,
          iconNoneSelect,
          iconNoneSelect,
          iconNoneSelect,
          iconSelect,
        ],
      ),
    );
    //----------------------------------------------------------------------------
    final nextButton = SizedBox(
      height: 50,
      width: 400,
      child: RaisedButton(
        color: Colors.red,
        child: Text(
          "Tiếp tục",
          style: TextStyle(
              color: Colors.white, fontSize: 15
          ),
          textAlign: TextAlign.center,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed:
        (checkRecord==false) ?
            (){
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(
                    "Ghi âm hoặc chọn từ tệp",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15
                    ),
                  ),
                );
              }
          );
        }
            :(){
          updateVoid();
        }
      ),
    );


    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30),
        Text(
          _current?.duration?.toString()?.substring(3, 7) ?? "0:00",
          style: TextStyle(color: Colors.black54, fontSize: 40),
        ),
        SizedBox(height: 70,),
        (textButton == "Dừng") ? Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.red,
            ),
            child: IconButton(
              padding: EdgeInsets.all(0),
              icon: Icon(Icons.pause, color: Colors.white, size: 95, ),
              onPressed: (){
                _stop();
              },
            ),
          ),
        ):
        Center(
          child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.black26,
                    width: 1,
                  )
              ),
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.circle, color: Colors.red, size: 95,),
                        ///////////////////////////////////////////////////////////////////////////////Bấm vào là ghi âm ===>Done
                        onPressed: ()async{
                          await _onRecordButtonPressed();
                          setState(() {
                            checkRecord= false;
                          });
                        },
                    ),
          ),
        ),

        SizedBox(height: 70),
        Center(
          child: IconButton(
            icon: Icon(Icons.note_add_outlined),
            color: Colors.black26,
            ///////////////////////////////////////////////////////////////////////////Chức năng chọn âm thanh từ tệp=====>Done
            onPressed: () async {
              try {
                _path = await FilePicker.getFilePath(type: FileType.custom,);
              }
              on PlatformException catch (e) {
                print("Unsupported operation" + e.toString());
              }
              setState(() {
                fileRecord = _path;
                textDateCard = "Âm thanh từ máy";
                checkRecord= true;
              });
              print(fileRecord);
            }),
          ),

        //Dùng checkRecord show ra khi ghi âm được

        (checkRecord == false) ? Container(height: 60,):
        Center(
          child: Container(
            height: 60,
            width: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: Offset(0,6),
                ),

              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(
                      isPlay ? Icons.pause :Icons.play_arrow,
                      color: Colors.red,
                    ),
                    onPressed: ()async{
                      ////////////////////////////////////////////////////////////////////////////////////////Phát nhạc=====>Done
//                      if(fileRecord != null){
                        if(isPlay){
                          audioPlayerRecord.pause();
                          setState(() {
                            isPlay = false;
                          });
                        }
                        else {
                          int result = await audioPlayerRecord.play(
                              fileRecord, isLocal: true);
                          print(result);
                          if (result == 1) {
                            setState(() {
                              isPlay = true;
                            });
                          }

                          ///Phát xong thì chuyển icon
                          audioPlayerRecord.onPlayerCompletion.listen((_) {
                            setState(() {
                              isPlay = false;
                            });
                          });
                        }
//                      }
//                      else{
//                        showDialog(
//                            context: context,
//                            builder: (BuildContext context) {
//                          return AlertDialog(
//                            content:
//                            Text(
//                              "Không có âm thanh được chọn",
//                              textAlign: TextAlign.center,
//                              style: TextStyle(
//                                  color: Colors.black54,
//                                  fontWeight: FontWeight.bold,
//                                  fontSize: 15,
//                                  fontFamily: "Arial"
//                              ),
//                            ),
//                          );
//                        });
//                      }
                    }),
                SizedBox(width: 20,),
                Column(
                  children: [
                    SizedBox(height: 10,),
                    Text("Record-Saylove", style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),),
                    //Lấy ngày tháng từ tên file
                    Text(textDateCard, style: TextStyle(fontSize: 11),)
                  ],
                ),
                SizedBox(width: 20,),
                IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.black54,
                    ),
                    onPressed: (){
                      if(isPlay){
                        audioPlayerRecord.stop();
                        setState(() {
                          isPlay = false;
                        });
                      }
                      ///////////////////////////////////////////////////////////////////////////////Xoá============>Done
                      setState(() {
                        fileRecord = null;
//                        textDateCard ="";
                        checkRecord = false;
                      });
                    })
              ],
            ),
          )
        ),
        SizedBox(height:20,),
        slideIcon,
        SizedBox(height: 10,),
        nextButton
      ],
    );

  }
}