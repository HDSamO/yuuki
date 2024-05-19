import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yuuki/results/user_topic_result.dart';
import 'package:yuuki/services/topic_service.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/customs/custom_notification_dialog.dart';
import 'package:yuuki/widgets/items/item_library_progress.dart';

import '../models/my_user.dart';
import '../models/user_topic.dart';
import '../results/topic_result.dart';
import '../utils/const.dart';
import 'items/item_library_recent.dart';

class LibraryTopics extends StatefulWidget {
  const LibraryTopics({super.key, required this.myUser});
  final MyUser myUser;

  @override
  State<LibraryTopics> createState() => _LibraryTopicsState();
}

class _LibraryTopicsState extends State<LibraryTopics> {
  late MyUser _myUser;
  final TopicController _topicController = TopicController();
  late Future<List<UserTopic>> _recentUserTopicsFuture;

  @override
  void initState() {
    super.initState();
    _myUser = widget.myUser;
    _recentUserTopicsFuture = _getFutureUserTopics();
  }

  Future<List<UserTopic>> _getFutureUserTopics() async {
    return await _topicController.getRecentTopics(_myUser);
  }

  Future<void> _deleteUserTopic(String userTopicId) async {
    _showLoadingDialog();

    try {
      UserTopicResult userTopicResult = await _topicController.deleteUserTopicById(_myUser, userTopicId);
      Navigator.of(context).pop(); // Close the loading dialog

      if (!userTopicResult.success){
        _showNotificationDialog("Error", userTopicResult.errorMessage!, false);
      }
      else {
        TopicResult topicResult = await _topicController.deleteTopicById(_myUser, userTopicId);

        if (!topicResult.success){
          _showNotificationDialog("Error", topicResult.errorMessage!, false);
        }
        else {
          setState(() {
            _recentUserTopicsFuture = _getFutureUserTopics();
          });
          _showNotificationDialog("Success", "Topic has been deleted!", true);
        }
      }
    }
    catch (error) {
      Navigator.of(context).pop(); // Close the loading dialog
      _showNotificationDialog("Error", error.toString(), false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _recentUserTopicsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError){
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data!.isEmpty){
            return Padding(
                padding: EdgeInsets.all(Dimensions.fontSize(context, 20)),
              child: Center(
                child: Text(
                  textAlign: TextAlign.center,
                  "Please create topic or learn any topic at the community page!",
                  style: TextStyle(
                      fontSize: Dimensions.fontSize(context, 24),
                      color: Colors.red
                  ),
                ),
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'In Progress',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Jua",
                            color: AppColors.mainColor,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        ItemLibraryProgress(
                          myUser: _myUser,
                          userTopic: snapshot.data!.first,
                          onRefresh: () {
                            // code here
                          },
                        )
                      ],
                    )
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recent',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Jua",
                            color: AppColors.mainColor,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ItemLibraryRecent(
                                myUser: _myUser,
                                userTopic: snapshot.data![index],
                                onRemove: () {
                                  _deleteUserTopic(snapshot.data![index].id);
                                },
                                onRefresh: () {
                                  setState(() {
                                    _recentUserTopicsFuture = _getFutureUserTopics();
                                  });
                                },);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        }
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _showNotificationDialog(String title, String message, bool isSuccess) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomNotificationDialog(
            title: title,
            message: message,
            isSuccess: isSuccess
        );
      },
    );
  }
}


