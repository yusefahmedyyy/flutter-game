import 'package:flutter/material.dart';

class Mybutton extends StatelessWidget {
  final icon;
  final function;
  Mybutton({this.icon, this.function});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          color: Color.fromARGB(255, 252, 252, 252),
          width: 50,
          height: 50,
          child: Center(child: Icon(icon)),
        ),
      ),
    );
  }
}
