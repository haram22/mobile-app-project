import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'add.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final nameController = TextEditingController();
  final courseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        leading: IconButton(
            onPressed: () async{
              await auth.signOut().whenComplete(() {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginPage())
                );
                print('Sign out');
              });
            },
            icon: const Icon(Icons.person)
        ),
        title: Text("Main"),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImageUploads()),
            );
          },
              icon : Icon(Icons.add)
          )
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('object').snapshots(),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => addPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListTile(DocumentSnapshot data) {
    Product product = Product.fromDs(data);

    return Card(
      child: ListTile(
          shape: Border(
          ),
          onTap: () {
          },
          leading: Image(image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/HGU-Emblem-eng.svg/1024px-HGU-Emblem-eng.svg.png?20200507143923'),height: 100,width: 90,),
          title:
          Container(
            child: Column(children: [
              Text(product.name,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 40)),
              Text(product.course,style: TextStyle(fontWeight: FontWeight.bold),),
            ],),
            height: 100,
          )
      ),

    );

  }
}
class addPage extends StatefulWidget{
  addPageState createState()=> addPageState();
}

class addPageState extends State<addPage>{
  final nameController = TextEditingController();
  final pricecount = TextEditingController();
  final courseController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("작성하기",style: TextStyle(fontWeight: FontWeight.bold),),
        leading: IconButton(
          icon : Icon(Icons.cancel),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Row(
            children: [
              TextButton(onPressed: () async{
                await FirebaseFirestore.instance.collection('object').doc(nameController.text).set({
                  'name' : nameController.text,
                  'course' : courseController.text,
                  'price' : pricecount.text,
                  'count' : 0

                }).whenComplete(() {
                  nameController.clear();
                  courseController.clear();
                  Navigator.of(context).pop();;
                  print('pruduct add');
                });
              },
                  child: Text('완료',style: TextStyle(color: Colors.red),))
            ],
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Row(children: [

            ],),
          ),
          SizedBox(height: 10.0),

          SizedBox(height: 10.0),
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
                hintText:'글 제목'
            ),
          ),
          SizedBox(height: 10.0),
          TextFormField(
              controller: courseController,
              decoration: const InputDecoration(
                  hintText: '거래 장소'
              )
          ),
          SizedBox(height: 10.0),
          TextFormField(
              controller: pricecount,
              decoration: const InputDecoration(
                  hintText: '₩ 희망 거래 가격'
              )
          ),
        ],
      ),
    );
  }
}

class Product {
  String name;
  String course;
  int count;

  Product({required this.name, required this.course, required this.count});

  factory Product.fromDs(DocumentSnapshot data) {
    return Product(
      name: data['name'] ?? '',
      course: data['course'] ?? '',
      // description: data['description'],
      count: data['count'] ?? 0,
    );
  }
}



  