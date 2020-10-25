import 'package:flutter/material.dart';

class drawerItems extends StatelessWidget {
  final Function onTap;
  final String text;
  const drawerItems({
    Key key,
    this.onTap,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
            color: Colors.grey, fontSize: 17, fontWeight: FontWeight.w300),
      ),
    );
  }
}
