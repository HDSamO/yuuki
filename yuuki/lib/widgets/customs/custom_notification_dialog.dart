import 'package:flutter/material.dart';

import '../../utils/const.dart';
import '../../utils/demension.dart';

class CustomNotificationDialog extends StatelessWidget {
  final String title;
  final String message;

  const CustomNotificationDialog({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(20)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF397CFF),
                    Color(0x803DB7FC),
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: Dimensions.fontSize(context, 20),
                  fontFamily: "Quicksand",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: Text(
                message,
                style: TextStyle(
                  fontSize: Dimensions.fontSize(context, 16),
                  fontFamily: "QuicksandRegular",
                  color: Color(0xffec5b5b),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                "OK",
                style: TextStyle(
                  fontSize: Dimensions.fontSize(context, 16),
                  fontFamily: "QuicksandRegular",
                  color: AppColors.mainColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 40,
                ),
                foregroundColor: AppColors.mainColor,
                side: BorderSide(
                  color: AppColors.mainColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}