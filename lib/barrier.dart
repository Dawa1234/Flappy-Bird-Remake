import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  bool isTop = false;
  bool smallHeight = true;
  double barrierTop;
  double barrierBtm;
  double barrierY;
  MyBarrier(
      {required this.isTop,
      required this.barrierTop,
      required this.barrierBtm,
      required this.smallHeight,
      required this.barrierY,
      super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      alignment: isTop
          ? Alignment(barrierTop, barrierY)
          : Alignment(barrierBtm, barrierY),
      duration: const Duration(milliseconds: 0),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 50, 124, 53),
            border: const Border.fromBorderSide(
                BorderSide(color: Color.fromARGB(255, 24, 86, 56), width: 10)),
            borderRadius: isTop
                ? const BorderRadius.vertical(bottom: Radius.circular(20))
                : const BorderRadius.vertical(top: Radius.circular(20))),
        width: 100,
        height: smallHeight ? 100 : 300,
      ),
    );
  }
}
