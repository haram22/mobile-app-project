import 'package:flutter/material.dart';

class ChatRoomList extends StatefulWidget {
  const ChatRoomList({ Key? key }) : super(key: key);

  @override
  State<ChatRoomList> createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //      Navigator.of(context).pop();
        //   },
        // ),
        title: Text('채팅'),
        actions: [
          Container(
            child:  IconButton(
          icon: Icon(Icons.alarm),
          onPressed: () {
             Navigator.of(context).pop();
          },
        ),
            )
        ],
      ),
    );
  }
}