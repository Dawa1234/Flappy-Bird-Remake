import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  const MyBird({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Image.asset(
        "assets/flappybird.png",
        height: 50,
        width: 50,
      ),
    );
  }
}
