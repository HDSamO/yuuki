import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yuuki/models/topic.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/results/topic_list_result.dart';
import 'package:yuuki/services/topic_service.dart';
import 'package:yuuki/services/user_service.dart';
import 'package:yuuki/utils/const.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/customs/custom_fragment_scaffold.dart';
import 'package:yuuki/widgets/items/item_community_people.dart';
import 'package:yuuki/widgets/items/item_home_recent.dart';

import '../models/my_user.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key, required this.myUser});
  final MyUser? myUser;

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomFragmentScaffold(
        pageName: 'Community',
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "People",
                  style: TextStyle(
                    color: AppColors.mainColor,
                    fontSize: Dimensions.fontSize(context, 20),
                    fontFamily: "Quicksand",
                  ),
                ),
              ),
              FutureBuilder<List<MyUser>>(
                future: UserService().getUserList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    final users = snapshot.data;
                    return Container(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: users?.length ?? 0,
                        itemBuilder: (context, index) {
                          final user = users![index];
                          return ItemCommunityPeople(user: user);
                        },
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 16),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Trending",
                  style: TextStyle(
                    color: AppColors.mainColor,
                    fontSize: Dimensions.fontSize(context, 20),
                    fontFamily: "Quicksand",
                  ),
                ),
              ),
              FutureBuilder<TopicListResult>(
                future: TopicController().getTopTopicsByViews(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final recentTopics = snapshot.data?.topics ?? [];
                    return Container(
                      height: 180,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: recentTopics.map((topic) {
                          UserTopic userTopic = UserTopic.fromTopic(topic);
                          return ItemHomeResent(
                            userTopic: userTopic,
                            topic: topic,
                            user: widget.myUser!,
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 16),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Explore",
                  style: TextStyle(
                    color: AppColors.mainColor,
                    fontSize: Dimensions.fontSize(context, 20),
                    fontFamily: "Quicksand",
                  ),
                ),
              ),
              FutureBuilder<TopicListResult>(
                future: TopicController().getRandomTopics(),
                builder: (context, AsyncSnapshot<TopicListResult> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final randomTopics = snapshot.data?.topics ?? [];
                    return Container(
                      height: 180,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: randomTopics.map((topic) {
                          UserTopic userTopic = UserTopic.fromTopic(topic);
                          return ItemHomeResent(
                            topic: topic,
                            userTopic: userTopic,
                            user: widget.myUser!,
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ));
  }
}
