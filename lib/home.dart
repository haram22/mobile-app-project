import 'dart:io';
import 'package:app_project/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'detail.dart';
import 'package:image_picker/image_picker.dart';
import 'add.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final nameController = TextEditingController();
  final pricecount = TextEditingController();
  final courseController = TextEditingController();
  final detailController = TextEditingController();

  File? _photo;

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);
      await ref.getDownloadURL();
    } catch (e) {
      print('error occured');
    }
  }

  Future<void> downloadURLExample() async {
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';
    String url = await firebase_storage.FirebaseStorage.instance
        .ref(destination)
        .getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.home_outlined,)),
            IconButton(onPressed: (){}, icon: Icon(Icons.chat_outlined)),
            IconButton(onPressed: (){}, icon: Icon(Icons.favorite_border_outlined)),
            IconButton(onPressed: (){}, icon: Icon(Icons.settings_outlined),),

          ],),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(Icons.account_circle_outlined, color: Color(0xff4262A0),),
        title: Image(image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/HGU-Emblem-eng.svg/1024px-HGU-Emblem-eng.svg.png?20200507143923'),height: 50),
        actions: [
          IconButton(onPressed: () {

          },
              icon : Icon(Icons.search, color: Color(0xff4262A0),)
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
        onTap: ()
          //Navigator.pushNamed(this.context, detail.routeName, arguments: {''})
        async{
          Navigator.push(
            this.context,
            MaterialPageRoute(builder: (context) => _detail(data)),
          );
            await FirebaseFirestore.instance.collection('product').doc(nameController.text).set({
              'url' : _photo?.path,
              'name' : product.name,
              'course' : product.course,
              'price' : product.price,
              'count' : 0,
              'detail' : product.detail,
            }).toString();
            print('$_photo');
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
  Widget _detail(DocumentSnapshot data) {
    Product product = Product.fromDs(data);
    File? _photo;
    //final file = File(_photo?.path);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4262A0)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Image.file(File(product.url), height: 310, width: 350, fit: BoxFit.fill,),
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 20, bottom: 20, right: 20,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
              Divider(thickness: 2,),
              SizedBox(height: 7,),
              Text('장소 : ${product.course}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff6D6D6D)),),
              SizedBox(height: 9,),
              Text('${product.price}원',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
              SizedBox(height: 20,),
              Text('${product.detail}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
            ],
          ),),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 13.0, right: 20),
            child: OutlinedButton(
                      onPressed: (){}, child: Text("연락하기", style: TextStyle(
                      color: Colors.white, fontSize: 17
                    ),),
                      style: OutlinedButton.styleFrom(backgroundColor: Color(0xff4262A0),
                        fixedSize: Size(150,45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),),
          ),
          ],
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
  String detail;

  Product({required this.name, required this.course, required this.price, required this.url, required this.detail});
  factory Product.fromDs(DocumentSnapshot data) {
    return Product(
      name: data['name'] ?? '',
      course: data['course'] ?? '',
      price: data['price']?? '',
      url: data['url'] ?? '',
      detail: data['detail'] ?? '',
    );
  }
}