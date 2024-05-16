import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yuuki/models/learning_result.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/results/top_user_result.dart';
import 'package:yuuki/services/topic_service.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/customs/custom_login_button.dart';
import 'package:yuuki/widgets/items/item_user_rank.dart';

import '../models/my_user.dart';
import 'home_screen.dart';

class LeaderBoardScreen extends StatelessWidget {
  final MyUser myUser;
  final UserTopic userTopic;
  final bool isEnVi;
  final LearningResult learningResult;

  const LeaderBoardScreen({
    super.key,
    required this.myUser,
    required this.userTopic,
    required this.isEnVi,
    required this.learningResult,
  });

  Future<TopUserResult> fetchTopScores() async {
    final TopicController topicController = TopicController();
    return await topicController.getTopScorers(userTopic.id);
  }

  Future<TopUserResult> fetchTopViewers() async{
    final TopicController topicController = TopicController();
    return await topicController.getTopViewers(userTopic.id);
  }

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
          child: Stack(
            children: [
              SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20, 16, 16, 0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget> [
                      // Back Button
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                              child: Image.asset(
                                'assets/images/learning/img_arrow_left.png',
                                width: Dimensions.width(context, 36),
                                height: Dimensions.height(context, 36),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Center(
                                child: Text(
                                  "Leaderboard",
                                  style: TextStyle(
                                      fontFamily: 'Jua',
                                      fontSize: Dimensions.fontSize(context, 42),
                                      color: Colors.black
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height(context, 16),),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Topic name: ${userTopic.title}",
                            style: TextStyle(
                              fontSize: Dimensions.fontSize(context, 24),
                            ),
                          ),
                          Text(
                            "Your score: ${(learningResult.avgScore! * 10).round() / 10} / 100",
                            style: TextStyle(
                              fontSize: Dimensions.fontSize(context, 24),
                            ),
                          ),
                          Text(
                            "Your time: ${learningResult.formattedTime}",
                            style: TextStyle(
                              fontSize: Dimensions.fontSize(context, 24),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height(context, 16),),
                      buildWidget(context),
                    ],
                  )
              ),
              SizedBox(height: Dimensions.height(context, 16),),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(Dimensions.iconSize(context, 16)),
                  child: CustomLoginButton(
                    text: "Exit",
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(user: myUser),
                        ),
                            (route) => false,
                      );
                    },
                    width: double.infinity,
                    height: 54,
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

  Widget buildWidget(BuildContext context) {
    if (!userTopic.private) {
      return Column(
        children: [
          // First list: Best time and score
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Best time and score",
              style: TextStyle(
                fontSize: Dimensions.fontSize(context, 24),
                fontFamily: "Cabin",
                color: Color(0xFFFA6900),
              ),
            ),
          ),
          buildFutureBuilder(fetchTopScores),

          SizedBox(height: Dimensions.height(context, 16),),

          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Most time studied",
              style: TextStyle(
                fontSize: Dimensions.fontSize(context, 24),
                fontFamily: "Cabin",
                color: Color(0xFFFA6900),
              ),
            ),
          ),
          buildFutureBuilder(fetchTopViewers),

          SizedBox(height: Dimensions.height(context, 16),),
        ],
      );
    } else {
      return Text(
        "Leaderboards are only available on public topic.",
        style: TextStyle(
            fontSize: Dimensions.fontSize(context, 24),
            color: Colors.red
        ),
      );
    }
  }

  Widget buildFutureBuilder(Future<TopUserResult> Function() fetchFunction) {
    return FutureBuilder<TopUserResult>(
      future: fetchFunction(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while waiting for data
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle errors
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(
                fontSize: Dimensions.fontSize(context, 20),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          final topUserResult = snapshot.data!;
          if (!topUserResult.success ||
              topUserResult.topScorers == null ||
              topUserResult.topScorers!.isEmpty) {
            // No users found
            return Center(
              child: Text(
                'No users found',
                style: TextStyle(
                  fontSize: Dimensions.fontSize(context, 20),
                ),
              ),
            );
          } else {
            // Display the list of users
            var topUsers = topUserResult.topScorers!;
            return SizedBox(
              height: Dimensions.height(context, MediaQuery.of(context).size.height * 0.27,),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: topUsers.length,
                itemBuilder: (context, index) {
                  return ItemUserRank(
                    topUser: topUsers[index],
                  );
                },
              ),
            );
          }
        } else {
          // Unexpected error
          return Center(
            child: Text(
              'Unexpected error',
              style: TextStyle(
                fontSize: Dimensions.fontSize(context, 20),
              ),
            ),
          );
        }
      },
    );
  }

}
