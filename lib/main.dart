import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:privatechat/intial.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Private Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: InitialPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  DatabaseReference rootRef = FirebaseDatabase.instance.reference();

  void _incrementCounter() {
    setState(() {
     var newkey = rootRef.child("code").push().key;
     String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
     DateTime now = DateTime.now();
     String time = new DateFormat.jm().format(now);
      rootRef.child("code").child(newkey).set({
        "Sender" : "name",
        "Message" : "Hey",
        "created" : int.parse(timestamp()),
        "Time" : "$time",
      });
//     rootRef.child("code").remove();
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body:Container(
        padding: EdgeInsets.only(bottom: 30),
        child: StreamBuilder(
          stream: rootRef.child("code").onValue,
          builder: (context, snap) {
            if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
              Map data = snap.data.snapshot.value;
              return  new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                reverse: false,
                itemBuilder: (_, int index) => message(data.values.elementAt(index)),
                itemCount: data.length,
              );
            }
            else
              return Center(
                child: Container(),
              );
          },
        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget message (data) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 90.0, left: 10),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Colors.white38, Colors.black38],
//                    begin: Alignment.topLeft,
//                    end: Alignment.bottomRight,
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1.2, 1.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp

                          ),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16),topRight:Radius.circular(16),topLeft: Radius.circular(19) )
                      ),
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              new Container(
                                margin: const EdgeInsets.only(top: 20 ,left: 12,right: 35,bottom: 12),
                                child: new Text(data['Message'].toString(),style: TextStyle(fontSize: 18,color: Colors.white),),
                              ),
                              Positioned(
                                top: 5,left: 12,
                                child: Container(
                                  child: new Text(data['Sender'].toString(),style: TextStyle(fontSize: 11,color: Colors.white),),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ],
    );
  }
}
