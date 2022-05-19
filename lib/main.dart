import 'package:app_project/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await firebase_core.Firebase.initializeApp();
  runApp(LoginPage());
}
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   //await firebase_core.Firebase.initializeApp();
//   runApp(Login());
// }
