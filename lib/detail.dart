
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:app_project/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// class Product {
//   String name;
//   String course;
//   String price;
//   String url;
//
//   Product({required this.name, required this.course, required this.price, required this.url});
//   factory Product.fromDs(DocumentSnapshot data) {
//     return Product(
//       name: data['name'] ?? '',
//       course: data['course'] ?? '',
//       price: data['price']?? '',
//       url: data['url'] ?? '',
//     );
//   }
// }
class Product {
  final String name;
  final String course;
  final String price;
  final String url;

  Product(this.name, this.course, this.price, this.url);

// Product({required this.name, required this.course, required this.price, required this.url});
// factory Product.fromDs(DocumentSnapshot data) {
//   return Product(
//     name: data['name'] ?? '',
//     course: data['course'] ?? '',
//     price: data['price']?? '',
//     url: data['url'] ?? '',
//   );
// }
}

class detailPage extends StatefulWidget {
  const detailPage({Key? key}) : super(key: key);

  @override
  State<detailPage> createState() => _detailPageState();
}

class _detailPageState extends State<detailPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      home: TodosScreen(
        todos: List.generate(
          20,
              (i) => Product(
            'Product $i',
            '$Product.name',
            'ddd',
            'dddd'
            //'A description of what needs to be done for Todo $i', name: 'sss', course: 'sssss', price: '123', url: 'avc',
          ),
        ),
      ),
      initialRoute: 'home',
      routes: {
        'home': (context) => TodosScreen(todos: []),
        //'detail': (context) => detail(product: Product.fromDs(this.context),),
      },
    );
  }
}
class TodosScreen extends StatelessWidget {
  final List<Product> todos;

  TodosScreen({Key? key, required this.todos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4262A0),
        // leading: IconButton(onPressed: (){
        //   Navigator.pop(context,);
        // }, icon: Icon(Icons.arrow_back_ios), color: Colors.white,),
        title: Text(''),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todos[index].name),
            // 사용자가 ListTile을 선택하면, DetailScreen으로 이동합니다.
            // DetailScreen을 생성할 뿐만 아니라, 현재 todo를 같이 전달해야
            // 한다는 것을 명심하세요.
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(todo: todos[index], key: key,),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
class DetailScreen extends StatelessWidget {
  // Todo를 들고 있을 필드를 선언합니다.
  final Product todo;

  // 생성자는 Todo를 인자로 받습니다.
  DetailScreen({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // UI를 그리기 위해 Todo를 사용합니다.
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(todo.course),
      ),
    );
  }
}






// class detail extends StatefulWidget {
//   // const detail({Key? key, required product}) : super(key: key);
//   const detail ({Key? key}) : super(key: key);
//
//   @override
//   State<detail> createState() => _detailState();
// }
// class _detailState extends State<detail> {
//   FirebaseAuth auth = FirebaseAuth.instance;
//   firebase_storage.FirebaseStorage storage =
//       firebase_storage.FirebaseStorage.instance;
//   final ImagePicker _picker = ImagePicker();
//   final nameController = TextEditingController();
//   final pricecount = TextEditingController();
//   final courseController = TextEditingController();
//   File? _photo;
//
//   Future<void> downloadURLExample() async {
//     final fileName = basename(_photo!.path);
//     final destination = 'files/$fileName';
//     String url = await firebase_storage.FirebaseStorage.instance
//         .ref(destination)
//         .getDownloadURL();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // final args_fromdetail = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;
//     // final arguments = ModalRoute.of(context)!.settings.arguments as Map;
//     // final String args= arguments['name'];
//     // final String price= arguments['price'];
//     return Scaffold(
//       appBar: AppBar(
//           backgroundColor: Colors.white,
//           title: Image(image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/HGU-Emblem-eng.svg/1024px-HGU-Emblem-eng.svg.png?20200507143923'),height: 50),
//           leading: IconButton(onPressed: (){
//             Navigator.pop(context);
//           }, icon: Icon(Icons.arrow_back_ios, color: Color(0xff4262A0)))
//       ),
//       body: Column(
//         children: [
//           Text('ddd')
//           // Text(product.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
//           // SizedBox(height: 7,),
//           // Text(product.course,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff6D6D6D)),),
//           // SizedBox(height: 9,),
//           // Text('${product.price}원',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
//         ],
//       )
//       // StreamBuilder<QuerySnapshot>(
//       //   stream: FirebaseFirestore.instance
//       //       .collection('product')
//       //       .snapshots(),
//       //
//       //   builder: (context, snapshot)
//       //   {
//       //     if (!snapshot.hasData) {
//       //       return const CircularProgressIndicator();
//       //     } else {
//       //       if (snapshot.data!.size == 0) {
//       //         return Center(
//       //           child: Container(
//       //               width: 220,
//       //               child: const Text('There is no data in Firebase!\n Add data using Floating button')),
//       //         );
//       //       } else {
//       //         return Column(
//       //           children: snapshot.data!.docs
//       //               .map((DocumentSnapshot data) => _builddetail(data))
//       //               .toList(),
//       //         );
//       //       }
//       //     }},
//       // ),
//     );
//   }
//   // Widget _builddetail(DocumentSnapshot data) {
//   //   Product product = Product.fromDs(data);
//   //   //final file = File(_photo?.path);
//   //   return Card(
//   //     child: ListTile(
//   //       shape: Border(
//   //       ),
//   //       onTap: () {
//   //         },
//   //       title:
//   //       Container(
//   //         child: Column(
//   //           mainAxisAlignment: MainAxisAlignment.center,
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           children: [
//   //             //_photo != null
//   //             Row(
//   //               children: [
//   //                 // Image.file(File(product.url), height: 90, width: 90, fit: BoxFit.fill,),
//   //                 SizedBox(width: 15,),
//   //                 Container(
//   //                   child: Column(
//   //                     mainAxisAlignment: MainAxisAlignment.start,
//   //                     crossAxisAlignment: CrossAxisAlignment.start,
//   //                     children: [
//   //                       Text(product.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
//   //                       SizedBox(height: 7,),
//   //                       Text(product.course,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff6D6D6D)),),
//   //                       SizedBox(height: 9,),
//   //                       Text('${product.price}원',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
//   //                     ],
//   //                   ),
//   //                 )
//   //               ],
//   //             ),
//   //           ],),
//   //         height: 130,
//   //       ),
//   //     ),
//   //   );
//   // }
// }
