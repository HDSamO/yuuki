import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yuuki/widgets/item_library_progress.dart';

import '../models/my_user.dart';
import '../models/user_topic.dart';
import 'item_library_recent.dart';

class LibraryTopics extends StatefulWidget {
  const LibraryTopics({super.key, required this.myUser});
  final MyUser? myUser;

  @override
  State<LibraryTopics> createState() => _LibraryTopicsState();
}

class _LibraryTopicsState extends State<LibraryTopics> {
  late MyUser myUser;

  @override
  void initState() {
    super.initState();
    myUser = widget.myUser!;
  }

  @override
  Widget build(BuildContext context) {
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
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10,),
              ItemLibraryProgress(myUser: myUser)
            ],
          )
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10,),
                Expanded(
                  child: ListView.builder(
                      itemCount: myUser.userTopics.length,
                      itemBuilder: (BuildContext context, int index) {
                        UserTopic userTopic = myUser.userTopics[index];
                        return ItemLibraryRecent(myUser: myUser, userTopic: userTopic);
                      }
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


