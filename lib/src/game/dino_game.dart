import 'dart:async';
import 'package:flutter/material.dart';
import 'package:no_internet_found_widget/no_internet_found_widget.dart';

class DinoGame extends StatefulWidget {
  const DinoGame({super.key});

  @override
  _DinoGameState createState() => _DinoGameState();
}

class _DinoGameState extends State<DinoGame>
    with SingleTickerProviderStateMixin {
  static const double groundHeight = 10;
  double dinoHeight = 0;
  double cactusLeft = 300;
  late AnimationController _controller;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _controller.addListener(() {
      setState(() {
        dinoHeight = -100 * _controller.value;
      });

      if (_controller.isCompleted) {
        _controller.reverse();
      }
    });

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        cactusLeft -= 5;
      });

      if (cactusLeft <= -20) {
        cactusLeft = MediaQuery.of(context).size.width;
      }

      if (cactusLeft < 80 && cactusLeft > 0 && dinoHeight > -30) {
        // Collision detected
        timer.cancel();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Game Over'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Restart'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    restartGame();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  void jump() {
    if (_controller.isAnimating) return;

    _controller.forward();
  }

  void restartGame() {
    setState(() {
      cactusLeft = MediaQuery.of(context).size.width;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        cactusLeft -= 5;
      });

      if (cactusLeft <= -20) {
        cactusLeft = MediaQuery.of(context).size.width;
      }

      if (cactusLeft < 10 && cactusLeft > 0 && dinoHeight > -30) {
        // Collision detected
        timer.cancel();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Game Over'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Restart'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    restartGame();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: jump,
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 0),
              bottom: groundHeight + dinoHeight,
              child: Image.asset(
                PathConstants.trex,
                package: 'no_internet_found_widget',
                width: 50,
                height: 50,
              ),
            ),
            Positioned(
              bottom: groundHeight,
              left: cactusLeft,
              child: Image.asset(
                PathConstants.cactus,
                package: 'no_internet_found_widget',
                width: 20,
                height: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
