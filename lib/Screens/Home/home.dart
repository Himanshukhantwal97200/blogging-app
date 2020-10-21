import 'package:flutter/material.dart';
import 'package:shortblogapp/Screens/textEditor/text_editor.dart';
import 'package:shortblogapp/Screens/welcomeWithAuthentication/welcome.dart';
import 'package:shortblogapp/components/fadeAnimation.dart';
import 'package:shortblogapp/services/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.person),
              onPressed: () async {
                await _auth.signOut();
                Navigator.pop(context);
                Navigator.pushNamed(context, Welcome.id);
              }),
        ],
      ),
      floatingActionButton: FadeAnimation(
        1,
        FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, TextEditor.id);
          },
          child: new Icon(Icons.edit_outlined),
        ),
      ),
      body: Container(
        child: Center(
            child: Text('Here we will load blogs from realtime firestore')),
      ),
    );
  }
}
