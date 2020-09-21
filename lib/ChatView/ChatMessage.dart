import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChatMessage extends StatefulWidget {
  ChatMessage({this.text, this.name,this.type,this.animationController});
  final AnimationController animationController;
  final String text;
  final String name;
  final bool type;
  @override
  _ChatMessageState createState() => _ChatMessageState();
}
class _ChatMessageState extends State<ChatMessage> {




  @override
  void initState() {
    super.initState();

  }
  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> otherMessage(context) {

    return <Widget>[
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
                              child: new Text(widget.text,style: TextStyle(fontSize: 18,color: Colors.white),),
                            ),
                            Positioned(
                              top: 5,left: 12,
                              child: Container(
                                child: new Text(widget.name != null ? widget.name : '',style: TextStyle(fontSize: 11,color: Colors.white),),
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




    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10.0, left: 90),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.deepPurple, Colors.white54],
//                    begin: Alignment.topLeft,
//                    end: Alignment.bottomRight,
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.3, 1.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp

                        ),
//                        boxShadow: [
//                          BoxShadow(
//                            color: HexColor.fromHex('#c2c2c2'),
//                            blurRadius: 4.0, // has the effect of softening the shadow
//                            spreadRadius: 1, // has the effect of extending the shadow
//                            offset: Offset(
//                              0.5, // horizontal, move right 10
//                              0.8, // vertical, move down 10
//                            ),
//                          )
//                        ],
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16),topRight:Radius.circular(16),topLeft: Radius.circular(19) )
                    ),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            new Container(
                              margin: const EdgeInsets.only(top: 14 ,left: 12,right: 35,bottom: 16),
                              child: new Text(widget.text,style: TextStyle(fontSize: 18,color: Colors.white),),
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
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: widget.animationController,
          curve: Curves.decelerate), //new
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.type ? myMessage(context) : otherMessage(context),
        ),
      ),);
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
