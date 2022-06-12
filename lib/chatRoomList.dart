import 'package:app_project/chat.dart';
import 'package:app_project/set.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'favoritelist.dart';

class ChatRoomList extends StatefulWidget {
  const ChatRoomList({ Key? key }) : super(key: key);

  @override
  State<ChatRoomList> createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
    FirebaseAuth auth = FirebaseAuth.instance;
    final TextEditingController contentController = TextEditingController();
      User? user = FirebaseAuth.instance.currentUser;

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(onPressed: (){
                Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage()),
          );
            }, icon: Icon(Icons.home_outlined,)),
            IconButton(onPressed: (){
          //     Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => ChatRoomList()),
          // );
            }, icon: Icon(Icons.chat_outlined)),
            IconButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FavoriteList()),
              );
            }, icon: Icon(Icons.favorite_border_outlined)),
            IconButton(onPressed: (){
               Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => setting()),
          );
            }, icon: Icon(Icons.settings_outlined),),

          ],),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff4262A0),
        leading: Text(''),
        title: Text('채팅  ',textAlign: TextAlign.center),
        // actions: [
        //   Container(
        //     child:  IconButton(
        //   icon: Icon(Icons.alarm),
        //   onPressed: () {
        //      Navigator.of(context).pop();
        //   },
        // ),
        //     )
        // ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
        .collection('ProductList')
        .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            if (snapshot.data!.size == 0) {
              return Center(
                child: Container(
                    width: 220,
                    child: const Text('There is no data in Firebase!\n')),
              );
            } else { 
              return ListView(
                children: snapshot.data!.docs
                    .map((DocumentSnapshot data) => _buildChatt1Room(data))
                    .toList(),
              );
            }
          }},
      ),
    );
  }


 Widget _buildChatt1Room(DocumentSnapshot data) {
    ProductList productname = ProductList.fromDs(data);
    //final file = File(_photo?.path);

    return Card(
      child: ListTile(
          shape: Border(
          ),
          onTap: () 
          {
            Navigator.push(
            this.context,
            MaterialPageRoute(builder: (context) => _chatPage(data)),
          );
          },
          //leading: Image.network(_photo?.path),
          //leading: Image(image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/HGU-Emblem-eng.svg/1024px-HGU-Emblem-eng.svg.png?20200507143923'),height: 100, width: 70,),
          title:
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: 15,),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(productname.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
                          SizedBox(height: 7,),
                          Text(productname.place,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff6D6D6D)),),
                        ],
                      ),
                    )
                  ],
                ),

            ],),
            height: 70,
          ),
      ),
    );
  }
   Widget _chatPage(DocumentSnapshot data) {
    ProductList product = ProductList.fromDs(data);
    //final file = File(_photo?.path);
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black),
          onPressed: () {
           Navigator.push(
            this.context,
            MaterialPageRoute(builder: (context) => build(context)),
          );
          },
        ),
        title: Text('${product.name}',style: TextStyle(color: Colors.black),)
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
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
                                  .collection('${product.name}')
                                  .doc(cid)
                                  .set({
                                'user' : user,
                                'content': contentController.text,
                                'cid': cid,
                              }).whenComplete(() {
                                print('chat add');
                                contentController.clear();
                              });
                              FirebaseFirestore.instance
                                  .collection('ProductList')
                                  .doc(product.name)
                                  .set({
                                'name' : product.name,
                                'Place' : product.place
                              }).whenComplete(() {
                                print('ProductList add');
                                contentController.clear();
                              });
                            },
                            icon: Icon(
                              Icons.send,
                              color: Colors.blueGrey,
                            )),
                      ],
                    )
          ),
      ),
      body: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('${product.name}')
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
                })
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

class ProductList {
  String name;
  String place;
 

  ProductList({required this.name, required this.place});
  factory ProductList.fromDs(DocumentSnapshot data) {
    return ProductList(
      name: data['name'] ?? '',
      place: data['Place'] ?? '',
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

