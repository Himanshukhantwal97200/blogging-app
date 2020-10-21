import 'package:flutter/material.dart';

Widget makeInput({
  String label,
  bool obscureText = false,
  void onChanged(String val),
  void validator(String val),
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      TextFormField(
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])),
          hintText: label,
        ),
        onChanged: onChanged,
        validator: validator,
      ),
      SizedBox(
        height: 20,
      ),
    ],
  );
}
