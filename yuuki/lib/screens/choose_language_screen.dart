import 'package:flutter/material.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/screens/choose_style_screen.dart';

import '../models/my_user.dart';
import '../models/vocabulary.dart';

class ChooseLanguageScreen extends StatelessWidget {
  final MyUser myUser;
  final UserTopic userTopic;

  const ChooseLanguageScreen({super.key, required this.myUser, required this.userTopic});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/onboarding/img_background.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Image.asset(
                      'assets/images/learning/img_arrow_left.png',
                      width: 36,
                      height: 36,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // English to Vietnamese Image
                    GestureDetector(
                      onTap: () {
                        // Xử lý khi chọn chuyển ngôn ngữ từ Tiếng Anh sang Tiếng Việt
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (e) => ChooseStyleScreen(
                              myUser: myUser,
                              userTopic: userTopic,
                              isEnVi: true,
                            )
                          ),
                        );
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Image.asset(
                            'assets/images/learning/img_language_1.png',
                          ),
                        ),
                      ),
                    ),
                    // Vertical space between images
                    SizedBox(height: MediaQuery.of(context).size.height * 0.16),
                    // Vietnamese to English Image
                    GestureDetector(
                      onTap: () {
                        // List<Vocabulary> updatedVocabularies = [];
                        // for (var vocabulary in userTopic.vocabularies) {
                        //   String tempTerm = vocabulary.term;
                        //   String tempDefinition = vocabulary.definition;
                        //
                        //   // Create a new Vocabulary object with swapped values
                        //   Vocabulary swappedVocabulary = Vocabulary(
                        //     term: tempDefinition,
                        //     definition: tempTerm,
                        //   );
                        //
                        //   updatedVocabularies.add(swappedVocabulary);
                        // }
                        //
                        // // Replace the existing list of vocabularies with the updated list
                        // userTopic.vocabularies = updatedVocabularies;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (e) => ChooseStyleScreen(
                              myUser: myUser,
                              userTopic: userTopic,
                              isEnVi: false,
                            ),
                          ),
                        );
                      },

                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Image.asset(
                            'assets/images/learning/img_language_2.png',
                          ),
                        ),
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