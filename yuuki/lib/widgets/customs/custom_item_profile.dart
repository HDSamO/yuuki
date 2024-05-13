import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        horizontal: 20,
      ),
      child: Container(
        height: 60,
        width: 400,
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
                  fontFamily: "QuicksandRegular",
                  color: Colors.black,
                ),
              ),
            ),
            Icon(more ? Icons.chevron_right_outlined : null),
          ],
        ),
      ),
    );
  }
}
