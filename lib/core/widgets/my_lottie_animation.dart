import 'package:a_and_w/core/constant/source_lottie.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class MyLottieAnimation extends StatelessWidget {
  const MyLottieAnimation({super.key});
  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      SourceLottie.background,
      fit: BoxFit.cover,
      reverse: true,
      repeat: true,
    );
  }
}