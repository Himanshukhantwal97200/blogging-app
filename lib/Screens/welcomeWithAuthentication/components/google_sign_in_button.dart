import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  GoogleSignInButton({this.text, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      color: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/google.png',
              fit: BoxFit.contain, width: 40.0, height: 40.0),
          SizedBox(
            width: 20,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 15.0, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
