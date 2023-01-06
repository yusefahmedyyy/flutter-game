import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test/ball.dart';
import 'package:test/button.dart';
import 'package:test/missile.dart';
import 'package:test/player.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

enum direction { LEFT, RIGHT }

class _HomepageState extends State<Homepage> {
  //player variables
  static double playerx = 0;
  static double playerz = 0;
  //missle variable
  double misslex = playerx;
  double missleheight = 10;
  bool midshot = false;
  int score = 0;

//ball variables
  double ballx = 0.5;
  double bally = 1;
  var ballDirection = direction.LEFT;

  void startgame() {
    double time = 0;
    double height = 0;
    double velocity = 85; // how strong the jump is

    Timer.periodic(Duration(milliseconds: 10), (timer) {
      // quadratic eq. that models a bounce (ip & down)
      height = -5 * time * time + velocity * time;
// if the ball reaches the ground reset the jump
      if (height < 0) {
        time = 0;
      }
      //update new ball position
      setState(() {
        bally = heightToCoordinate(height);
      });

      // if the ball hits the left wall then change direction
      if (ballx - 0.003 < -1) {
        ballDirection = direction.RIGHT;
      }
      // if the ball hits the right wall then change direction
      else if (ballx + 0.003 > 1) {
        ballDirection = direction.LEFT;
      }
      // move the ball in the correct direction
      if (ballDirection == direction.LEFT) {
        setState(() {
          ballx -= 0.003;
        });
      } else if (ballDirection == direction.RIGHT) {
        setState(() {
          ballx += 0.003;
        });
      }
      //if ball hit player
      if (pLayerdies()) {
        timer.cancel();
        _showDialog();
        timer = 0 as Timer;
        score = 0;
      }

      //keep the time going
      time += 0.1;
    });
  }

  void moveleft() {
    setState(() {
      if (playerx - 0.1 < -1) {
        //do nothing
      } else {
        playerx -= 0.1;
        playerz -= 0.1;
      }
      // only makes the x coordinate the same when it isnt in the middle of the shot
      if (!midshot) {
        misslex = playerx;
      }
    });
  }

  void moveright() {
    setState(() {
      if (playerx + 0.1 > 1) {
        //do nothing
      } else {
        playerx += 0.1;
        playerz += 0.1;
      }
      // only makes the x coordinate the same when it isnt in the middle of the shot

      if (!midshot) {
        misslex = playerx;
      }
    });
  }

  void fire() {
    if (midshot == false) {
      Timer.periodic(Duration(milliseconds: 10), (timer) {
        //shots fired
        midshot = true;
        // missile grows till it hits the top of the screen
        setState(() {
          missleheight += 10;
        });

//stop missile when it reaches top of the screen

        if (missleheight > MediaQuery.of(context).size.height * 3 / 4) {
          resetmissile();
          timer.cancel();
        }

        //check if missile has hit the ball
        if (bally > heightToCoordinate(missleheight) &&
            (ballx - misslex).abs() < 0.1) {
          resetmissile();
          score += 1;
          timer.cancel();
          startgame();
        }
        if (playerx == bally || playerx == ballx || MYball == Myplayer) {
          _showDialog();
          score += 1;
        }
      });
    }
  }

//coverts height to coordinate
  double heightToCoordinate(double height) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    double position = 1 - 2 * height / totalHeight;
    return position;
  }

  void _showDialog() {
    showDialog(
        barrierColor: Colors.black,
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
              backgroundColor: Colors.red,
              title: Text(
                "you lost",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ));
        });
  }

  void resetmissile() {
    misslex = playerx;
    missleheight = 10;
    midshot = false;
  }

  bool pLayerdies() {
    if ((ballx - playerx).abs() < 0.05 && bally > 0.95) {
      score = 0;
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft) ||
            event.isKeyPressed(LogicalKeyboardKey.keyA)) {
          moveleft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight) ||
            event.isKeyPressed(LogicalKeyboardKey.keyD)) {
          moveright();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown) ||
            event.isKeyPressed(LogicalKeyboardKey.keyS)) {
          startgame();
        }
        if (event.isKeyPressed(LogicalKeyboardKey.space) ||
            event.isKeyPressed(LogicalKeyboardKey.keyW) ||
            event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
          fire();
        }
      },
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.black,
              child: Center(
                child: Stack(
                  children: [
                    const SizedBox(
                      height: 100,
                      width: 50,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 50,
                        ),
                      ],
                    ),
                    Text('                             '),
                    Text(
                      '    score:$score',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color.fromARGB(255, 13, 78, 15),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    MYball(
                      ballx: ballx,
                      bally: bally,
                    ),
                    Missile(
                      height: missleheight,
                      missilex: misslex,
                    ),
                    Myplayer(
                      playerx: playerx,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.green,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Mybutton(
                    icon: Icons.arrow_back,
                    function: moveleft,
                  ),
                  Mybutton(
                    icon: Icons.play_arrow,
                    function: startgame,
                  ),
                  Mybutton(
                    icon: Icons.arrow_upward,
                    function: fire,
                  ),
                  Mybutton(
                    icon: Icons.arrow_forward,
                    function: moveright,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
