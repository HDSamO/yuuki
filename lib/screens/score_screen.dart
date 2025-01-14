import 'package:flutter/material.dart';
import 'package:yuuki/models/learning_result.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/screens/check_answer_screen.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/customs/custom_login_button.dart';

import '../models/my_user.dart';
import 'home_screen.dart';

class ScoreScreen extends StatelessWidget {
  final MyUser myUser;
  final UserTopic userTopic;
  final bool isEnVi;
  final LearningResult learningResult;

  const ScoreScreen({
    super.key,
    required this.myUser,
    required this.userTopic,
    required this.isEnVi,
    required this.learningResult,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the background image and header text based on the score
    String backgroundImage = learningResult.avgScore! < 50
        ? "assets/images/learning/img_bad_result.png"
        : "assets/images/learning/img_good_result.png";
    String headerText = learningResult.avgScore! < 50
        ? "Don't Give Up!!"
        : "Keep Going";

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundImage),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              // Back Button
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: IconButton(
                      onPressed: (){
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(user: myUser),
                          ),
                              (route) => false,
                        );
                      },
                      icon: Icon(
                          Icons.cancel,
                        color: Colors.blue,
                        size: 40,
                      ),
                    )
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          headerText,
                          style: TextStyle(
                            fontFamily: 'Jua',
                            fontSize: 54,
                            color: Color(0xFF6078F9),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Center(
                        child: Text(
                          "${learningResult.getCorrectAnswers().length.toString()} / ${learningResult.questionAnswers.length.toString()}",
                          style: TextStyle(
                              fontFamily: 'Katibeh',
                              fontSize: 81,
                              color: Colors.black
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: CustomLoginButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (e) => CheckAnswerScreen(
                            myUser: myUser,
                            userTopic: userTopic,
                            learningResult: learningResult,
                            isEnVi: isEnVi,
                          )
                      ),
                    );
                  },
                  text: "CHECK THE ANSWER",
                  width: double.infinity,
                  height: 54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}