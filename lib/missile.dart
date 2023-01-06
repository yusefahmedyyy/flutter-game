import 'package:flutter/material.dart';

class Missile extends StatelessWidget {
  final missilex;
  final height;
  Missile({this.height, this.missilex});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(missilex, 1),
      child: Container(
        width: 3,
        height: height,
        color: Colors.red,
      ),
    );
  }
}
