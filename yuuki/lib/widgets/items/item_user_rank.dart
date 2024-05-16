import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yuuki/models/top_user.dart';
import 'package:yuuki/models/topic.dart';
import 'package:yuuki/models/user_topic.dart';

import '../../models/vocabulary.dart';

class ItemUserRank extends StatelessWidget {
  final TopUser topUser;

  const ItemUserRank({
    super.key,
    required this.topUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                          const Icon(
                            Icons.person,
                            size: 24,
                          ),
                          Expanded(
                            child: Text(
                              topUser.name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "QuicksandRegular",
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.menu,
                              size: 20,
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
                            "Time: ${topUser.formattedTime}",
                          ),
                          const SizedBox(width: 12),
                          _buildItemInfo(
                              context,
                            "Score: ${topUser.score}",
                          ),
                          const SizedBox(width: 12),
                          _buildItemInfo(
                            context,
                            "Times: ${topUser.viewCount}",
                          ),
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
    );
  }

  UserTopic _getDefaultUserTopic() {
    // Tạo danh sách từ vựng cho chủ đề
    List<Vocabulary> vocabularies = [
      Vocabulary(term: "apple", definition: "a fruit"),
      Vocabulary(term: "book", definition: "a written or printed work"),
      Vocabulary(
          term: "cat", definition: "a small domesticated carnivorous mammal"),
      Vocabulary(term: "dog", definition: "a domesticated carnivorous mammal"),
      Vocabulary(
          term: "elephant", definition: "a very large herbivorous mammal"),
      Vocabulary(
          term: "flower", definition: "the seed-bearing part of a plant"),
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
          fontSize: 14,
          fontFamily: "QuicksandRegular",
        ),
      ),
    );
  }

}
