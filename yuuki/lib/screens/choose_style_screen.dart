import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/screens/flash_card_screen.dart';
import 'package:yuuki/widgets/custom_login_button.dart';

import '../models/my_user.dart';

class ChooseStyleScreen extends StatelessWidget {
  final MyUser myUser;
  final UserTopic userTopic;
  final bool isEnVi;

  const ChooseStyleScreen({
    super.key,
    required this.myUser,
    required this.isEnVi,
    required this.userTopic
  });

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
                Container(
                  margin: EdgeInsets.fromLTRB(25, 50, 25, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomLoginButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (e) => FlashCardScreen(
                                  myUser: myUser,
                                  userTopic: userTopic,
                                  isEnVi: isEnVi,
                                ),
                              ),
                            );
                          },
                          text: "Learning by FlashCard",
                          width: double.infinity,
                          height: 44
                      ),
                      const SizedBox(height: 36),
                      CustomLoginButton(
                          onPressed: () {
                            // code here
                          },
                          text: "Learning by MultiChoice",
                          width: double.infinity,
                          height: 44
                      ),
                      const SizedBox(height: 36),
                      CustomLoginButton(
                          onPressed: () {
                            // code here
                          },
                          text: "Learning by Language-pair",
                          width: double.infinity,
                          height: 44
                      ),
                      const SizedBox(height: 42),
                      Image.asset(
                        'assets/images/learning/img_choose_style.png',
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
}
