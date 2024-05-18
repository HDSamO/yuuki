import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yuuki/results/user_topic_result.dart';
import 'package:yuuki/services/topic_service.dart';
import 'package:yuuki/utils/demension.dart';
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

      if (!userTopicResult.success){
        _showNotificationDialog("Error", userTopicResult.errorMessage!, false);
      } else {
        TopicResult topicResult = await _topicController.deleteTopicById(_myUser, userTopicId);

        if (!topicResult.success){
          Navigator.of(context).pop(); // Close the loading dialog
          _showNotificationDialog("Error", topicResult.errorMessage!, false);
        } else {
          setState(() {
            _recentUserTopicsFuture = _getFutureUserTopics();
          });
          Navigator.of(context).pop(); // Close the loading dialog
          _showNotificationDialog("Success", "Topic has been deleted!", true);
        }
      }
    } catch (error) {
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
                          style: TextStyle(fontSize: 18, fontFamily: "Cabin"),
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
                          style: TextStyle(fontSize: 18, fontFamily: "Cabin"),
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
        return Dialog(
          child: Container(
            height: Dimensions.height(context, 220),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF397CFF),
                        Color(0x803DB7FC),
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: Dimensions.fontSize(context, 20),
                      fontFamily: "Quicksand",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: Dimensions.fontSize(context, 16),
                      fontFamily: "QuicksandRegular",
                      color: isSuccess ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                      child: Text(
                        "Ok",
                        style: TextStyle(
                          fontSize: Dimensions.fontSize(context, 16),
                          fontFamily: "QuicksandRegular",
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 40,
                        ),
                        foregroundColor: AppColors.mainColor,
                        side: BorderSide(
                          color: AppColors.mainColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


