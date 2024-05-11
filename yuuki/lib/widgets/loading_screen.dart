import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              'YUUKI',
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Jua",
                  color: Colors.white
              ),
            ),
            SizedBox(height: 10,),
            CircularProgressIndicator(),
          ],
        )
      ),
    );
  }
}