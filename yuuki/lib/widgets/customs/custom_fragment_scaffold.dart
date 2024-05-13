import 'package:flutter/material.dart';

class CustomFragmentScaffold extends StatelessWidget {
  const CustomFragmentScaffold({super.key, this.child});
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
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF3B7EFF), Color(0xFF94D4FE)],
                ),
              ),
            ),
            title: const Row(
              children: [
                Text(
                  'Library',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                    fontFamily: "Cabin",
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  // Add your onPressed logic here
                },
              ),
            ],
            elevation: 0,
            automaticallyImplyLeading: false, // Tắt tự động thêm nút back
          ),
          extendBodyBehindAppBar: true,
          body: SafeArea(
            child: child!,
          ),
        ),
      ),
    );
  }
}