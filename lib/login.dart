// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  late User currentUser;
  String name = "";
  String email = "";
  String url = "";

  Future<String> googleSingIn() async {
    final GoogleSignInAccount? account = await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth = await account?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User user = authResult as User;
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    currentUser = await _auth.currentUser!;
    assert(user.uid == currentUser.uid);
    setState(() {
      email = user.email!;
      url = user.photoURL!;
      name = user.displayName!;
    });
    return '구글 로그인 성공: $user';
  }

  void googleSignOut() async {
    await _auth.signOut();
    await googleSignIn.signOut();
    setState(() {
      email = "";
      url = "";
      name = "";
    });
    print("User Sign Out");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              const SizedBox(height: 180.0),
              Column(
                children: <Widget>[
                Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/HGU-Emblem-eng.svg/1024px-HGU-Emblem-eng.svg.png?20200507143923', height: 113,),
                SizedBox(height: 57,),
                  const SizedBox(height: 16.0),
                  SizedBox(height: 100.0),
                  email == "" ? Container()
                      : Column(
                    children: <Widget>[
                      Image.network(url),
                      Text(name),
                      Text(email),
                    ],
                  ),
                  OutlinedButton(
                    onPressed: () {
                      if (email == "") {
                        googleSingIn();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      }
                      else googleSignOut();
                    },
                    child: Container(
                      height: 55,
                        width: 325,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Google Login',
                              style: TextStyle(color: Colors.white),)
                          ],
                        )),
                    style: OutlinedButton.styleFrom(backgroundColor: Color(0xff4262A0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                  ),)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class account extends StatefulWidget {
  const account({Key? key}) : super(key: key);

  @override
  State<account> createState() => _accountState();
}

class _accountState extends State<account> {

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    // final AuthService _auth = AuthService();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
                if(_LoginPageState().email == "") {
                  await _auth.signOut();
                } else {
                  await _auth.signOut();
                }

              }, icon: Icon(Icons.exit_to_app))
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'home.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Dd"),
//       ),
//       body: Column(
//         children: [
//                 SizedBox(height: 197,),
//                 Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/HGU-Emblem-eng.svg/1024px-HGU-Emblem-eng.svg.png?20200507143923', height: 113,),
//                 SizedBox(height: 57,),
//                 //TextButton(onPressed: (){}, child: Text("Dd"))
//                 // Container(
//                 //   //height: 30,
//                 //     child: OutlinedButton(
//                 //         onPressed: (){},
//                 //         child: Text("Google")))
//                 //OutlinedButton(onPressed: (){}, child: Text("Sign with Google"),)
//
//         ],
//       ),
//     );
//   }
// }
//
// class Login extends StatefulWidget {
//   const Login({Key? key}) : super(key: key);
//
//   @override
//   State<Login> createState() => _LoginState();
// }
//
// class _LoginState extends State<Login> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn googleSignIn = GoogleSignIn();
//   late User currentUser;
//   String name = "";
//   String email = "";
//   String url = "";
//
//   Future<String> googleSingIn() async {
//     final GoogleSignInAccount? account = await googleSignIn.signIn();
//     final GoogleSignInAuthentication? googleAuth = await account?.authentication;
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth?.accessToken,
//       idToken: googleAuth?.idToken,
//     );
//     final UserCredential authResult = await _auth.signInWithCredential(credential);
//     final User user = authResult as User;
//     assert(!user.isAnonymous);
//     assert(await user.getIdToken() != null);
//     currentUser = await _auth.currentUser!;
//     assert(user.uid == currentUser.uid);
//     setState(() {
//       email = user.email!;
//       url = user.photoURL!;
//       name = user.displayName!;
//     });
//     return '구글 로그인 성공: $user';
//   }
//
//   void googleSignOut() async {
//     await _auth.signOut();
//     await googleSignIn.signOut();
//     setState(() {
//       email = "";
//       url = "";
//       name = "";
//     });
//     print("User Sign Out");
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: double.infinity,
//       width: double.infinity,
//       color: Colors.white,
//       child: Column(
//         children: [
//           SizedBox(height: 197,),
//           Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/HGU-Emblem-eng.svg/1024px-HGU-Emblem-eng.svg.png?20200507143923', height: 113,),
//           SizedBox(height: 157,),
//           OutlinedButton(
//             onPressed: () {
//               if (email == "") {
//                 googleSingIn();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomePage()),
//                 );
//               }
//               else googleSignOut();
//             },
//             child: Container(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Text('Google Login',
//                       style: TextStyle(color: Colors.black),)
//                   ],
//                 )),
//             style: OutlinedButton.styleFrom(backgroundColor: Colors.red[300]),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class login extends StatefulWidget {
//   const login({Key? key}) : super(key: key);
//
//   @override
//   State<login> createState() => _loginState();
// }
//
// class _loginState extends State<login> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(""),
//       ),
//       body: Column(
//         children: [
//           Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/HGU-Emblem-eng.svg/1024px-HGU-Emblem-eng.svg.png?20200507143923', height: 113,),
//         ],
//       ),
//     );
//   }
// }
