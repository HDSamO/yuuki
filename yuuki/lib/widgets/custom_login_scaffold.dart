import 'package:flutter/material.dart';

class CustomLoginScaffold extends StatelessWidget {
  const CustomLoginScaffold({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Image.asset(
              'assets/images/login_signup/background.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              top: 40, // Margin top
              left: 0,
              right: 0,
              child: Center(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [
                        Colors.orange, // Màu cam
                        Colors.red, // Màu đỏ
                      ],
                    ).createShader(bounds);
                  },
                  child: Text(
                    'YUUKI',
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Jua",
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: child!,
            ),
          ],
        ),
      ),
    );
  }
}
