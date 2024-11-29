import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/utils/demension.dart';

class ItemCommunityPeople extends StatelessWidget {
  final MyUser user;

  ItemCommunityPeople({required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Container(
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                Row(
                  children: [
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
                          backgroundImage:
                              AssetImage('assets/images/avatar/avatar.jpg'),
                          radius: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Text(
                        user.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: "Quicksand",
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 20,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(217, 240, 255, 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${user.userTopics!.length} topics",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: "QuicksandRegular",
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/login_signup/ultimategrinderIcon.png",
                            width: 28,
                            height: 28,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Image.asset(
                            "assets/images/login_signup/flawlessaceIcon.png",
                            width: 28,
                            height: 28,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Image.asset(
                            "assets/images/login_signup/streakmasterIcon.png",
                            width: 28,
                            height: 28,
                            fit: BoxFit.contain,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.more_vert),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
