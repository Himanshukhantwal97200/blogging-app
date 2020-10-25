import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortblogapp/Screens/homeWithAnimatedDrawer/home.dart';
import 'package:shortblogapp/Screens/welcomeWithAuthentication/welcome.dart';
import 'package:shortblogapp/models/newUser.dart';

// This file will decide weather to go to welcome page or homeWithAnimatedDrawer page based on stream of auth
class Wrapper extends StatelessWidget {
  static String id = "/wrapper";
  @override
  Widget build(BuildContext context) {
    //either return the authentication or home screen
    final user = Provider.of<NewUser>(context);
    return user == null ? Welcome() : Home();
  }
}
