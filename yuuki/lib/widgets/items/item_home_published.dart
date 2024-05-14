import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/models/topic.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/screens/choose_language_screen.dart';
import 'package:yuuki/utils/demension.dart';

class ItemHomePublished extends StatelessWidget {
  final Topic topic;
  final MyUser user;

  ItemHomePublished({
    required this.topic,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    UserTopic userTopic = UserTopic.fromTopic(topic);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (e) => ChooseLanguageScreen(
              myUser: user,
              userTopic: userTopic,
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Container(
          width: 300,
          height: 160,
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
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    topic.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimensions.fontSize(context, 20),
                      fontFamily: "Quicksand",
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 20,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(217, 240, 255, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${topic.vocabularies.length} items",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.fontSize(context, 12),
                            fontFamily: "QuicksandRegular",
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 20,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(217, 240, 255, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${topic.views} views",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.fontSize(context, 12),
                            fontFamily: "QuicksandRegular",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                          backgroundImage: NetworkImage(
                              "https://ps.w.org/user-avatar-reloaded/assets/icon-128x128.png?rev=2540745"),
                          radius: 20.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Text(
                        topic.authorName,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimensions.fontSize(context, 16),
                          fontFamily: "QuicksandRegular",
                        ),
                      ),
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
