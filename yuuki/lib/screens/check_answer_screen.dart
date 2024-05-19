import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yuuki/models/learning_result.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/screens/leaderboard_screen.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/customs/custom_dialog_confirm.dart';
import 'package:yuuki/widgets/customs/custom_login_button.dart';
import 'package:yuuki/widgets/items/item_check_answer.dart';

import '../models/my_user.dart';
import '../utils/const.dart';
import 'home_screen.dart';

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
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 32, 32, 24),
                          child: Image.asset(
                            'assets/images/learning/img_arrow_left.png',
                            width: 36,
                            height: 36,
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(32, 32, 20, 24),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (e) => LeaderBoardScreen(
                                      myUser: myUser,
                                      userTopic: userTopic,
                                      learningResult: learningResult,
                                      isEnVi: isEnVi,
                                    )
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.leaderboard,
                              size: 36,
                              color: Colors.yellow,
                            ),
                          )
                      ),
                    ],
                  )
                ),
                Center(
                  child: Text(
                    "Your answer: ${learningResult.getCorrectAnswers().length.toString()} / ${learningResult.questionAnswers.length.toString()}",
                    style: TextStyle(
                        fontFamily: 'Katibeh',
                        fontSize: 48,
                        color: Colors.black
                    ),
                  ),
                ),
                SizedBox(
                  height: 600,
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
              ],
            )
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _showDialog(context);
          },
          heroTag: 'uniqueTag',
          backgroundColor: AppColors.mainColor,
          label: Row(
            children: [
              Icon(Icons.exit_to_app_outlined, color: Colors.white),
              SizedBox(width: 12),
              Text(
                'Exit',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "QuicksandRegular",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialogConfirm(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(user: myUser),
                ),
                    (route) => false,
              );
            },
            okeText: "Exit",
            content: "Do you want to exit?",
            title: "Confirm"
        );
      },
    );
  }

}
