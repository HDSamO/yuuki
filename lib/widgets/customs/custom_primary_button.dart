import 'package:flutter/material.dart';
import 'package:yuuki/utils/demension.dart';

class CustomPrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double width;
  final double height;
  final Color color;

  const CustomPrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.width,
    required this.height,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius(context, 27)),
          color: color
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}