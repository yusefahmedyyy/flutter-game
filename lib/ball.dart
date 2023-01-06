import 'package:flutter/material.dart';

class MYball extends StatelessWidget {
  final double ballx;
  final double bally;
  MYball({required this.ballx, required this.bally});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(ballx, bally),
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: Color.fromARGB(255, 236, 64, 159)),
      ),
    );
  }
}
