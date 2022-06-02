import 'package:app_project/home.dart';
import 'package:app_project/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MysApp());
  
}


class Gopage extends StatefulWidget {
  const Gopage({Key? key}) : super(key: key);

  @override
  _GopageState createState() => _GopageState();
}

class _GopageState extends State<Gopage> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;
    if (user != null) {
      User loggedInUser = user;
      print('AUTO LOG IN SUCCESS(main.dart): Signed in As:${loggedInUser.uid}');
      return HomePage();
    } else {
      return LoginPage();
    }
  }
}