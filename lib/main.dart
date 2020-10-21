import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shortblogapp/Screens/textEditor/text_editor.dart';
import 'package:shortblogapp/Screens/welcomeWithAuthentication/log_in.dart';
import 'package:shortblogapp/Screens/welcomeWithAuthentication/sign_up.dart';
import 'package:shortblogapp/models/newUser.dart';
import 'package:shortblogapp/services/auth.dart';
import 'Screens/welcomeWithAuthentication/welcome.dart';
import 'package:flutter/services.dart';
import 'wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    StreamProvider<NewUser>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Wrapper.id,
        routes: {
          Wrapper.id: (context) => Wrapper(),
          Welcome.id: (context) => Welcome(),
          SignUpPage.id: (context) => SignUpPage(),
          LoginPage.id: (context) => LoginPage(),
          TextEditor.id: (context) => TextEditor(),
        },
      ),
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

/* App Structure
assets => it will have fonts, images and icons.
components => Here all the widgets which are used repeatedly by different apps (animations included)
Screens =>  all the screens
services => all the backend related work will be done here
models => all the classes will come under this.
 */
