import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class TwonDSLottie extends StatelessWidget {
  final String lottiePath;
  final double size;

  const TwonDSLottie({
    super.key,
    required this.lottiePath,
    this.size = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      lottiePath,
      height: size,
      width: size,
      fit: BoxFit.contain,
    );
  }
}