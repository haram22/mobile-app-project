import 'package:app_project/login.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'chatRoomList.dart';
import 'favoritelist.dart';

class setting extends StatefulWidget {
  const setting({Key? key}) : super(key: key);

  @override
  State<setting> createState() => _settingState();
}

class _settingState extends State<setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage()),
              );
            }, icon: Icon(Icons.home_outlined,)),
            IconButton(onPressed: (){
              Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatRoomList()),
          );
            }, icon: Icon(Icons.chat_outlined)),
            IconButton(onPressed: (){
               Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>  FavoriteList()),
          );
            }, icon: Icon(Icons.favorite_border_outlined)),
            IconButton(onPressed: (){

            }, icon: Icon(Icons.settings_outlined),),

          ],),
      ),
      appBar: AppBar(
        centerTitle: true,
        leading: Text(''),
       backgroundColor: Color(0xff4262A0),
        elevation: 1,
        title:  Text('환경설정',textAlign: TextAlign.center),),
      body: Center(
      child : ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xff4262A0))
        ),
        onPressed: (){  Navigator.push(
            this.context,
            MaterialPageRoute(builder: (context) => LoginPage()));}, child: Text('LOGOUT',style: TextStyle(fontSize: 30),
            ))
      ),
    );
  }
}
