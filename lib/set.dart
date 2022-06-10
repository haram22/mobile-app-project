import 'package:flutter/material.dart';

class setting extends StatefulWidget {
  const setting({Key? key}) : super(key: key);

  @override
  State<setting> createState() => _settingState();
}

class _settingState extends State<setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Text(''),
        title: Text("환경설정", style: TextStyle(color: Color(0xff4262A0),fontSize: 40),),
      ),
      body: Column(children: [

      ]),
    );
  }
}
