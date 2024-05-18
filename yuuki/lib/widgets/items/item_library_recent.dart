import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/models/topic.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/utils/demension.dart';

import '../../models/vocabulary.dart';
import '../../screens/choose_language_screen.dart';
import '../../screens/view_topic.dart';
import '../customs/custom_delete_dialog.dart';

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

  @override
  Widget build(BuildContext context) {
    final currentTopic = userTopic;

    return GestureDetector(
      onTap: () {
        onTapFunctionToViewTopic(context);
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
                                  fontSize: Dimensions.fontSize(context, 18),
                                  fontFamily: "QuicksandRegular",
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _showDeleteConfirmationDialog(context);
                              },
                              icon: const Icon(
                                Icons.delete_outline,
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
                              "${currentTopic.vocabularies.length} Items",
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
                                  fontSize: 16,
                                  fontFamily: "QuicksandRegular",
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildStudyButton(context, userTopic)
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

  void _showDeleteConfirmationDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return CustomDeleteDialog(
              title: "Confirm Delete",
              message: "This item contains text. Are you sure you want to delete it?",
              onFunction: () {
                onRemove();
              }
          );
        }
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

  Widget _buildStudyButton(BuildContext context, UserTopic userTopic) {
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
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (e) => ChooseLanguageScreen(
          //       myUser: myUser,
          //       userTopic: userTopic,
          //     ),
          //   ),
          // );

          onTapFunctionToLearning(context);
        },
      ),
    );
  }
}
