import 'dart:io';
import 'package:app_project/chat.dart';
import 'package:app_project/favoritelist.dart';
import 'package:app_project/set.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chatRoomList.dart';
import 'detail.dart';
import 'package:image_picker/image_picker.dart';
import 'add.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'login.dart';
import 'googlemap.dart';
import 'kakao.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final TextEditingController contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  FirebaseAuth auth = FirebaseAuth.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
      User? user =  FirebaseAuth.instance.currentUser;
  final nameController = TextEditingController();
  final pricecount = TextEditingController();
  final courseController = TextEditingController();
  final detailController = TextEditingController();
  

 @override
  void initState() {
    super.initState();
  }
  
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
    FirebaseAuth.instance.authStateChanges().listen((user) {
  if (user == null) {
  } else {}
});

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
            IconButton(onPressed: () {
               Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FavoriteList()),
          );
            },
             icon: Icon(Icons.favorite_border_outlined)),
            IconButton(onPressed: (){
               Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => setting()),
          );
            }, icon: Icon(Icons.settings_outlined),),

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
        elevation: 4,
      ),
      body: _listTile(),
     //  body: StreamBuilder(
     //    stream: FirebaseAuth.instance.authStateChanges(),
     //    builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
     //      if(!snapshot.hasData) {
     //        return MysApp();
     //      } else {
     //        return ListView(
     //          children: [
     //            _listTile()
     //          ],
     //        );
     //      }
     //    }
     // ), // ??? ????????? ????????? ?????? ???????????? ???????????? ??? ??? ????????? ????????? ?????? ????????? ??????????????? StreamBuilder ?????? ?????? ???????????? ?????? _listtile??? body??? ????????? ???
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

Widget _listTile() {
  return  StreamBuilder<QuerySnapshot>(
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
                        Text('${product.price}???',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
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
  bool isLiked = true;
  int likes = 2;
  Widget _detail(DocumentSnapshot data) {
    Product product = Product.fromDs(data);
      // bool isLiked = false;
      // int likes = 2;
    File? _photo;
    //final file = File(_photo?.path);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () {
           Navigator.push(
            this.context,
            MaterialPageRoute(builder: (context) => build(context)),
          );
          },
        ),
        backgroundColor: Color(0xff4262A0)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 10),
              child: Image.file(File(product.url), height: 310, width: 350, fit: BoxFit.fill,),
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 20, bottom: 20, right: 20,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Divider(thickness: 2,),
              Text(product.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22)),
              SizedBox(height:20,),
             Row(children: [
                Column(children: [
                  Text('${product.addressnumber}  ${product.streetAddress}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff6D6D6D)),),
                 // SizedBox(height: 10,),
                ],),
             ],),
              Stack(
                children: [
                  Row(
                    children: [
                      Text('${product.course}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff6D6D6D)),),
                      SizedBox(width: 5,),
                            TextButton(onPressed: () { Navigator.push(
                        this.context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                      );}
                            , child: Text('????????????'))
                    ],
                  )
                ],
              ),
              //SizedBox(height: 9,),
              //Text('${product.price}???',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
              SizedBox(height: 20,),
              Text('${product.detail}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
            ],
          ),)
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 10,),
            // IconButton(
            //   onPressed: () {
            //     setState(() {
            //       if (isLiked) {
            //         likes--;
            //         isLiked = false;
            //       } else {
            //         likes++;
            //         isLiked = true;
            //       }
            //     });
            //   },
            //   icon: Icon(
            //     isLiked ? Icons.star : Icons.star_outline,
            //     color: Colors.redAccent,
            //   ),
            // ),
            IconButton(
              onPressed: ()
              async{
                await FirebaseFirestore.instance.collection('favorite').doc(product.name).set({
                  'favorite': product.name,
                  //'favorite': product.price,
                });
                setState(() {
                  if (isLiked) {
                    likes--;
                    isLiked = false;
                  } else {
                    likes++;
                    isLiked = true;
                  }
                });
              },
              icon: Icon(
                isLiked? Icons.favorite : Icons.favorite_border,
                color: Colors.red[300],
                size: 27,
              ),
            ),
            Text('${product.price} ???',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 13.0, right: 20),
            child: OutlinedButton(
                      onPressed: (){
                        Navigator.push(
            this.context,
            MaterialPageRoute(builder: (context) => _chatPage(data)),
          );
                      }, 
                       child: Text("????????????", style: TextStyle(

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

   Widget _chatPage(DocumentSnapshot data) {
    Product product = Product.fromDs(data);
    File? _photo;
    //final file = File(_photo?.path);
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black),
          onPressed: () {
           Navigator.push(
            this.context,
            MaterialPageRoute(builder: (context) => _detail(data)),
          );
          },
        ),
        title: Text('${product.name}',style: TextStyle(color: Colors.black),)
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            width: double.infinity,
            child:  Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: TextFormField(
                              onTap: (){
                FocusManager.instance.primaryFocus?.unfocus(); // ????????? ?????? ?????????
              },
                              controller: contentController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              String cid = DateTime.now().toString();
                              await FirebaseFirestore.instance
                                  .collection('${product.name}')
                                  .doc(cid)
                                  .set({
                                'user' : user,
                                'content': contentController.text,
                                'cid': cid,
                              }).whenComplete(() {
                                print('chat add');
                                contentController.clear();
                              });
                              FirebaseFirestore.instance
                                  .collection('ProductList')
                                  .doc(product.name)
                                  .set({
                                'name' : product.name,
                                'Place' : product.course
                              }).whenComplete(() {
                                print('ProductList add');
                                contentController.clear();
                              });
                            },
                            icon: Icon(
                              Icons.send,
                              color: Colors.blueGrey,
                            )),
                      ],
                    )
          ),
      ),
      body: Column(children: [
        _body(data),
        
      ],)
    );
  }
  Widget _body(DocumentSnapshot data) {
    Product product = Product.fromDs(data);
    return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('${product.chat}')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            if (snapshot.data!.size == 0) {
              return Center(
                child: Container(
                    width: 220,
                    child: const Text('\n \n \n \n \n \n \n\n\n\n\n\n\n\n\n           ????????? ????????? ???????????????! \n')),
              );
            } else {
              return Column(
                children: snapshot.data!.docs
                    .map((DocumentSnapshot data) => _buildChat(data))
                    .toList(),
                    
              );
            }
          }
                });
  }


   Widget _buildChat(DocumentSnapshot data) {
    Chat _chat = Chat.fromDs(data);

    return _chat.user == "???"
       ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                child: InkWell(
                  child: Card(
                    elevation: 4,
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        _chat.content,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        )
      ],
    )
    : Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                child: InkWell(
                  child: Card(
                    elevation: 4,
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        _chat.content,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class Product {
  String name;
  String course;
  String price;
  String url;
  String detail;
  String chat;
  String content;
  String addressnumber;
  String streetAddress;
  String latitude;
  String longitude;

  Product({required this.name, required this.course, required this.price, required this.url, required this.detail, required this.chat, required this.content, required this.addressnumber, required this.streetAddress, required this.latitude, required this.longitude});
  factory Product.fromDs(DocumentSnapshot data) {
    return Product(
      name: data['name'] ?? '',
      course: data['course'] ?? '',
      price: data['price']?? '',
      url: data['url'] ?? '',
      detail: data['detail'] ?? '',
      chat : data['chat'] ?? '',
      content: data['content'] ?? '',
      addressnumber : data['addressnumber'] ??'',
      streetAddress : data['street address'] ??'',
      latitude: data['latitude'] ?? '',
      longitude: data['longitude'] ?? ''
    );
  }
}

class Chat {
  String user;
  String content;
  String cid;

  Chat({required this.user, required this.content, required this.cid});

  factory Chat.fromDs(DocumentSnapshot data) {
    return Chat(  
      user: data['user'] ?? '',
      content: data['content'] ?? '',
      cid: data['cid'] ?? '',
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