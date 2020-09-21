import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:privatechat/ChatView/ChatScreen.dart';
import 'package:privatechat/main.dart';

class Login extends StatelessWidget {
  DatabaseReference rootRef = FirebaseDatabase.instance.reference();
  ValueNotifier<bool> Loader = ValueNotifier(false);

  TextEditingController _controllername = new TextEditingController();
  TextEditingController _controllercode = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:

      ValueListenableBuilder<bool>(
       valueListenable:  Loader,
        builder: (context, Loader, child) {
          return Loader ? Center(child: CircularProgressIndicator(backgroundColor: Colors.deepPurple,),) : SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 50),
                    child: Text("Private Chat",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            margin: EdgeInsets.only(bottom: 5),
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  focusedBorder:OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white, width: 1.5),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  border:OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white, width: 1.5),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  contentPadding: const EdgeInsets.only(left: 10, bottom: 0, top: 0, right: 0),
                                  labelText: "Enter Your Name",
                                  labelStyle: TextStyle(
                                      color: Colors.white
                                  )
                              ),
                              controller: _controllername,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return 'Please enter name';
                                }
                                return null;
                              },
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            margin: EdgeInsets.only(bottom: 5),
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  focusedBorder:OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white, width: 1.5),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  border:OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white, width: 1.5),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  contentPadding: const EdgeInsets.only(left: 10, bottom: 0, top: 0, right: 0),
                                  labelText: "Enter Your Chat Code",
                                  labelStyle: TextStyle(
                                      color: Colors.white
                                  )
                              ),
                              controller: _controllercode,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return 'Please enter code';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            margin: EdgeInsets.only(top: 0),
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            height: 44,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: Colors.deepPurple,
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins'),
                                ),
                                onPressed: () {
                                  if(_formKey.currentState.validate()) {
                                    _configureAndConnect(context);
                                  }
                                }
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  Future<bool> _configureAndConnect(context) async {
  Loader.value = true;
  var newkey = rootRef.child(_controllercode.text).push().key;
  rootRef.child(_controllercode.text).child("Members").child(newkey).set({
  "member" : _controllername.text,
  }).then((value) {
  Loader.value = false;
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>
        ChatScreen(Code: _controllercode.text,Name: _controllername.text,MemberKey: newkey,),),
  );
});
  }
}