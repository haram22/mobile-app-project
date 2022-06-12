import 'package:app_project/chat.dart';
import 'package:app_project/set.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'chatRoomList.dart';
import 'home.dart';
import 'detail.dart';

class FavoriteList extends StatefulWidget {
  const FavoriteList({Key? key}) : super(key: key);

  @override
  State<FavoriteList> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {

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
              Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatRoomList()),
          );
            }, icon: Icon(Icons.chat_outlined)),
            IconButton(onPressed: (){}, icon: Icon(Icons.favorite_border_outlined)),
            IconButton(onPressed: (){
               Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => setting()),
          );
            }, icon: Icon(Icons.settings_outlined),),

          ],),
      ),
      appBar:
      AppBar(
        backgroundColor: Color(0xff4262A0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
             Navigator.push(
            this.context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
          },
        ),
        title: Text('Favorite'),
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
        .collection('favorite')
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
              return ListView(
                children: snapshot.data!.docs
                    .map((DocumentSnapshot data) => _buildFavoriteRoom(data))
                    .toList(),
              );
            }
          }},
      ),
    );
  }
  Widget _buildFavoriteRoom(DocumentSnapshot data) {
    Favorite productname = Favorite.fromDs(data);
     return Card(
      child: ListTile(
          shape: Border(
          ),
          onTap: () 
          {
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
                          Row(
                            children: [
                              Text(productname.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
                              SizedBox(width: 20,),
                              // Text('${productname.price} 원', )
                            ],
                          ),
                          SizedBox(height: 7,),
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
}
class Favorite{
  String name;
  // String price;
  Favorite({required this.name});
  factory Favorite.fromDs(DocumentSnapshot data) {
    return Favorite(
      name: data['favorite'] ?? '',
      //price: data['favorite'] ?? '',
    );
  }
}