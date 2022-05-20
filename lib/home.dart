import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FirebaseAuth auth = FirebaseAuth.instance;
    final nameController = TextEditingController();
  final description = TextEditingController();
  final courseController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/HGU-Emblem-eng.svg/1024px-HGU-Emblem-eng.svg.png?20200507143923', height: 57,),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search))
        ],
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
              return GridView.count(
                crossAxisCount: 1,
                children: snapshot.data!.docs
                    .map((DocumentSnapshot data) => _buildListTile(data))
                    .toList(),
              );
            }
          }},
      ),
    );
  }
  Widget detailkk(DocumentSnapshot data) {
    Product user = Product.fromDs(data);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("Detail"),
        leading: IconButton(
        icon : Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
              Row(
                children: [

                    IconButton(onPressed:() {
                    
                  } ,
                   icon: Icon(Icons.delete)),
                ],
              )
            ],
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 2 / 1,
            child: Stack(
              children: <Widget>[
                Positioned(left: 0,right: 0,bottom: 0,top: 0,
                  child: Container(
                    child: Image(image: AssetImage("assets/logo.png")))
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name),
              SizedBox(height: 10.0),
             TextFormField(
                    controller: courseController,
                    decoration: const InputDecoration(
                        hintText: 'Course'
                    ),
                  ),
              SizedBox(height: 10.0),
              TextFormField(
                    controller: description,
                    decoration: const InputDecoration(
                        hintText: 'description'
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildListTile(DocumentSnapshot data) {
    Product user = Product.fromDs(data);
final ThemeData theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 100,
      child: Row(
          children: <Widget>[
            AspectRatio(
                    aspectRatio: 12 / 10,
                    child: Hero(
                      tag: user.name,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image(image: AssetImage("assets/logo.png"),fit: BoxFit.cover,)
                      ),
                    ),
                  ),
                  Text(user.name),
            Expanded(
              child:Container(
                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(user.course),
                    Container(
                      child: TextButton(
                        child : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text("more"),
                          ],
                        ),
                        onPressed: (){
                          Navigator.pushNamed(
                            context, '/detail',
                            arguments: data
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
    ));
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