import 'package:app_project/home.dart';
import 'package:app_project/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MysApp());
}
// class error extends StatefulWidget {
//   const error({Key? key}) : super(key: key);
//
//   @override
//   State<error> createState() => _errorState();
// }
//
// class _errorState extends State<error> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'App name',
//         home: Builder(builder: (BuildContext context) {
//     }));
//   }
// }
