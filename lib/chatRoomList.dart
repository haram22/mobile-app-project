import 'package:app_project/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
        .collection('product')
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
                    .map((DocumentSnapshot data) => _buildChatt1Room(data))
                    .toList(),
              );
            }
          }},
      ),
    );
  }


 Widget _buildChatt1Room(DocumentSnapshot data) {
    Product product = Product.fromDs(data);
    //final file = File(_photo?.path);

    return Card(
      child: ListTile(
          shape: Border(
          ),
          onTap: () {
            Navigator.push(
              this.context,
              MaterialPageRoute(
                  builder: (Product) => chattingPage()),
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
                          Text(product.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
                          SizedBox(height: 7,),
                          Text(product.course,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff6D6D6D)),),
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

class Product {
  String name;
  String course;
  String price;
  String url;
  int count;

  Product({required this.name, required this.course, required this.price, required this.url, required this.count});
  factory Product.fromDs(DocumentSnapshot data) {
    return Product(
      name: data['name'] ?? '',
      course: data['course'] ?? '',
      price: data['price']?? '',
      url: data['url'] ?? '',
      count: data['count'] ?? 0,
    );
  }
}