import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Loading(
            indicator: BallPulseIndicator(),
            size: ScreenUtil().setWidth(50),
            color: Colors.blue),
      ),
    );
  }
}
