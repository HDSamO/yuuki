import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionBadgeWidget.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:yuuki/pages/add_page.dart';
import 'package:yuuki/pages/community_page.dart';
import 'package:yuuki/pages/home_page.dart';
import 'package:yuuki/pages/profile_page.dart';
import 'package:yuuki/pages/library_page.dart';
import 'package:yuuki/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/utils/const.dart';

class HomeScreen extends StatefulWidget {
  final MyUser user;

  HomeScreen({required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selected = 0;
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: StylishBottomBar(
        option: DotBarOptions(
          dotStyle: DotStyle.tile,
          gradient: const LinearGradient(
            colors: [
              Colors.deepPurple,
              Colors.pink,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        items: [
          BottomBarItem(
            icon: const Icon(
              Icons.home_outlined,
            ),
            selectedIcon: const Icon(Icons.home_rounded),
            selectedColor: AppColors.mainColor,
            title: const Text('Home'),
            badgePadding: const EdgeInsets.only(left: 4, right: 4),
          ),
          BottomBarItem(
            icon: const Icon(
              Icons.local_library_outlined,
            ),
            selectedIcon: const Icon(Icons.local_library_rounded),
            selectedColor: AppColors.mainColor,
            title: const Text('Library'),
          ),
          BottomBarItem(
              icon: const Icon(
                Icons.add_circle_outline,
              ),
              selectedIcon: const Icon(
                Icons.add_circle_rounded,
              ),
              selectedColor: AppColors.mainColor,
              title: const Text('Add')),
          BottomBarItem(
              icon: const Icon(
                Icons.language_outlined,
              ),
              selectedIcon: const Icon(
                Icons.language_rounded,
              ),
              selectedColor: AppColors.mainColor,
              title: const Text('Community')),
          BottomBarItem(
              icon: const Icon(
                Icons.person_outline,
              ),
              selectedIcon: const Icon(
                Icons.person,
              ),
              selectedColor: AppColors.mainColor,
              title: const Text('Profile')),
        ],
        hasNotch: false,
        currentIndex: selected,
        notchStyle: NotchStyle.circle,
        onTap: (index) {
          if (index == selected) return;
          controller.jumpToPage(index);
          setState(() {
            selected = index;
          });
        },
      ),
      body: SafeArea(
        child: PageView(
          controller: controller,
          children: [
            HomePage(user: widget.user),
            LibraryPage(myUser: widget.user),
            AddPage(user: widget.user),
            CommunityPage(myUser: widget.user),
            ProfilePage(user: widget.user),
          ],
        ),
      ),
    );
  }
}
