import 'package:flutter/material.dart';
import 'package:yuuki/utils/demension.dart';

class CustomQuizButton extends StatefulWidget {
  final VoidCallback? onTap;
  final String text;

  const CustomQuizButton({
    super.key,
    required this.onTap,
    required this.text
  });

  @override
  State<CustomQuizButton> createState() => _CustomQuizButtonState();
}

class _CustomQuizButtonState extends State<CustomQuizButton> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
        widget.onTap?.call();
      },
      child: Container(
        width: double.infinity,
        height: Dimensions.height(context, 54),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
          gradient: _isSelected
              ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00A5FF),
              Color(0xFF94D4FE)
            ],
          )
              : LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0E0E0),
              Colors.white
            ],
          ),
        ),
        padding: EdgeInsets.all(2.0),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: Dimensions.fontSize(context, 22),
            ),
          ),
        ),
      ),
    );
  }
}
