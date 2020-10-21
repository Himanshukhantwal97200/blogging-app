import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shortblogapp/Screens/Home/home.dart';
import 'package:shortblogapp/Screens/welcomeWithAuthentication/components/color_design_button.dart';
import 'package:shortblogapp/Screens/welcomeWithAuthentication/components/google_sign_in_button.dart';
import 'log_in.dart';
import 'package:shortblogapp/components/fadeAnimation.dart';
import 'package:shortblogapp/components/loading.dart';
import 'package:shortblogapp/constants.dart';
import 'package:shortblogapp/services/auth.dart';
import 'components/make_input.dart';
import 'package:validators/validators.dart' as validator;

class SignUpPage extends StatefulWidget {
  static String id = '/sign_up';
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  AuthService _auth = AuthService();
  bool loading = false;

  String error = '';

  String name;
  String email;
  String password1;
  String password2;

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
                              "Sign up",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                            1.2,
                            Text(
                              "Hi 👋, Please create an account",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[700]),
                            )),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        FadeAnimation(
                            1.1,
                            makeInput(
                                label: "Full Name",
                                onChanged: (val) {
                                  name = val;
                                },
                                validator: (val) => val.isEmpty
                                    ? 'Name cannot be empty'
                                    : null)),
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
                                onChanged: (val) {
                                  password1 = val;
                                },
                                validator: (val) => validator.isLength(val, 6)
                                    ? null
                                    : "Please enter password greater than 6")),
                        FadeAnimation(
                            1.4,
                            makeInput(
                                label: "Confirm Password",
                                obscureText: true,
                                onChanged: (val) {
                                  password2 = val;
                                },
                                validator: (val) => validator.isLength(val, 6)
                                    ? null
                                    : "Please enter password greater than 6")),
                        Text(error,
                            style: TextStyle(color: Colors.red, fontSize: 15)),
                        FadeAnimation(
                            1.5,
                            ColorDesignButton(
                              color: Colors.greenAccent,
                              text: 'Sign Up',
                              callBack: signUpButton,
                            )),
                        FadeAnimation(
                            1.6,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Already have an account?"),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(context, LoginPage.id);
                                  },
                                  child: Text(
                                    " Login",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Colors.blue,
                                    ),
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
                        text: "Sign Up with google",
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  signUpButton() async {
    if (password1 == password2) {
      // here we're validating the form
      if (_formKey.currentState.validate()) {
        setState(() => loading = true); // showing loading widget
        dynamic result =
            await _auth.registerWithEmailAndPassword(email, password1);
        if (result == null) {
          setState(() {
            loading = false;
            error = 'please supply a valid email';
          });
        }
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    } else if (password1 != password2) {
      setState(() {
        error = "Both the passwords are different";
        HapticFeedback.vibrate();
      });
    }
  }
}
