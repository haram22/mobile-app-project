import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';


class ChatRoom extends StatefulWidget {
  @override 
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅'),
      ),
    );
  }
}




class chattingPage extends StatefulWidget {
  const chattingPage({ Key? key }) : super(key: key);

  @override
  State<chattingPage> createState() => _chattingPageState();
}

class _chattingPageState extends State<chattingPage> {
  
   final FirebaseAuth auth = FirebaseAuth.instance;
     User? user = FirebaseAuth.instance.currentUser;

   
  final TextEditingController contentController = TextEditingController();

  Widget chatMessages(){
    return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chat')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            if (snapshot.data!.size == 0) {
              return Center(
                child: Container(
                    width: 220,
                    child: const Text('There is no data in Firebase!\n Add data using Floating button')),
              );
            } else {
              return Column(
                children: snapshot.data!.docs
                    .map((DocumentSnapshot data) => _buildChat(data))
                    .toList(),
              );
            }
          }
                });
  }

  Widget chatadd() {
    return  Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            width: double.infinity,
            child:  Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: TextFormField(
                              controller: contentController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              String cid = DateTime.now().toString();
                              await FirebaseFirestore.instance
                                  .collection('chat')
                                  .doc(cid)
                                  .set({
                                'user' : user,
                                'timeStamp': DateTime.now(),
                                'content': contentController.text,
                                'cid': cid,
                              }).whenComplete(() {
                                print('chat add');
                                contentController.clear();
                              });
                            },
                            icon: Icon(
                              Icons.send,
                              color: Colors.blueGrey,
                            )),
                      ],
                    )
          );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: chatadd(),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('chat',style: TextStyle(color: Colors.black),)
      ),
      body: ListView(
        children: [
        chatMessages(),
        ],
      ),
    );
  }

   Widget _buildChat(DocumentSnapshot data) {
    Chat _chat = Chat.fromDs(data);

    return _chat.user == "ㅇ"
       ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                child: InkWell(
                  child: Card(
                    elevation: 4,
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        _chat.content,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        )
      ],
    )
    : Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                child: InkWell(
                  child: Card(
                    elevation: 4,
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        _chat.content,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class Chat {
  String user;
  String content;
  String cid;

  Chat({required this.user, required this.content, required this.cid});

  factory Chat.fromDs(DocumentSnapshot data) {
    return Chat(  
      user: data['user'] ?? '',
      content: data['content'] ?? '',
      cid: data['cid'] ?? '',
    );
  }
}
