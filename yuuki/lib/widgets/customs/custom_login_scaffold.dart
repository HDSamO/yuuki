import 'package:flutter/material.dart';

class CustomLoginScaffold extends StatelessWidget {
  const CustomLoginScaffold({Key? key, this.child}) : super(key: key);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true, // Bàn phím làm cuộn màn hình
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false, // Tắt tự động thêm nút back
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  'assets/images/main_background.png',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'YUUKI',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Jua",
                      color: Colors.white,
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
      ),
    );
  }
}


