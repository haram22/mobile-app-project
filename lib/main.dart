
import 'package:app_project/home.dart';
import 'package:app_project/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'detail.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(ShrineApp());
}

class ShrineApp extends StatelessWidget {
  const ShrineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shrine',
      home: HomePage(),
      initialRoute: 'home',
      routes: {
        'home': (context) => HomePage(),
        //'detail': (context) => detail(product: Product.fromDs(this.context),),
        'login' : (context) => LoginPage(),
      },
    );
  }
  // Route<dynamic>? _getRoute(RouteSettings settings) {
  //   if (settings.name == '/login') {
  //     return MaterialPageRoute<void>(
  //       settings: settings,
  //       builder: (BuildContext context) => LoginPage(),
  //       fullscreenDialog: true,
  //     );
  //   } else if (settings.name == '/detail'){
  //     return MaterialPageRoute<void>(
  //       settings: settings,
  //       builder:  (BuildContext context) => detail(),
  //       fullscreenDialog: true,
  //     );
  //   }
  //
  // }
}

