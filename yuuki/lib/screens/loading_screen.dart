import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hình nền
          Image.asset(
            "assets/images/onboarding/img_background.jpg",
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "YUUKI",
                  style: TextStyle(
                      color: Colors.black12,
                      fontSize: 80,
                      fontFamily: "Jua"
                  ),
                ),
                SizedBox(height: 20),
                CircularProgressIndicator(),
                SizedBox(height: 15,),
                Text(
                  "Welcome, please wait...",
                  style: TextStyle(
                      color: Colors.black12,
                      fontSize: 24,
                      fontFamily: "Jua"
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}