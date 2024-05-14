import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/models/topic.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/utils/demension.dart';

import '../../models/vocabulary.dart';
import '../../screens/choose_language_screen.dart';

class ItemLibraryProgress extends StatelessWidget {
  final MyUser myUser;
  final UserTopic userTopic;

  const ItemLibraryProgress({
    super.key,
    required this.myUser,
    required this.userTopic,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Container(
        width: double.infinity,
        height: 80,
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
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
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
                          "${userTopic.vocabularies.length} Items",
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
              _buildStudyButton(context, userTopic),
            ],
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

  Widget _buildStudyButton(BuildContext context, UserTopic userTopic) {
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (e) => ChooseLanguageScreen(
                  myUser: myUser,
                  userTopic: userTopic,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
