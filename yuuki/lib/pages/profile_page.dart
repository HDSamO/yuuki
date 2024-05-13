import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/custom_login_button.dart';
import 'package:yuuki/widgets/user_card.dart';

class ProfilePage extends StatelessWidget {
  final MyUser? user;
  ProfilePage({Key? key, required this.user}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: Dimensions.height(context, 20),
                  ),
                  AvatarGlow(
                    startDelay: const Duration(milliseconds: 1000),
                    glowColor: Colors.white,
                    glowShape: BoxShape.circle,
                    animate: false,
                    curve: Curves.easeInOut,
                    child: const Material(
                      elevation: 8.0,
                      shape: CircleBorder(),
                      color: Colors.transparent,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://randomuser.me/api/portraits/men/1.jpg"),
                        radius: 70.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.height(context, 20),
                  ),
                  Text(
                    user!.name,
                    style: TextStyle(
                        fontSize: Dimensions.fontSize(context, 24),
                        fontFamily: "Quicksand",
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user!.email,
                    style: TextStyle(
                      fontSize: Dimensions.fontSize(context, 20),
                      fontFamily: "QuicksandRegular",
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                CustomLoginButton(
                  width: double.infinity,
                  height: 50,
                  onPressed: () {},
                  text: 'Edit Profile',
                ),
                SizedBox(
                  height: 12,
                ),
                CustomLoginButton(
                  width: double.infinity,
                  height: 50,
                  onPressed: () {},
                  text: 'Change Password',
                ),
                SizedBox(
                  height: 12,
                ),
                CustomLoginButton(
                  width: double.infinity,
                  height: 50,
                  onPressed: () {},
                  text: 'Logout',
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
