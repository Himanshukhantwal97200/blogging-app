import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shortblogapp/Screens/homeWithAnimatedDrawer/home.dart';
import 'package:shortblogapp/Screens/welcomeWithAuthentication/components/color_design_button.dart';
import 'package:shortblogapp/Screens/welcomeWithAuthentication/components/google_sign_in_button.dart';
import 'package:shortblogapp/Screens/welcomeWithAuthentication/components/make_input.dart';
import 'package:shortblogapp/Screens/welcomeWithAuthentication/sign_up.dart';
import 'package:shortblogapp/components/fadeAnimation.dart';
import 'package:shortblogapp/components/loading.dart';
import 'package:shortblogapp/constants.dart';
import 'package:shortblogapp/services/auth.dart';
import 'package:validators/validators.dart' as validator;

class LoginPage extends StatefulWidget {
  static String id = '/log_in';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  AuthService _auth = AuthService();
  bool loading = false;

  String error = '';

  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
            body: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                height: MediaQuery.of(context).size.height - 50,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FadeAnimation(
                            1,
                            Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                            1.2,
                            Text(
                              "Glad to see you again 😊, Please Login to your account",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            )),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        FadeAnimation(
                            1.2,
                            makeInput(
                                label: "Email",
                                onChanged: (val) {
                                  email = val;
                                },
                                validator: (val) => validator.isEmail(val)
                                    ? null
                                    : 'Please enter a valid email')),
                        FadeAnimation(
                            1.3,
                            makeInput(
                                label: "Password",
                                obscureText: true,
                                validator: (val) => validator.isLength(val, 6)
                                    ? null
                                    : "Please enter password greater than 6",
                                onChanged: (val) {
                                  password = val;
                                })),
                        Text(error,
                            style: TextStyle(color: Colors.red, fontSize: 15))
                      ],
                    ),
                    Column(
                      children: [
                        FadeAnimation(
                            1.4,
                            ColorDesignButton(
                              color: Colors.greenAccent,
                              text: 'Login',
                              callBack: logInButton,
                            )),
                        FadeAnimation(
                            1.5,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Don't have an account?"),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(context, SignUpPage.id);
                                  },
                                  child: Text(
                                    "Sign up",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.blue),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                    FadeAnimation(
                      1.7,
                      orText,
                    ),
                    FadeAnimation(
                      1.8,
                      GoogleSignInButton(
                        text: "Sign In with Google",
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  logInButton() async {
    if (_formKey.currentState.validate()) {
      setState(() => loading = true);
      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
      if (result == null) {
        setState(() {
          loading = false;
          HapticFeedback.vibrate();
          error = 'This email is not registered';
        });
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    }
  }
}
