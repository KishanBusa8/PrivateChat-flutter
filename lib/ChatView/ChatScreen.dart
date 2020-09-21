import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:privatechat/ChatView/ChatMessage.dart';
import 'package:privatechat/Login/login.dart';



class ChatScreen extends StatefulWidget {
String Code;
String Name;
String MemberKey;
  ChatScreen({Key key,this.Code,this.Name,this.MemberKey}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChatScreenState();
  }
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {

  final TextEditingController _messageTextController = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  bool isscroolvisible = false;
  final _scrollcontroller = ScrollController();
  DatabaseReference rootRef = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    rootRef.child(widget.Code).onChildRemoved
        .listen((event) {
      rootRef.child(widget.Code).remove();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>
            Login()),
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                title: Text(
                  "Leave chat?",
                  style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                ),
                actions: <Widget>[
                  Container(
                    constraints: BoxConstraints(minWidth: 70),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      color: Colors.grey,
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins'
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(minWidth: 70),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.indigo,
                      child: Text(
                        "OK",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins'
                        ),
                      ),
                      onPressed: () {
                        rootRef.child(widget.Code).child("Members").child(widget.MemberKey).remove();
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              Login()),
                        );
                      },
                    ),
                  )
                ],
              );
            }
        );
      },
        child:
    Scaffold(appBar: _buildAppBar(context), body: _buildColumn(),backgroundColor: Colors.black,));
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Chat"),
          Text(widget.Name,style: TextStyle(fontSize: 14),),
        ],
      ),
      backgroundColor: Colors.white10,
    );
  }

  Widget _buildColumn() {
    return Column(
      children: <Widget>[
        new Flexible(
            child: StreamBuilder(
              stream: rootRef.child(widget.Code).child("Messages").onValue,
              builder: (context, snap) {
                if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
                  Map data = snap.data.snapshot.value;
                  List datas = [];
                  data.forEach((key,values) {
                    datas.add(values);
                  });
                  datas.sort((a,b) {
                    return a['created'].compareTo(b['created']);
                  });
                  print(datas);
                  datas = datas.reversed.toList();
                  return  new ListView.builder(
                    padding: new EdgeInsets.all(8.0),
                    reverse: true,
                    itemBuilder: (_, int index) => message(datas[index]),
                    itemCount: data.length,
                  );
                }
                else
                  return Center(
                    child: Container(),
                  );
              },
            ),),
        StreamBuilder(
          stream: rootRef.child(widget.Code).child("typing").onValue,
          builder: (context, snap) {
            if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
              Map data = snap.data.snapshot.value;
              print(data["name"]);
              return data["name"] != widget.Name && data["name"] != '' ? Container(
                padding: EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: Text(data["name"].toString() + " is typing..",style: TextStyle(color: Colors.white),),
              ) : SizedBox();
            }
            else
              return Center(
                child: Container(),
              );
          },
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 100,
              margin: EdgeInsets.only(bottom: 2),
              child:
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30),
                child:  new TextField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: _messageTextController,
                  minLines: 1,
                  maxLines: 3,
                  onChanged: (text) {
                    if (text != '') {
                      rootRef.child(widget.Code).child("typing").update({
                        "name" : widget.Name
                      });
                    } else {
                      rootRef.child(widget.Code).child("typing").update({
                        "name" : ''
                      });
                    }
                    print(text);
                  },
                  decoration:
                  new InputDecoration(border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none
                    ),
                  ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.all(12),
                      hintText: "Type here...", hintStyle: TextStyle(fontFamily: 'Nunito',color: HexColor.fromHex('#C5C5C5'),fontSize: 13 , fontWeight: FontWeight.w500)),
                ),
              ),
            ),
            GestureDetector(
              onTap:  () async {
                _publishMessage(_messageTextController.text);
              },
              child:
              ClipOval(
                child:
                Container(
                  child:  Material(
                    elevation: 5,
                    child: Ink(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Colors.deepPurple ,Colors.deepOrangeAccent],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1.3, 1.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp
                          ),
                          borderRadius: BorderRadius.circular(50.0)
                      ),
//                      splashColor: Colors.blue, // inkwell color
                      child: Icon(
                        Icons.send,color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

      ],
    );
  }
  Widget message (data) {
    return widget.Name == data["Sender"] ?Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    GestureDetector(
                      onLongPress: () {
                        
                        print(data["Message"]);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10.0, left: 90),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Colors.deepPurple, Colors.white38],
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
                                  margin: const EdgeInsets.only(top: 12 ,left: 12,right: 35,bottom: 12),
                                  child: new Text(data['Message'].toString(),style: TextStyle(fontSize: 18,color: Colors.white),),
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
      ),
    ) : Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
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
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(16),topRight:Radius.circular(16),topLeft: Radius.circular(19) )
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
      ),
    );
  }

  void _publishMessage(String text) {
    if (text != '') {
      print(widget.Name);
      var newkey = rootRef.child(widget.Code).push().key;
      String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
      DateTime now = DateTime.now();
      String time = new DateFormat.jm().format(now);
      rootRef.child(widget.Code).child("Messages").child(newkey).set({
        "Sender" : widget.Name,
        "Message" : text.trim(),
        "created" : int.parse(timestamp()),
        "Time" : "$time",
      });
      _messageTextController.clear();
      rootRef.child(widget.Code).child("typing").update({
        "name" : ''
      });
    }
    }

}
