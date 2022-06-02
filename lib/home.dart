import 'dart:io';
import 'package:app_project/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'add.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'chatRoomList.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  //final ImagePicker _url = ImagePicker();
  final nameController = TextEditingController();
  final courseController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
 @override
  void initState() {
    super.initState();
  }

  // File? _photo;
  //
  // Future<void> downloadURLExample() async {
  //   final fileName = basename(_photo!.path);
  //   final destination = 'files/$fileName';
  //   String url = await firebase_storage.FirebaseStorage.instance
  //       .ref(destination)
  //       .getDownloadURL();
  //
  //   // Within your widgets:
  //   // Image.network(downloadURL);
  // }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: BottomAppBar(

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          
          children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.home_outlined,)),
            IconButton(onPressed: (){
              Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatRoomList()),
          );
            }, icon: Icon(Icons.chat_outlined)),
            IconButton(onPressed: (){}, icon: Icon(Icons.favorite_border_outlined)),
            IconButton(onPressed: (){}, icon: Icon(Icons.settings_outlined),),

        ],),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Text(''),

        title: Image(image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/HGU-Emblem-eng.svg/1024px-HGU-Emblem-eng.svg.png?20200507143923'),height: 50),

        actions: [
          IconButton(onPressed: () {

          },
              icon : Icon(Icons.search)
          )
        ],
        centerTitle: true,
        elevation: 0,
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
                    .map((DocumentSnapshot data) => _buildListTile(data))
                    .toList(),
              );
            }
          }},
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff4262A0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ImageUploads()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListTile(DocumentSnapshot data) {
    Product product = Product.fromDs(data);
    File? _photo;
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
                _photo != null
            ? Container(
                  //borderRadius: BorderRadius.zero,
                  child: Text("no image"),
                ) :
                Row(
                  children: [
                    Image.file(File(product.url), height: 90, width: 90, fit: BoxFit.fill,),
                    SizedBox(width: 15,),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
                          SizedBox(height: 7,),
                          Text(product.course,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff6D6D6D)),),
                          SizedBox(height: 9,),
                          Text('${product.price}원',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                        ],
                      ),
                    )
                  ],
                ),

            ],),
            height: 130,
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
