import 'package:flutter/material.dart';

class ColorDesignButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function callBack;
  ColorDesignButton({this.text, this.color, this.callBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 3, left: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border(
            bottom: BorderSide(color: Colors.black),
            top: BorderSide(color: Colors.black),
            left: BorderSide(color: Colors.black),
            right: BorderSide(color: Colors.black),
          )),
      child: MaterialButton(
        minWidth: double.infinity,
        height: 60,
        onPressed: callBack,
        color: color,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
    );
  }
}
