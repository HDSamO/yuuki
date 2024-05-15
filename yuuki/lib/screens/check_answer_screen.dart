import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yuuki/models/learning_result.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/customs/custom_login_button.dart';
import 'package:yuuki/widgets/items/item_check_answer.dart';

import '../models/my_user.dart';

class CheckAnswerScreen extends StatelessWidget {
  final MyUser myUser;
  final UserTopic userTopic;
  final bool isEnVi;
  final LearningResult learningResult;

  const CheckAnswerScreen({
    super.key,
    required this.myUser,
    required this.userTopic,
    required this.isEnVi,
    required this.learningResult,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/onboarding/img_background.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget> [
                // Back Button
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
                          child: Image.asset(
                            'assets/images/learning/img_arrow_left.png',
                            width: Dimensions.width(context, 36),
                            height: Dimensions.height(context, 36),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {

                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                                Icons.leaderboard,
                              size: Dimensions.iconSize(context, 36),
                            ),
                          )
                        ),
                      ),
                    ],
                  )
                ),
                Center(
                  child: Text(
                    "Your answer: ${learningResult.getCorrectAnswers().length.toString()} / ${learningResult.questionAnswers.length.toString()}",
                    style: TextStyle(
                        fontFamily: 'Katibeh',
                        fontSize: Dimensions.fontSize(context, 48),
                        color: Colors.black
                    ),
                  ),
                ),
                SizedBox(
                  height: Dimensions.height(context, 550),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: learningResult.questionAnswers.length,
                    itemBuilder: (context, index) {
                      return ItemCheckAnswer(
                        questionAnswer: learningResult.questionAnswers[index],
                        isEnVi: isEnVi,
                      );
                    },
                  ),
                ),
                SizedBox(height: Dimensions.height(context, 32),),
                Center(
                  child: CustomLoginButton(
                    text: "Exit",
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    width: double.infinity,
                    height: 54,
                  ),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}
