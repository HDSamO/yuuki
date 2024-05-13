import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yuuki/utils/const.dart';
import 'package:yuuki/utils/demension.dart';

class CustomDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF397CFF),
                    Color(0x803DB7FC), // 0x80 for 50% opacity
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                "Change password",
                style: TextStyle(
                  fontSize: Dimensions.fontSize(context, 20),
                  fontFamily: "QuicksandRegular",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              "Old password",
              style: TextStyle(
                fontSize: Dimensions.fontSize(context, 16),
                fontFamily: "QuicksandRegular",
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(),
            Text(
              "New password",
              style: TextStyle(
                fontSize: Dimensions.fontSize(context, 16),
                fontFamily: "QuicksandRegular",
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(),
            Text(
              "Confilm password",
              style: TextStyle(
                fontSize: Dimensions.fontSize(context, 16),
                fontFamily: "QuicksandRegular",
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: Dimensions.fontSize(context, 16),
                      fontFamily: "QuicksandRegular",
                      color: Color(0xffec5b5b),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 32,
                      ),
                      foregroundColor: Color(0xffec5b5b),
                      side: BorderSide(
                        color: Color(0xffec5b5b),
                      )),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Change",
                    style: TextStyle(
                      fontSize: Dimensions.fontSize(context, 16),
                      fontFamily: "QuicksandRegular",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 32,
                    ),
                    backgroundColor: AppColors.mainColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
