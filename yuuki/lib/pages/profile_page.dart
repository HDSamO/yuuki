import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/screens/login_screen.dart';
import 'package:yuuki/utils/const.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/customs/custom_dialog_change_password.dart';
import 'package:yuuki/widgets/customs/custom_fragment_scaffold.dart';
import 'package:yuuki/widgets/customs/custom_item_profile.dart';

class ProfilePage extends StatelessWidget {
  final MyUser? user;
  ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    return CustomFragmentScaffold(
      pageName: 'My Profile',
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
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
                                "https://ps.w.org/user-avatar-reloaded/assets/icon-128x128.png?rev=2540745"),
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
                      Container(
                        width: 200,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF397CFF),
                              Color(0x803DB7FC),
                            ],
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {},
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
                            foregroundColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).viewInsets.bottom == 0
                  ? 0
                  : MediaQuery.of(context).viewInsets.bottom,
              child: Column(
                children: [
                  CustomItemProfile(
                    icon: Icon(Icons.change_circle),
                    text: "Change password",
                    more: true,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialog(user!);
                        },
                      );
                    },
                  ),
                  SizedBox(height: Dimensions.height(context, 20)),
                  CustomItemProfile(
                    icon: Icon(Icons.logout),
                    text: "Logout",
                    more: false,
                    onTap: () {
                      Future<void> saveUserToSharedPreferences() async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString('id', '');
                        prefs.setString('email', '');
                      }

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                  SizedBox(height: Dimensions.height(context, 20)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
