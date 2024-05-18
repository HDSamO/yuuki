import 'package:flutter/material.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/models/vocabulary.dart';
import 'package:yuuki/services/topic_service.dart';
import 'package:yuuki/utils/const.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/customs/custom_fragment_scaffold.dart';
import 'package:yuuki/widgets/items/item_add_vocabulary.dart';

import '../models/topic.dart';
import '../results/topic_result.dart';
import '../results/user_topic_result.dart';

class AddPage extends StatefulWidget {
  final MyUser? user;
  AddPage({Key? key, required this.user}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  bool isPublic = true;
  List<ItemAddVocabulary> vocabularyItems = [];
  List<TextEditingController> termControllers = [];
  List<TextEditingController> definitionControllers = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isTitleEmpty = false;
  bool isDescriptionEmpty = false;
  TopicController topicController = TopicController();

  List<Vocabulary> _getVocabularies() {
    return List.generate(vocabularyItems.length, (index) {
      return Vocabulary(
        term: termControllers[index].text,
        definition: definitionControllers[index].text,
      );
    });
  }

  Future<TopicResult> _addTopic(Topic topic) async {
    return await topicController.addTopic(widget.user!, topic);
  }

  Future<UserTopicResult> _addTopicToUser(String topicId) async {
    return await topicController.addTopicToUser(topicId, widget.user!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomFragmentScaffold(
        pageName: 'Create Topic',
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  _buildTitleField(),
                  SizedBox(height: 20),
                  _buildDescriptionField(),
                  SizedBox(height: 20),
                  _buildPrivacyToggle(),
                  SizedBox(height: 20),
                  _buildVocabularySection(),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onCreatePressed,
        heroTag: 'uniqueTag',
        backgroundColor: AppColors.mainColor,
        label: Row(
          children: [
            Icon(Icons.create_rounded, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Create',
              style: TextStyle(
                fontSize: Dimensions.fontSize(context, 16),
                fontFamily: "QuicksandRegular",
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _finishAddTopic(){
    setState(() {
      titleController.clear();
      descriptionController.clear();
      vocabularyItems.clear();
      termControllers.clear();
      definitionControllers.clear();
    });
  }

  void _onCreatePressed() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      setState(() {
        isTitleEmpty = titleController.text.isEmpty;
        isDescriptionEmpty = descriptionController.text.isEmpty;
      });
    } else if (termControllers.any((controller) => controller.text.isEmpty) ||
        definitionControllers.any((controller) => controller.text.isEmpty)) {
      _showValidateDialog("Please enter term or definition!");
    } else {
      _showLoadingDialog();
      try {
        Topic topic = Topic.fromUserCreated(
          widget.user!,
          titleController.text,
          descriptionController.text,
          _getVocabularies(),
          !isPublic,
        );

        TopicResult topicResult = await _addTopic(topic);
        if (!topicResult.success){
          _showErrorDialog(topicResult.errorMessage!);
        }

        UserTopicResult userTopicResult = await _addTopicToUser(topicResult.topic!.id);
        if (!userTopicResult.success){
          _showErrorDialog(userTopicResult.errorMessage!);
        }

        _finishAddTopic();
        Navigator.of(context).pop(); // Close the loading dialog
        _showSuccessDialog();
      } catch (error) {
        Navigator.of(context).pop(); // Close the loading dialog
        _showErrorDialog(error.toString());
      }
    }
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Topic added successfully!"),
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

  void _showValidateDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
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
                    "Notification",
                    style: TextStyle(
                      fontSize: Dimensions.fontSize(context, 20),
                      fontFamily: "Quicksand",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: Dimensions.fontSize(context, 16),
                      fontFamily: "QuicksandRegular",
                      color: Color(0xffec5b5b),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(
                      fontSize: Dimensions.fontSize(context, 16),
                      fontFamily: "QuicksandRegular",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 40,
                    ),
                    backgroundColor: AppColors.mainColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleField() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(bottom: 8),
          child: Text(
            "Title",
            style: TextStyle(
              fontSize: Dimensions.fontSize(context, 16),
              fontFamily: "Quicksand",
              color: Colors.black,
            ),
          ),
        ),
        TextField(
          controller: titleController,
          onChanged: (_) {
            setState(() {
              isTitleEmpty = false;
            });
          },
          keyboardType: TextInputType.text,
          cursorColor: Colors.blue,
          maxLines: null,
          cursorErrorColor: Colors.red,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: isTitleEmpty && titleController.text.isEmpty
                    ? Colors.red
                    : Colors.blue,
                width: 2.0,
              ),
            ),
            hintText: 'Enter a title',
            errorText: isTitleEmpty && titleController.text.isEmpty
                ? 'Title cannot be empty'
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(bottom: 8),
          child: Text(
            "Description",
            style: TextStyle(
              fontSize: Dimensions.fontSize(context, 16),
              fontFamily: "Quicksand",
              color: Colors.black,
            ),
          ),
        ),
        TextField(
          controller: descriptionController,
          onChanged: (_) {
            setState(() {
              isDescriptionEmpty = false;
            });
          },
          keyboardType: TextInputType.text,
          maxLines: null,
          cursorColor: Colors.blue,
          cursorErrorColor: Colors.red,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: isDescriptionEmpty &&
                    descriptionController.text.isEmpty
                    ? Colors.red
                    : Colors.blue,
                width: 2.0,
              ),
            ),
            hintText: 'Enter a description',
            errorText: isDescriptionEmpty &&
                descriptionController.text.isEmpty
                ? 'Description cannot be empty'
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              isPublic = !isPublic;
            });
          },
          icon:
          isPublic ? Icon(Icons.lock_open) : Icon(Icons.lock),
          label: Text(
            isPublic ? "Public" : "Private",
            style: TextStyle(
              fontSize: Dimensions.fontSize(context, 16),
              fontFamily: "QuicksandRegular",
              color: AppColors.mainColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding:
            EdgeInsets.symmetric(vertical: 8, horizontal: 44),
            foregroundColor: AppColors.mainColor,
            side: BorderSide(color: AppColors.mainColor),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.import_export, color: Colors.white),
          label: Text(
            "Import",
            style: TextStyle(
              fontSize: Dimensions.fontSize(context, 16),
              fontFamily: "QuicksandRegular",
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainColor,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 44),
          ),
        ),
      ],
    );
  }

  void removeItem(TextEditingController termController, TextEditingController definitionController) {
    int index = termControllers.indexOf(termController);
    if (index != -1) {
      setState(() {
        vocabularyItems.removeAt(index);
        termControllers.removeAt(index);
        definitionControllers.removeAt(index);
      });
    }
  }

  Widget _buildVocabularySection() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Vocabularies",
              style: TextStyle(
                fontSize: Dimensions.fontSize(context, 16),
                fontFamily: "Quicksand",
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                TextEditingController termController = TextEditingController();
                TextEditingController definitionController = TextEditingController();
                termControllers.add(termController);
                definitionControllers.add(definitionController);
                vocabularyItems.add(
                  ItemAddVocabulary(
                    key: UniqueKey(),
                    termController: termController,
                    definitionController: definitionController,
                    onRemove: () {
                      removeItem(termController, definitionController);
                    },
                  ),
                );
              });
            },
            icon: Icon(
                Icons.add,
              color: Colors.white,
            ),
            label: Text(
                "Add Vocabulary",
              style: TextStyle(
                color: Colors.white
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            ),
          ),
          SizedBox(height: 8),
          Column(
            children: [
              ...List.generate(vocabularyItems.length, (index) {
                return vocabularyItems[index];
              }),
            ],
          ),
        ],
      ),
    );
  }
}
