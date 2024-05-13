import 'package:flutter/material.dart';
import 'package:yuuki/screens/choose_language_screen.dart';
import 'package:yuuki/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yuuki/models/my_user.dart';

import '../models/topic.dart';
import '../models/user_topic.dart';
import '../models/vocabulary.dart';
import '../widgets/customs/custom_login_button.dart';

class ExampleScreen extends StatelessWidget {
  final MyUser? myUser;
  late final Topic myTopic;
  late final UserTopic myUserTopic;

  ExampleScreen({super.key, required this.myUser}) {
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
    myTopic = Topic(
      id: "1",
      title: "My Vocabulary List",
      description: "A collection of various words and their meanings.",
      vocabularies: vocabularies,
      private: false,
      authorName: "John Doe",
    );

    myUserTopic = UserTopic.fromTopic(myTopic);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              myUser!.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(myUser!.email),
            const SizedBox(height: 8.0),
            Text(myUser!.phone),
            const SizedBox(height: 40.0),
            CustomLoginButton(
              onPressed: () {
                if (myUser != null){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (e) => ChooseLanguageScreen(myUser: myUser, userTopic: myUserTopic,),
                    ),
                  );
                }
              },
              text: 'Learning',
              width: double.infinity,
              height: 54,
            ),
          ],
        ),
      ),
    );
  }
}
