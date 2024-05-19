import 'package:flutter/material.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/models/user_topic.dart';

import '../../screens/choose_language_screen.dart';
import '../../screens/view_topic.dart';
import '../customs/custom_notification_dialog.dart';

class ItemLibraryProgress extends StatelessWidget {
  final MyUser myUser;
  final UserTopic userTopic;
  final VoidCallback onRefresh;

  const ItemLibraryProgress({
    super.key,
    required this.myUser,
    required this.userTopic,
    required this.onRefresh,
  });

  onTapFunctionToViewTopic(BuildContext context) async {
    final reLoadPage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewTopic(
          userTopic: userTopic,
          user: myUser,
        ),
      ),
    );

    if (reLoadPage) {
      onRefresh();
    }
  }

  onTapFunctionToLearning(BuildContext context) async {
    if (userTopic.vocabularies.isEmpty){
      _showNotificationDialog(context, "Error", "The vocabulary list is empty", false);
    } else {
      final reLoadPage = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChooseLanguageScreen(
            myUser: myUser,
            userTopic: userTopic,
          ),
        ),
      );

      if (reLoadPage) {
        onRefresh();
      }
    }
  }

  void _showNotificationDialog(BuildContext context, String title, String message, bool isSuccess) {
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Container(
          width: double.infinity,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            userTopic.title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: "QuicksandRegular",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildItemInfo(
                            context,
                            "${userTopic.vocabularies.length} terms",
                          ),
                          const SizedBox(width: 12),
                          _buildItemInfo(
                            context,
                            "Studying",
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                _buildViewTopicButton(context, userTopic),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemInfo(BuildContext context, String text) {
    return Container(
      alignment: Alignment.center,
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(217, 240, 255, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontFamily: "QuicksandRegular",
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
