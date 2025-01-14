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
import '../utils/const.dart';
import '../utils/demension.dart';
import '../widgets/customs/custom_notification_dialog.dart';
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
  late String _folderId = "";
  final FolderService _folderService = FolderService();
  final TopicController _topicController = TopicController();
  late Future<List<Topic>> _futureTopicNotInFolder;
  late List<UserTopic> _userTopicInFolder = [];

  @override
  void initState() {
    super.initState();
    _myUser = widget.myUser;
    _folderId = widget.folder.id!;
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
                              width: 36,
                              height: 36,
                            ),
                          ),
                        ),
                        SizedBox(height: 16,),
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
                                      fontSize: 24,
                                      fontFamily: "Quicksand",
                                    ),
                                  ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16,),
                        Text(
                          'Topic Not In Folder',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Cabin",
                            color: AppColors.mainColor,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        _buildTopicNotInFolders(),
                        SizedBox(height: Dimensions.height(context, 16),),
                        Text(
                          'Topic In Folder',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Cabin",
                            color: AppColors.mainColor,
                          ),
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

  void _addTopicToFolder(Topic topic) async{
    _showLoadingDialog();
    UserTopicResult userTopicResult = await _folderService.addTopicToFolder(widget.myUser, _folderId, topic.id);
    Navigator.pop(context); // Close the loading dialog

    if (userTopicResult.success){
      setState(() {
        _futureTopicNotInFolder = _topicController.fetchTopicsNotInFolder(_myUser, _folderId);
      });

      FolderResult folderResult = await _folderService.getFolderById(_myUser, _folderId);
      if (folderResult.success){
        setState(() {
          _userTopicInFolder = folderResult.folder!.topics;
        });
      } else {
        _showNotificationDialog("Error", folderResult.errorMessage!, false);
      }

      _showNotificationDialog("Success", "Topic added successfully!", true);
    } else {
      _showNotificationDialog("Error", userTopicResult.errorMessage!, false);
    }
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
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                textAlign: TextAlign.center,
                'Error: ${snapshot.error}',
                style: TextStyle(
                  fontSize: 24,
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
                      _addTopicToFolder(topics[index]);
                    },
                  );
                },
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  textAlign: TextAlign.center,
                  'The topic list is empty!',
                  style: TextStyle(
                    fontSize: 24,
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

  void _removeTopicFromFolder(UserTopic userTopic) async {
    try {
      // Show loading dialog
      _showLoadingDialog();

      // Attempt to delete the topic from the folder
      UserTopicResult userTopicResult = await _folderService.deleteUserTopicFromFolder(widget.myUser, _folderId, userTopic.id);

      // Close the loading dialog
      Navigator.pop(context);

      if (userTopicResult.success) {
        // Update the state with topics not in the folder
        setState(() {
          _futureTopicNotInFolder = _topicController.fetchTopicsNotInFolder(_myUser, _folderId);
        });

        // Fetch the updated folder details
        FolderResult folderResult = await _folderService.getFolderById(_myUser, _folderId);

        if (folderResult.success) {
          setState(() {
            _userTopicInFolder = folderResult.folder!.topics;
          });

          // Show success dialog
          _showNotificationDialog("Success", "Topic has been deleted!", true);
        } else {
          // Show error dialog if fetching folder details failed
          _showNotificationDialog("Error", folderResult.errorMessage!, false);
        }
      } else {
        // Show error dialog if deleting the topic failed
        _showNotificationDialog("Error", userTopicResult.errorMessage!, false);
      }
    } catch (e) {
      // Handle any unexpected errors
      Navigator.pop(context); // Ensure the loading dialog is closed
      _showNotificationDialog("Error", e.toString(), false);
    }
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
                _removeTopicFromFolder(_userTopicInFolder[index]);
              },
            );
          },
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            textAlign: TextAlign.center,
            'The topic list is empty!',
            style: TextStyle(
              fontSize: 24,
              color: Colors.red,
            ),
          ),
        ),
      );
    }
  }
}