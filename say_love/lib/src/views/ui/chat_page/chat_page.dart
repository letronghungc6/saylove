import 'package:flutter/material.dart';
import 'package:say_love/src/models/chat_model.dart';
import 'package:say_love/src/models/message.dart';
import 'package:say_love/src/models/user.dart';
import 'package:say_love/src/views/ui/chat_page/list_chat_page.dart';
import 'package:say_love/src/views/ui/socket_io_chat/ChatUserModel.dart';
import 'package:say_love/src/views/ui/socket_io_chat/User.dart';
import 'package:say_love/src/views/ui/socket_io_chat/socket_chat.dart';
import 'package:say_love/src/views/ui/socket_io_chat/socket_utils.dart';
import 'package:scoped_model/scoped_model.dart';


class ChatPageModel extends StatelessWidget {
  final User user;
  final String token;
  final String id;
  ChatPageModel(this.user, this.token, this.id);

  @override
  Widget build(BuildContext context) {

    return ScopedModel(

      model: ChatModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ChatPage(user, token, id),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final User user;
  final String token;
  final String id;
  ChatPage(this.user, this.token, this.id);
  @override
  _ChatPage createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  final TextEditingController textEditingController = TextEditingController();
  SocketChat socketChat;
  List<Message> messages = List<Message>();
  @override
  void initState() {
    super.initState();
    connectSocket();
  }

  connectSocket() async {
    socketChat = SocketChat();
    await socketChat.initSocket();
    print("________");
    print(widget.user.roomId);
    print("________");
    await socketChat.setConnectListener(widget.token, widget.user.roomId);
  }


  //Tin nhắn trả về
  Widget buildSingleMessage(Message message) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: message.senderID == widget.user.id
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
                decoration: BoxDecoration(
                    color: message.senderID == widget.user.id ? Color(0xFFFFE5EE) : Color(0xFFE5ECFF),
                    borderRadius: BorderRadius.circular(20)
                ),
                padding: const EdgeInsets.all(20.0),
                //margin: message.senderID == widget.user.chatID ? EdgeInsets.only(left: 50, top: 10, right: MediaQuery.of(context).size.width*0.3, bottom: 10) : EdgeInsets.only(left: MediaQuery.of(context).size.width*0.3, top: 10, right: 50, bottom: 10),
                child: Center(
                  child: Text(message.text, style: TextStyle(color: message.senderID == widget.user.id ? Color(0xFFFF3377) : Color(0xFF5985FF)),),
                )
            )
          ],
        )
    );
  }
  //List chứa tin nhắn
  Widget buildChatList() {
    return ScopedModelDescendant<ChatModel>(
      builder: (context, child, model) {
        List<Message> messages = model.getMessages(socketChat.socket, widget.user.id, widget.id);
//        messages = List<Message>();
//        messages.add(model.getMessage(socketChat.socket, widget.user.id, widget.id));
//        messages.add(Message("Hùng", widget.id, widget.user.id));
//        messages.add(Message("Toàn", widget.user.id, widget.id));
//        model.getMessages(socketChat.socket, widget.id);
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              return buildSingleMessage(messages[index]);
            },
          ),
        );
      },
    );
  }
//  ///Ô nhập tin nhắn
  Widget buildChatArea() {
    return ScopedModelDescendant<ChatModel>(
      builder: (context, child, model) {
        return Center(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    height: 60,
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
//                  border: Border.all(
//                    width: 1,
//                  ),
                        color:Color(0xFFE5ECFF)
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextField(
                            controller: textEditingController,
                            style: TextStyle(fontSize: 16, color: Color(0xFF5985FF)),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Type your messages...",
                                hintStyle: TextStyle(color: Color(0xFF5985FF), fontSize: 16)
                            ),
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            if(textEditingController.text != "") {
                              model.sendMessage(
                                  textEditingController.text,
                                  widget.user.id, widget.id, socketChat.socket);
                              //socketChat.pushMessage(textEditingController.text);
                              textEditingController.text = '';
                            }
                          },
                          elevation: 0,
                          child: Icon(Icons.send),
                        ),
                      ],
                    )
                ),
              ],
            ),
          )
        );
      },
    );
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
          socketChat.outRoom(widget.user.roomId);
//          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (
                    BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return ListChatPage(token: widget.token, id: widget.id);
                },
                transitionDuration: Duration(milliseconds: 100),
                transitionsBuilder: (
                    BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) {
                  return Align(
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
              )
          );
        },
      ),
    );


    return Scaffold(
        body: GestureDetector(
          onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
          child: ListView(
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0,4),
                      ),
                    ],
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                    color: Colors.white,
                ),
                child: Row(
                  children: [
                    SizedBox(width: 20,),
                    back,
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(widget.user.avatar),
                    ),
//                    Container(
//                      height: 40,
//                      width: 40,
//                      decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(20),
//                          //border: Border.all(width: 1, color: Colors.black),
//                      ),
//                      child: Image.network(
//                        widget.user.avatar,
//                        fit: BoxFit.cover,
//                      ),
//                    ),
                    SizedBox(width: 10,),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Text("${widget.user.firstName} ${widget.user.lastName}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.2,),
                    PopupMenuButton(
                      itemBuilder: (_) => <PopupMenuItem<String>>[
                        new PopupMenuItem<String>(
                            child: const Text('Xem thông tin'), value: 'Thông tin'),
                        new PopupMenuItem<String>(
                            child: const Text('Xem tiến độ tình cảm'), value: 'Tình cảm'),
                        new PopupMenuItem<String>(
                            child: const Text('Chia tay'), value: 'Chia tay'),
                      ],
                    )
                  ],
                ),
              ),

              Container(
              height: MediaQuery.of(context).size.height -200,
                child: buildChatList(),
            ),
              SizedBox(height: 30,),
              buildChatArea(),
              SizedBox(height: 10,),
            ]
          )
        )
    );




    ///
    ///
    ///
//    return Scaffold(
////      backgroundColor: Colors.black,
////      appBar: AppBar(
////        title: Text(widget.user.name),
////        backgroundColor: Colors.black,
////        actions: [
////          IconButton(icon: Icon(Icons.menu, color: Colors.white,), onPressed: null)
////        ],
////      ),
//      body: GestureDetector(
//          onTap: (){
//          FocusScope.of(context).requestFocus(new FocusNode());
//        },
//        child: ListView(
//          children: [
//            Container(
//              height: 80,
//              decoration: BoxDecoration(
//                  boxShadow: <BoxShadow>[
//                    BoxShadow(
//                      color: Colors.grey.withOpacity(0.2),
//                      spreadRadius: 1,
//                      blurRadius: 5,
//                      offset: Offset(0,4),
//                    ),
//                  ],
//                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
//                  color: Colors.white,
//              ),
//              child: Row(
//                children: [
//                  SizedBox(width: 20,),
//                  back,
//                  Container(
//                    height: 40,
//                    width: 40,
//                    decoration: BoxDecoration(
//                        borderRadius: BorderRadius.circular(20),
//                        //border: Border.all(width: 1, color: Colors.black),
//                        image: DecorationImage(
//                            image: AssetImage("assets/images/image6.png"),
//                            fit: BoxFit.fill
//                        )
//                    ),
//                  ),
//                  SizedBox(width: 10,),
//                  Container(
//                    width: MediaQuery.of(context).size.width * 0.2,
//                    child: Text(widget.user.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
//                  ),
//                  SizedBox(width: MediaQuery.of(context).size.width * 0.35,),
////                  GestureDetector(
////                    child: Icon(Icons.menu),
////                    onTap: (){
////
////                    },
////                  )
//                PopupMenuButton(
//                  itemBuilder: (_) => <PopupMenuItem<String>>[
//                    new PopupMenuItem<String>(
//                        child: const Text('Xem thông tin'), value: 'Thông tin'),
//                    new PopupMenuItem<String>(
//                        child: const Text('Xem tiến độ tình cảm'), value: 'Tình cảm'),
//                    new PopupMenuItem<String>(
//                        child: const Text('Chia tay'), value: 'Chia tay'),
//                  ],
//                )
//                ],
//              ),
//            ),
//            Container(
//              height: MediaQuery.of(context).size.height -200,
//              child: buildChatList(),
//            ),
//            SizedBox(height: 30,),
//            buildChatArea(),
//            SizedBox(height: 10,),
//          ],
//        )
//      )
//    );
  }

}
