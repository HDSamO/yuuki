import 'package:flutter/material.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/screens/choose_style_screen.dart';
import 'package:yuuki/services/topic_service.dart';

import '../models/my_user.dart';

class ChooseLanguageScreen extends StatefulWidget {
  final MyUser myUser;
  final UserTopic userTopic;

  const ChooseLanguageScreen({super.key, required this.myUser, required this.userTopic});

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  final TopicController topicController = TopicController();

  @override
  void initState() {
    super.initState();
    topicController.viewTopic(widget.myUser, widget.userTopic.id);
  }

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
                    Navigator.pop(context, true);
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
                                myUser: widget.myUser,
                                userTopic: widget.userTopic,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (e) => ChooseStyleScreen(
                              myUser: widget.myUser,
                              userTopic: widget.userTopic,
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
