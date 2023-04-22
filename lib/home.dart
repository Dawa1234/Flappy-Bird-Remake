import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice/barrier.dart';
import 'package:practice/best/cubit/best_cubit.dart';
import 'package:practice/bird.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double birdYaxis = 0;
  double initialPos = 0;
  double velocity = 2; // the speed of the object (bird)
  double time = 0; // time of state
  double height = 0; // to find the height of object (bird) at each state
  double gravity = 9.8; // acceleration due to gravity
  bool gameStarted = false;
  double barrierTopX = 1.3;
  double barrierBtmX = 1.3;
  double barrierTop1X = 3.3;
  double barrierBtm1X = 3.3;
  static int score = 0;
  int best = 0;
  bool crossed = false;
  void jump() {
    setState(() {
      time = 0;
      initialPos = birdYaxis;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void startGame() {
    gameStarted = true;
    Timer.periodic(const Duration(milliseconds: 65), (timer) {
      int best = BlocProvider.of<BestCubit>(context).state.best;
      if (barrierTopX == -0.5000000000000006 ||
          barrierTopX == -0.549999999999999) {
        score += 1;
        if (score > best) {
          BlocProvider.of<BestCubit>(context).increment();
        }
      }
      if (barrierTop1X == -0.5499999999999968 ||
          barrierTop1X == -0.549999999999999) {
        score += 1;
        if (score > best) {
          BlocProvider.of<BestCubit>(context).increment();
        }
      }
      time += 0.05;
      barrierTopX -= 0.05;
      barrierBtmX -= 0.05;
      barrierTop1X -= 0.05;
      barrierBtm1X -= 0.05;
      height = -(1 / 2) * gravity * time * time + velocity * time;
      setState(() {
        birdYaxis = initialPos - height;
      });
      // if first barrier is off the screen
      if (barrierBtmX < -1.7 && barrierTopX < -1.7) {
        barrierTopX = 2.6;
        barrierBtmX = 2.6;
      }
      // if second barrier is off the screen
      if (barrierBtm1X < -1.7 && barrierTop1X < -1.7) {
        barrierTop1X = 2.6;
        barrierBtm1X = 2.6;
      }
      if (birdIsDead()) {
        timer.cancel();
        _showDialog();
      }
    });
  }

  bool birdIsDead() {
    // if bird try to go off screen
    if (birdYaxis > 1 || birdYaxis < -1) return true;

    // for barrier 1 (collision)
    if ((barrierTopX <= 0.5 || barrierBtmX <= 0.5) &&
        (barrierTopX >= -0.5 || barrierBtmX >= -0.5)) {
      if ((birdYaxis <= 0.16) || (birdYaxis >= 0.64)) {
        return true;
      }
    }
    // for barrier 2 (collision)
    if ((barrierTop1X <= 0.5 || barrierBtm1X <= 0.5) &&
        (barrierTop1X >= -0.5 || barrierBtm1X >= -0.5)) {
      if ((birdYaxis <= -0.6) || (birdYaxis >= -0.15)) {
        return true;
      }
    }
    return false;
  }

  void _resetGame() {
    barrierBtmX = 1.3;
    barrierTop1X = 3.3;
    barrierTopX = 1.3;
    barrierBtm1X = 3.3;
    gameStarted = false;
    birdYaxis = 0;
    time = 0;
    height = 0;
    initialPos = 0;
    score = 0;
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 228, 223, 75),
          contentPadding: EdgeInsets.zero,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "GAME OVER!",
                    style: _textStyle,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                    color: Colors.white,
                    textColor: const Color.fromARGB(255, 52, 123, 55),
                    child: const Text("PLAY AGAIN!"),
                    onPressed: () {
                      setState(() {
                        _resetGame();
                      });
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ],
        );
      },
    );
  }

  final _textStyle = const TextStyle(
      fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameStarted ? () => jump() : () => startGame(),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 10),
                        alignment: Alignment(0, birdYaxis),
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage("assets/sky.jpg"))),
                        child: const MyBird(),
                      ),
                      // ------------------------------ Barrier 1 ------------------------------
                      MyBarrier(
                        isTop: true,
                        smallHeight: false,
                        barrierTop: barrierTopX,
                        barrierBtm: barrierBtmX,
                        barrierY: -1,
                      ),
                      MyBarrier(
                        isTop: false,
                        smallHeight: true,
                        barrierTop: barrierTopX,
                        barrierBtm: barrierBtmX,
                        barrierY: 1,
                      ),
                      // ------------------------------ Barrier 2 ------------------------------
                      MyBarrier(
                        isTop: true,
                        smallHeight: true,
                        barrierTop: barrierTop1X,
                        barrierBtm: barrierBtm1X,
                        barrierY: -1,
                      ),
                      MyBarrier(
                        isTop: false,
                        smallHeight: false,
                        barrierTop: barrierTop1X,
                        barrierBtm: barrierBtm1X,
                        barrierY: 1,
                      ),
                      Container(
                        alignment: const Alignment(0, -0.3),
                        child: gameStarted
                            ? const Text("")
                            : const Text(
                                "T A P  T O  P L A Y",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                      ),
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                        // color: Colors.black54,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, -1),
                              spreadRadius: 10,
                              blurRadius: 10,
                              color: Color.fromARGB(255, 105, 210, 108))
                        ],
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/grass.png"))),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Score: ",
                            style: _textStyle,
                          ),
                          Text(
                            "$score",
                            style: _textStyle,
                          ),
                          const SizedBox(
                            width: 100,
                          ),
                          Text(
                            "Best: ",
                            style: _textStyle,
                          ),
                          BlocBuilder<BestCubit, BestState>(
                            builder: (context, state) {
                              return Text(
                                "${state.best}",
                                style: _textStyle,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
