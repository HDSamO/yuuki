import 'package:flutter/material.dart';

import '../../utils/const.dart';
import '../../utils/demension.dart';

class CustomNotificationDialog extends StatelessWidget {
  final String title;
  final String message;
  final bool isSuccess;

  const CustomNotificationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.isSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Your answer",
        style: TextStyle(
            color: isSuccess ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold
        ),
      ),
      content: Text(
        message,
        style: TextStyle(
          fontSize: Dimensions.fontSize(context, 18),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Close"),
        ),
      ],
    );
  }

}