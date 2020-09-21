import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:privatechat/Login/login.dart';
import 'package:privatechat/main.dart';



class InitialPage extends StatefulWidget {
  InitialPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {


  @override
  void initState() {
    super.initState();
    loadInitialPage();
  }


  loadInitialPage() async {
    Timer(Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
              builder: (context) => Login()
          )
          , (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 180,
                height: 180,
                child: Image.asset('assets/images/icon.png'),
                margin: EdgeInsets.only(bottom: 20),
              ),
              Text(
                'Private Chat',
                style: TextStyle(
                  fontSize: 38,
                  letterSpacing: 3,
                  color: Colors.white,
                ),
              ),

            ],
          ),
        )
    );
  }
}