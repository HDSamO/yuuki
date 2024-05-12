import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/models/topic.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/utils/demension.dart';

import '../models/vocabulary.dart';
import '../screens/choose_language_screen.dart';

class ItemLibraryProgress extends StatelessWidget {
  final MyUser myUser;

  const ItemLibraryProgress({
    super.key,
    required this.myUser,
  });

  @override
  Widget build(BuildContext context) {
    UserTopic userTopic =
    myUser.userTopics.isNotEmpty ? myUser.userTopics[0] : _getDefaultUserTopic();

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
                            fontFamily: "Cabin",
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

  UserTopic _getDefaultUserTopic() {
    // Tạo danh sách từ vựng cho chủ đề
    List<Vocabulary> vocabularies = [
      Vocabulary(term: "apple", definition: "a fruit"),
      Vocabulary(term: "book", definition: "a written or printed work"),
      Vocabulary(term: "cat", definition: "a small domesticated carnivorous mammal"),
      Vocabulary(term: "dog", definition: "a domesticated carnivorous mammal"),
      Vocabulary(term: "elephant", definition: "a very large herbivorous mammal"),
      Vocabulary(term: "flower", definition: "the seed-bearing part of a plant"),
      Vocabulary(term: "guitar", definition: "a stringed musical instrument"),
      Vocabulary(term: "house", definition: "a building for human habitation"),
      Vocabulary(term: "ice cream", definition: "a sweet frozen food"),
      Vocabulary(term: "jacket", definition: "a short coat"),
    ];

    // Tạo một chủ đề mới
    Topic myTopic = Topic(
      id: "1",
      title: "My Vocabulary List",
      description: "A collection of various words and their meanings.",
      vocabularies: vocabularies,
      private: false,
      authorName: "John Doe",
    );

    return UserTopic.fromTopic(myTopic);
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
          fontFamily: "Cabin",
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
                builder: (e) => ChooseLanguageScreen(myUser: myUser, userTopic: userTopic,),
              ),
            );
          },
        ),
      ),
    );
  }
}
