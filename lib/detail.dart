//import 'dart:html';

import 'package:app_project/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



class detail extends StatefulWidget {
  // const detail({Key? key, required product}) : super(key: key);
  const detail ({Key? key}) : super(key: key);

  @override
  State<detail> createState() => _detailState();
}

class _detailState extends State<detail> {
  FirebaseAuth auth = FirebaseAuth.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final nameController = TextEditingController();
  final pricecount = TextEditingController();
  final courseController = TextEditingController();

  //File? _photo;

  // Future<void> downloadURLExample() async {
  //   //final fileName = basename(_photo!.path);
  //   final destination = 'files/$fileName';
  //   String url = await firebase_storage.FirebaseStorage.instance
  //       .ref(destination)
  //       .getDownloadURL();
  // }
  @override
  Widget build(BuildContext context) {
    //Product name = ModalRoute.of(context)!.settings.arguments as Product;
    //Product name = ModalRoute.of(context)!.settings.arguments as Product;
    // final args =
    // ModalRoute.of(context)!.settings.arguments as SecondScreenArguments;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Image(image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/HGU-Emblem-eng.svg/1024px-HGU-Emblem-eng.svg.png?20200507143923'),height: 50),
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back_ios, color: Color(0xff4262A0)))
      ),
      body: Text('dd',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
      // Column(
      //   children: [
      //
      //     SizedBox(height: 7,),
      //   ],
      // ),
      //body: Text('$product.name'),
    );
  }
}
