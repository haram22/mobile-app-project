// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// //import http package manually
//
// class ImageUpload extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() {
//     return _ImageUpload();
//   }
// }
//
// class _ImageUpload extends State<ImageUpload>{
//
//   late File uploadimage; //variable for choosed file
//
//   Future<void> chooseImage() async {
//     ImagePicker picker = ImagePicker();
//     final choosedimage = await picker.getImage(source: ImageSource.camera);
//     //var choosedimage = await ImagePicker.getImage(source: ImageSource.gallery);
//     //set source: ImageSource.camera to get image from camera
//     setState(() {
//       uploadimage = choosedimage as File;
//     });
//   }
//
//   Future<void> uploadImage() async {
//     //show your own loading or progressing code here
//
//     String uploadurl = "gs://real-final-57b9f.appspot.com/playground";
//     //dont use http://localhost , because emulator don't get that address
//     //insted use your local IP address or use live URL
//     //hit "ipconfig" in windows or "ip a" in linux to get you local IP
//
//     try{
//       List<int> imageBytes = uploadimage.readAsBytesSync();
//       String baseimage = base64Encode(imageBytes);
//       //convert file image to Base64 encoding
//       var response = await http.post(
//           // uploadurl.parse(uploadurl),
//         uploadurl,
//           body: {
//             'image': baseimage,
//           }
//       );
//       if(response.statusCode == 200){
//         var jsondata = json.decode(response.body); //decode json data
//         if(jsondata["error"]){ //check error sent from server
//           print(jsondata["msg"]);
//           //if error return from server, show message from server
//         }else{
//           print("Upload successful");
//         }
//       }else{
//         print("Error during connection to server");
//         //there is error during connecting to server,
//         //status code might be 404 = url not found
//       }
//     }catch(e){
//       print("Error during converting to Base64");
//       //there is error during converting file image to base64 encoding.
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Upload Image to Server"),
//         backgroundColor: Colors.deepOrangeAccent,
//       ),
//       body:Container(
//         height:300,
//         alignment: Alignment.center,
//         child:Column(
//           mainAxisAlignment: MainAxisAlignment.center, //content alignment to center
//           children: <Widget>[
//             Container(  //show image here after choosing image
//                 child:uploadimage == null?
//                 Container(): //if uploadimage is null then show empty container
//                 Container(   //elese show image here
//                     child: SizedBox(
//                         height:150,
//                         child:Image.file(uploadimage) //load image from file
//                     )
//                 )
//             ),
//
//             Container(
//               //show upload button after choosing image
//                 child:uploadimage == null?
//                 Container(): //if uploadimage is null then show empty container
//                 Container(   //elese show uplaod button
//                     child:RaisedButton.icon(
//                       onPressed: (){
//                         uploadImage();
//                         //start uploading image
//                       },
//                       icon: Icon(Icons.file_upload),
//                       label: Text("UPLOAD IMAGE"),
//                       color: Colors.deepOrangeAccent,
//                       colorBrightness: Brightness.dark,
//                       //set brghtness to dark, because deepOrangeAccent is darker coler
//                       //so that its text color is light
//                     )
//                 )
//             ),
//
//             Container(
//               child: RaisedButton.icon(
//                 onPressed: (){
//                   chooseImage(); // call choose image function
//                 },
//                 icon:Icon(Icons.folder_open),
//                 label: Text("CHOOSE IMAGE"),
//                 color: Colors.deepOrangeAccent,
//                 colorBrightness: Brightness.dark,
//               ),
//             )
//           ],),
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 32,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xffFDCF09),
                child: _photo != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(
                    _photo!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.fitHeight,
                  ),
                )
                    : Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(50)),
                  width: 100,
                  height: 100,
                  child: Image.network('http://handong.edu/site/handong/res/img/logo.png')
                ),
              ),
            ),
          )
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