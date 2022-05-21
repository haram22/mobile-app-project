import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'imageP.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class ImageUploads extends StatefulWidget {
  ImageUploads({Key? key}) : super(key: key);

  @override
  _ImageUploadsState createState() => _ImageUploadsState();
}

class _ImageUploadsState extends State<ImageUploads> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final picker = ImagePicker();
  final nameController = TextEditingController();
  final pricecount = TextEditingController();
  final courseController = TextEditingController();

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

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
    } catch (e) {
      print('error occured');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[600],
        title: Text("Add", style: TextStyle(color: Colors.white),),
        leading: Container(
          width: 140,
          alignment: Alignment.centerRight,
          child: TextButton(
            style: TextButton.styleFrom(),
            child: Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 12)),
            onPressed: (){
              Navigator.pop(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
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
                  child: Text('save',style: TextStyle(color: Colors.white),))
            ],
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: ClipRect(
                //backgroundColor: Colors.grey[200],
                child: _photo != null
                    ? Container(
                  //borderRadius: BorderRadius.zero,
                  child: Image.file(
                    _photo!,
                    height: 300,
                    fit: BoxFit.fill,
                  ),
                )
                    : Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      //borderRadius: BorderRadius.circular(0)
                    ),
                    height: 300,
                    child: Image.network('http://handong.edu/site/handong/res/img/logo.png')
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Spacer(),
              IconButton(onPressed: (){
                _showPicker(context);
              }, icon: Icon(Icons.camera_alt))
            ],
          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
            child: TextFormField(
              controller: nameController,
              // onChanged: (value) {
              //   print('onChanged: ' + value);
              // },
              // onEditingComplete: () {
              //   print('onEditingComplete : ' + _nameController.text);
              // },
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                border: OutlineInputBorder(),
                hintText: 'Product Name',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
            child: TextFormField(
              controller: pricecount,
              // onChanged: (value) {
              //   print('onChanged: ' + value);
              // },
              // onEditingComplete: () {
              //   print('onEditingComplete : ' + _priceController.text);
              // },
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                border: OutlineInputBorder(),
                hintText: 'Price',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
            child: TextFormField(
              controller: courseController,
              // onChanged: (value) {
              //   print('onChanged: ' + value);
              // },
              // onEditingComplete: () {
              //   print('onEditingComplete : ' + _descriptionController.text);
              // },
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                border: OutlineInputBorder(),
                hintText: 'Description',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}