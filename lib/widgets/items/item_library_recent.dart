import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/models/user_topic.dart';

import '../../screens/choose_language_screen.dart';
import '../../screens/view_topic.dart';
import '../customs/custom_delete_dialog.dart';
import '../customs/custom_notification_dialog.dart';

class ItemLibraryRecent extends StatelessWidget {
  final MyUser myUser;
  final UserTopic userTopic;
  final VoidCallback onRemove;
  final VoidCallback onRefresh;

  const ItemLibraryRecent({
    super.key,
    required this.myUser,
    required this.userTopic,
    required this.onRemove,
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
    if (userTopic.vocabularies.isEmpty) {
      _showNotificationDialog(
          context, "Error", "The vocabulary list is empty", false);
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

  void _showNotificationDialog(
      BuildContext context, String title, String message, bool isSuccess) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomNotificationDialog(
            title: title, message: message, isSuccess: isSuccess);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTopic = userTopic;

    return GestureDetector(
      onTap: () {
        onTapFunctionToLearning(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Container(
          width: double.infinity,
          height: 110,
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                currentTopic.title,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: "QuicksandRegular",
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _showDeleteConfirmationDialog(
                                    context, userTopic.title);
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildItemInfo(
                              context,
                              "${currentTopic.vocabularies.length} terms",
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.person,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                currentTopic.authorName,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: "QuicksandRegular",
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            _buildViewTopicButton(context, userTopic)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String nameTopic) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDeleteDialog(
              title: "Confirm Delete",
              message:
                  "Are you sure you want to delete topic \"${nameTopic}\"?",
              onFunction: () {
                onRemove();
              });
        });
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
          fontSize: 14,
          fontFamily: "QuicksandRegular",
        ),
      ),
    );
  }

  Widget _buildViewTopicButton(BuildContext context, UserTopic userTopic) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color.fromRGBO(217, 240, 255, 1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
        icon: Icon(
          Icons.navigate_next,
          size: 28,
        ),
        onPressed: () {
          onTapFunctionToViewTopic(context);
        },
      ),
    );
  }
}
