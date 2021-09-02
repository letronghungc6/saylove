import 'dart:io';
import 'package:say_love/src/views/ui/socket_io_chat/User.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketChat{
  static String connectUrl = 'http://167.179.70.213:3000';
  ///
  Socket socket;

  initSocket() async{
    socket = io(connectUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    print("Đang kết nối...");
    await _init();
  }

  _init() {
    print("Connecting to socket...");
    socket.on("connect", (_) {
      print("Socket connect");
    });
  }

  ///Authen join phòng
  setConnectListener(String token, String roomId) {
    socket.onConnect((data) {
//      onConnect(data);
      print("Đang authen");
      socket.emit('authenticate', {"Authorization": "$token"});
      socket.on('notify-authenticate', (data)=> print(data));
//      socket.on('list-friend', (data)=> print(data));
      print("Join phòng");
      socket.emit("user-send-idroom", roomId);
    });
    socket.connect();
  }

  ///Rời phòng
  outRoom(String roomId){
    print("Rời phòng");
    socket.emit("user-leave-idroom",roomId);
    closeConnection();
  }

  /// Lấy tin nhắn về
  getMessage(String roomId) async {
    print("Lấy tin nhắn");
    socket.on("App\\Events\\MessageCreated", (data) {
      print(data);
    });
  }

  ///Đẩy tin nhắn lên
  pushMessage(String message){
    print("Đẩy tin nhắn lên");
    socket.emit("App\\Events\\MessageCreate", message);
  }





  ///
  setOnConnectErrorTimeOutListener(Function onConnectTimeout){
    socket.onConnectTimeout((data) {
      onConnectTimeout(data);
    });
  }
  ///
  setOnConnectionErrorListener(Function onConnectError){
    socket.onConnectError((data) {
      onConnectError(data);
    });
  }

  ///
  setOnErrorListener(Function onError){
    socket.onError((data) {
      onError(data);
    });
  }
  ///
  setOnDisconnectListener(Function onDisconnect){
    socket.onDisconnect((data) {
      onDisconnect(data);
    });
  }
  ///
  closeConnection(){
    if(socket != null){
      print("Ngắt kết nối");
      socket.disconnect();
    }
    socket.disconnect();
  }
///






}