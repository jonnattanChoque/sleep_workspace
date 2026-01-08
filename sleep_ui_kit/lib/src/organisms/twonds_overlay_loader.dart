import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TwnDSOverlayLoader extends StatelessWidget {
  final String lottiePath;
  final String message;
  final Color? textColor;

  const TwnDSOverlayLoader({
    super.key,
    required this.lottiePath,
    required this.message,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Container(
        color: Colors.black.withValues(alpha: 0.8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                lottiePath,
                width: 180,
                height: 180,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}