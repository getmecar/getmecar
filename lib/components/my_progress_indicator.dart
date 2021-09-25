import 'dart:math';

import 'package:flutter/material.dart';

class MyProgressIndicator extends StatefulWidget {
  const MyProgressIndicator({Key? key}) : super(key: key);

  @override
  _MyProgressIndicatorState createState() => _MyProgressIndicatorState();
}

class _MyProgressIndicatorState extends State<MyProgressIndicator> {
  double angle = 0;

  @override
  void initState() {
    super.initState();
    start();
  }

  void start() async {
    await Future.delayed(Duration(milliseconds: 16));
    angle -= pi / 20;
    if (mounted) setState(() {});
    start();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(width: 1, color: Colors.black),
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/background_logo.png',
                    ),
                    fit: BoxFit.cover)),
          ),
          Positioned(
            bottom: 5,
            child: Transform.rotate(
              angle: angle,
              child: Image.asset(
                'assets/images/arrows_logo.png',
                width: 100,
                height: 100,
              ),
            ),
          )
        ],
      ),
    );
  }
}
