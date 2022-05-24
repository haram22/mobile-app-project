import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageUploads extends StatefulWidget {
  ImageUploads({Key? key}) : super(key: key);

  @override
  _ImageUploadsState createState() => _ImageUploadsState();
}

class _ImageUploadsState extends State<ImageUploads> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final nameController = TextEditingController();
  final pricecount = TextEditingController();
  final courseController = TextEditingController();

  File? _photo;

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
      //await ref.getDownloadURL();
    } catch (e) {
      print('error occured');
    }
  }
  Future<void> downloadURLExample() async{
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';
    String url = await firebase_storage.FirebaseStorage.instance
    .ref(destination)
    .getDownloadURL();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("작성하기", style: TextStyle(color: Colors.black),),
        leading: IconButton(onPressed: (){
          Navigator.pop(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }, icon: Icon(Icons.arrow_back, color: Colors.black),),
        // leading: Container(
        //   width: 140,
        //   alignment: Alignment.centerRight,
        //   child: TextButton(
        //     style: TextButton.styleFrom(),
        //     child: Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 12)),
        //     onPressed: (){
        //       Navigator.pop(
        //         context,
        //         MaterialPageRoute(builder: (context) => HomePage()),
        //       );
        //     },
        //   ),
        // ),
        actions: [
          TextButton(
              onPressed: () async{
                await FirebaseFirestore.instance.collection('product').doc(nameController.text).set({
                  'url' : _photo?.path,
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
              child: Text('완료',style: TextStyle(color: Color(0xff4262A0)),))
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
                      color: Colors.white,
                      //borderRadius: BorderRadius.circular(0)
                    ),
                    height: 300,
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: (){
                          _showPicker(context);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_rounded, color: Color(0xff4262A0), size: 30,),
                            SizedBox(height: 10,),
                            Text("사진 추가하기", style: TextStyle(color: Color(0xff4262A0)),)
                          ],
                        )
                    )
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          // Row(
          //   children: [
          //     Spacer(),
          //     IconButton(onPressed: (){
          //       _showPicker(context);
          //     }, icon: Icon(Icons.camera_alt))
          //   ],
          // ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff4262A0))),
                border: OutlineInputBorder(),
                hintText: '글 제목',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
            child: TextFormField(
              controller: courseController,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff4262A0))),
                border: OutlineInputBorder(),
                hintText: '거래 장소',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
            child: TextFormField(
              controller: pricecount,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff4262A0))),
                border: OutlineInputBorder(),
                hintText: '₩ 희망 거래 가격',
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