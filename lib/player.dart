import 'package:flutter/material.dart';

class Myplayer extends StatelessWidget {
  final playerx;
  Myplayer({this.playerx});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(playerx, 1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          color: Colors.lightBlue,
          height: 50,
          width: 50,
        ),
      ),
    );
  }
}
