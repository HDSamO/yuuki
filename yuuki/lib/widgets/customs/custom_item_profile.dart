import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yuuki/utils/const.dart';
import 'package:yuuki/utils/demension.dart';

class CustomItemProfile extends StatelessWidget {
  final Icon icon;
  final String text;
  final bool more;

  const CustomItemProfile({
    required this.icon,
    required this.text,
    required this.more,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(12),
        ),
        height: 60,
        width: 400,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Row(
            children: [
              icon,
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: Dimensions.fontSize(context, 16),
                    fontFamily: "Quicksand",
                    color: Colors.black,
                  ),
                ),
              ),
              Icon(more ? Icons.chevron_right_outlined : null),
            ],
          ),
        ),
      ),
    );
  }
}
