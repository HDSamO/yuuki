import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yuuki/services/topic_service.dart';
import 'package:yuuki/widgets/item_library_progress.dart';

import '../models/my_user.dart';
import '../models/user_topic.dart';
import 'item_library_recent.dart';

class LibraryTopics extends StatefulWidget {
  const LibraryTopics({super.key, required this.myUser});
  final MyUser myUser;

  @override
  State<LibraryTopics> createState() => _LibraryTopicsState();
}

class _LibraryTopicsState extends State<LibraryTopics> {
  late MyUser _myUser;
  final TopicController _topicController = TopicController();

  @override
  void initState() {
    super.initState();
    _myUser = widget.myUser;
  }

  Future<List<UserTopic>> futureUserTopics() async {
    return await _topicController.getRecentTopics(_myUser);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureUserTopics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError){
            return Text('Error: ${snapshot.error}');
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
                        ItemLibraryProgress(myUser: _myUser, userTopic: snapshot.data!.first)
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
                              return ItemLibraryRecent(myUser: _myUser, userTopic: snapshot.data![index]);
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
}


