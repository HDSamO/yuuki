import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yuuki/results/folder_result.dart';
import 'package:yuuki/results/user_topic_result.dart';
import 'package:yuuki/services/folder_service.dart';
import 'package:yuuki/services/topic_service.dart';
import 'package:yuuki/widgets/items/item_topic_folder.dart';

import '../models/folder.dart';
import '../models/my_user.dart';
import '../models/topic.dart';
import '../models/user_topic.dart';
import '../utils/demension.dart';
import '../widgets/customs/custom_login_button.dart';
import '../widgets/items/item_user_topic_folder.dart';

class FolderDetailScreen extends StatefulWidget {
  final MyUser myUser;
  final Folder folder;

  const FolderDetailScreen({
    super.key,
    required this.myUser,
    required this.folder,
  });

  @override
  State<FolderDetailScreen> createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends State<FolderDetailScreen> {
  late MyUser _myUser;
  late String _folerId;
  final FolderService _folderService = FolderService();
  final TopicController _topicController = TopicController();
  late Future<List<Topic>> _futureTopicNotInFolder;
  late List<UserTopic> _userTopicInFolder = [];

  @override
  void initState() {
    super.initState();
    _myUser = widget.myUser;
    _folerId = widget.folder.id!;
    _futureTopicNotInFolder = _topicController.fetchTopicsNotInFolder(_myUser, widget.folder.id!);
    _userTopicInFolder = List.from(widget.folder.topics);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget> [
                    // Back Button
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        SizedBox(height: Dimensions.height(context, 16),),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.folder_open,
                                size: 28,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "Current folder: ${widget.folder.folderName}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: Dimensions.fontSize(context, 24),
                                      fontFamily: "Quicksand",
                                    ),
                                  ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimensions.height(context, 16),),
                        Text(
                          'Topic Not In Folder',
                          style: TextStyle(fontSize: 20, fontFamily: "Cabin"),
                        ),
                        const SizedBox(height: 10,),
                        _buildTopicNotInFolders(),
                        SizedBox(height: Dimensions.height(context, 16),),
                        Text(
                          'Topic In Folder',
                          style: TextStyle(fontSize: 20, fontFamily: "Cabin"),
                        ),
                        const SizedBox(height: 10,),
                        _buildTopicInFolder(),
                      ],
                    ),
                  ],
                )
            ),
          ],
        ),
      )
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

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("Error: $message"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopicNotInFolders() {
    return FutureBuilder<List<Topic>>(
      future: _futureTopicNotInFolder,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: EdgeInsets.all(Dimensions.fontSize(context, 20)),
            child: Center(
              child: Text(
                textAlign: TextAlign.center,
                'Error: ${snapshot.error}',
                style: TextStyle(
                  fontSize: Dimensions.fontSize(context, 24),
                  color: Colors.red,
                ),
              ),
            ),
          );
        } else {
          if (snapshot.data!.isNotEmpty) {
            List<Topic> topics = snapshot.data!;

            return Container(
              height: Dimensions.height(context, 300),
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: topics.length,
                itemBuilder: (BuildContext context, int index) {
                  return ItemTopicFolder(
                    myUser: _myUser,
                    topic: topics[index],
                    onAdd: () async {
                      _showLoadingDialog();

                      UserTopicResult userTopicResult = await _folderService.addTopicToFolder(widget.myUser, _folerId, topics[index].id);
                      Navigator.pop(context); // Close the loading dialog

                      if (userTopicResult.success){
                        setState(() {
                          _futureTopicNotInFolder = _topicController.fetchTopicsNotInFolder(_myUser, _folerId);
                        });

                        FolderResult folderResult = await _folderService.getFolderById(_myUser, _folerId);
                        if (folderResult.success){
                          setState(() {
                            _userTopicInFolder = folderResult.folder!.topics;
                          });
                        } else {
                          _showErrorDialog(folderResult.errorMessage!);
                        }

                        _showSuccessDialog("Topic added successfully!");
                      } else {
                        _showErrorDialog(userTopicResult.errorMessage!);
                      }
                    },
                  );
                },
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.all(Dimensions.fontSize(context, 20)),
              child: Center(
                child: Text(
                  textAlign: TextAlign.center,
                  'The topic list is empty!',
                  style: TextStyle(
                    fontSize: Dimensions.fontSize(context, 24),
                    color: Colors.red,
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }

  Widget _buildTopicInFolder(){
    if (_userTopicInFolder.isNotEmpty){
      return Container(
        height: Dimensions.height(context, 300),
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: _userTopicInFolder.length,
          itemBuilder: (BuildContext context, int index) {
            return ItemUserTopicFolder(
              myUser: _myUser,
              userTopic: _userTopicInFolder[index],
              onRemove: () {
                // Implement remove functionality
              },
            );
          },
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(Dimensions.fontSize(context, 20)),
        child: Center(
          child: Text(
            textAlign: TextAlign.center,
            'The topic list is empty!',
            style: TextStyle(
              fontSize: Dimensions.fontSize(context, 24),
              color: Colors.red,
            ),
          ),
        ),
      );
    }
  }
}