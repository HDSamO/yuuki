import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/utils/const.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/customs/custom_item_profile.dart';
import 'package:yuuki/widgets/customs/custom_login_button.dart';
import 'package:yuuki/widgets/user_card.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/utils/const.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/customs/custom_item_profile.dart';
import 'package:avatar_glow/avatar_glow.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/utils/const.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/customs/custom_item_profile.dart';
import 'package:avatar_glow/avatar_glow.dart';

class ProfilePage extends StatelessWidget {
  final MyUser? user;
  ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Profile",
          style: TextStyle(
            fontSize: Dimensions.fontSize(context, 20),
            fontFamily: "Quicksand",
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.backroundColor,
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          color: AppColors.backroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Dimensions.height(context, 40)),
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
              SizedBox(height: Dimensions.height(context, 20)),
              Text(
                user!.name,
                style: TextStyle(
                  fontSize: Dimensions.fontSize(context, 24),
                  fontFamily: "Quicksand",
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                user!.email,
                style: TextStyle(
                  fontSize: Dimensions.fontSize(context, 20),
                  fontFamily: "QuicksandRegular",
                  color: Colors.black,
                ),
              ),
              SizedBox(height: Dimensions.height(context, 40)),
              ElevatedButton(
                onPressed: () {
                  // Your edit profile action here
                },
                child: Text(
                  'Edit profile',
                  style: TextStyle(
                    fontSize: Dimensions.fontSize(context, 20),
                    fontFamily: "QuicksandRegular",
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color(0x803DB7FC),
                  backgroundColor: AppColors.mainColor,
                  fixedSize: Size(200, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height(context, 20)),
              CustomItemProfile(
                icon: Icon(Icons.logout),
                text: "Logout",
                more: true,
              ),
              CustomItemProfile(
                icon: Icon(Icons.logout),
                text: "Logout",
                more: true,
              ),
              SizedBox(height: Dimensions.height(context, 20)),
            ],
          ),
        ),
      ),
    );
  }
}
