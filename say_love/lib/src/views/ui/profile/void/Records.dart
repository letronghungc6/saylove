import 'dart:io';
//import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class Records extends StatefulWidget {
//  final List<String> records;
  final String fileRecord;
  const Records({Key key, this.fileRecord,}) : super(key: key);

  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  int _totalTime;
  int _currentTime;
//  int _selected = -1;
  bool isPlay = false;
  AudioPlayer advancedPlayer1 = AudioPlayer();
  AudioPlayer advancedPlayer2 = AudioPlayer();
  List<String> records;
  bool start = true;
//  String fileRecord ="";
  FileType _pickingType = FileType.custom;
  String _fileName;
  String _extension="";
  String _path;
  int currentTime;
  int totalTime;

  void _openFileExplorer() async {
    try {
      _path = await FilePicker.getFilePath(type: _pickingType,);
    }
    on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    setState(() {
        _fileName = _path;
      });
    print(_fileName);
    int status = await advancedPlayer1.play(_fileName, isLocal: true);
      print(status);
      if(status == 1){
        setState(() {
          isPlay = true;
//          start = false;
        });
      }
//    advancedPlayer1.onAudioPositionChanged.listen((Duration duration) => {
//      print('Current position: $duration'),
//      advancedPlayer1.onDurationChanged.listen((total) {
//        if(duration.inMicroseconds == total.inMicroseconds){
//          setState(() {
//            isPlay = false;
//          });
//        }
//      })
//  });
    advancedPlayer1.onPlayerCompletion.listen((_) {
      setState(() {
        isPlay = false;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.fileRecord),
            Row(
              children: [
                FlatButton(
                  child: Text(
                    isPlay ? "Dừng":"Chạy",
                  ),
                  onPressed: () async {
                    print("start -- $start");
                    if(isPlay){
                      advancedPlayer2.pause();
                      setState(() {
                        isPlay = false;
                      });
                    }
                    else{
                        int result = await advancedPlayer2.play(widget.fileRecord, isLocal: true);
                        print(result);
                        if(result == 1){
                          setState(() {
                            isPlay = true;
//                            start = false;
                          });
                        }
                        advancedPlayer2.onPlayerCompletion.listen((_) {
                          setState(() {
                            isPlay = false;
                          });
                        });
                    }
                  },
                ),
                FlatButton(
                    onPressed: (){
//                      Directory appDirec = Directory(widget.fileRecord);
//                      appDirec.delete(recursive: true);
//                      Fluttertoast.showToast(msg: "File Deleted");
//                      setState(() {
////                        records.remove(widget.fileRecord);
//                      });
                    },
                    child: Text("Xoá")),
                FlatButton(
                  child: Text(
                    "Chọn ghi âm có sẵn"
                  ),
                  onPressed: () => _openFileExplorer(),
//                  onPressed: () async{
//                    String filePath;
////                    String filePath = await FilePicker.getFilePath();
//                    FilePickerResult result = await FilePicker.platform.pickFiles();
//                    if(result != null) {
//                      File file = File(result.files.single.path);
//                       filePath = file.path;
//                    } else {
//                      print("Không chọn được file");
//                    }
//
//                    int runRecord = await advancedPlayer.play(filePath, isLocal: true);
//                    if(runRecord ==1){
//                      print(filePath);
//                      setState(() {
//                        isPlay = true;
//                      });
//                    }
//                    else print("k chạy được");
//                  },
                )
              ],
            )
          ],
        )
      ),
    );
  }

}