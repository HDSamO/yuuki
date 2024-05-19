import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/models/topic.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/screens/choose_language_screen.dart';
import 'package:yuuki/screens/view_topic.dart';

import '../customs/custom_notification_dialog.dart';

class ItemHomeResent extends StatefulWidget {
  final UserTopic userTopic;
  final Topic? topic;
  final MyUser user;
  final VoidCallback onRefresh;

  ItemHomeResent({
    required this.userTopic,
    this.topic,
    required this.user,
    required this.onRefresh,
  });

  @override
  State<ItemHomeResent> createState() => _ItemHomeResentState();
}

class _ItemHomeResentState extends State<ItemHomeResent> {

  onTapFunctionToViewTopic(BuildContext context) async {
    final reLoadPage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewTopic(
          userTopic: widget.userTopic,
          user: widget.user,
        ),
      ),
    );

    if (reLoadPage) {
      widget.onRefresh();
    }
  }

  onTapFunctionToLearning(BuildContext context) async {
    if (widget.userTopic.vocabularies.isEmpty){
      _showNotificationDialog("Error", "The vocabulary list is empty", false);
    } else {
      final reLoadPage = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChooseLanguageScreen(
            myUser: widget.user,
            userTopic: widget.userTopic,
          ),
        ),
      );

      if (reLoadPage) {
        widget.onRefresh();
      }
    }
  }

  void _showNotificationDialog(String title, String message, bool isSuccess) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomNotificationDialog(
            title: title,
            message: message,
            isSuccess: isSuccess
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapFunctionToLearning(context);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Container(
          width: 320,
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
                    widget.userTopic.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
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
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(217, 240, 255, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${widget.userTopic.vocabularies.length} terms",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
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
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(217, 240, 255, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${widget.topic != null ? widget.topic!.views : widget.userTopic.view} views",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
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
                        widget.userTopic.authorName,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: "QuicksandRegular",
                        ),
                      ),
                    ),
                    SizedBox(width: 16,),
                    _buildViewTopicButton(context, widget.userTopic),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildViewTopicButton(BuildContext context, UserTopic userTopic) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(217, 240, 255, 1),
          borderRadius: BorderRadius.circular(100),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.navigate_next,
            size: 28,
          ),
          onPressed: () {
            onTapFunctionToViewTopic(context);
          },
        ),
      ),
    );
  }
}
