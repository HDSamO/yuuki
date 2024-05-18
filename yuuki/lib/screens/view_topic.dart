import 'package:flutter/material.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/models/topic.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/models/vocabulary.dart';
import 'package:yuuki/results/topic_result.dart';
import 'package:yuuki/results/user_topic_result.dart';
import 'package:yuuki/services/topic_service.dart';
import 'package:yuuki/utils/const.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/customs/custom_fragment_scaffold.dart';
import 'package:yuuki/widgets/items/item_add_vocabulary.dart';
import 'package:yuuki/widgets/items/item_view_topic.dart';

import '../services/topic_service.dart';

class ViewTopic extends StatefulWidget {
  final MyUser user;
  ViewTopic({Key? key, required this.user, required this.userTopic})
      : super(key: key);
  final UserTopic userTopic;

  @override
  State<ViewTopic> createState() => _ViewTopicState();
}

class _ViewTopicState extends State<ViewTopic> {
  late bool isPublic = false;
  late String userName = '';
  late String authorName = '';
  bool isEditing = false;
  final TopicController topicController = TopicController();
  List<ItemAddVocabulary> listVocabularyItems = [];
  List<TextEditingController> termControllers = [];
  List<TextEditingController> definitionControllers = [];

  @override
  void initState() {
    super.initState();
    titleController.text = widget.userTopic.title;
    descriptionController.text = widget.userTopic.description;
    isPublic = widget.userTopic.private;
    userName = widget.user.name ?? '';
    authorName = widget.userTopic.authorName ?? '';
    topicController.viewTopic(widget.user, widget.userTopic.id);
  }

  List<ItemAddVocabulary> vocabularyItems = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isTitleEmpty = false;
  bool isDescriptionEmpty = false;

  Widget buildEditButton() {
    bool canEdit = userName ==
        authorName; // Kiểm tra xem userName và authorName có giống nhau không

    if (canEdit) {
      return ElevatedButton.icon(
        onPressed: () {
          setState(() {
            isEditing = !isEditing;
          });
        },
        icon: isEditing
            ? Icon(
                Icons.cancel,
                color: AppColors.mainColor,
              )
            : Icon(
                Icons.edit,
                color: Colors.white,
              ),
        label: Text(
          isEditing ? "Cancel" : "Edit",
          style: TextStyle(
            fontSize: Dimensions.fontSize(context, 16),
            fontFamily: "QuicksandRegular",
            color: isEditing ? AppColors.mainColor : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isEditing ? Colors.white : AppColors.mainColor,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 44),
          side: isEditing
              ? BorderSide(color: AppColors.mainColor)
              : BorderSide.none,
        ),
      );
    } else {
      return SizedBox(); // Trả về widget trống nếu không thể chỉnh sửa
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomFragmentScaffold(
        pageName: 'View Topic',
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 20),
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
                    enabled: isEditing,
                    controller: titleController,
                    onChanged: (_) {
                      setState(() {
                        isTitleEmpty = false;
                      });
                    },
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
                  SizedBox(height: 20),
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
                    enabled: isEditing,
                    controller: descriptionController,
                    onChanged: (_) {
                      setState(() {
                        isDescriptionEmpty = false;
                      });
                    },
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
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {});
                        },
                        icon:
                            isPublic ? Icon(Icons.lock_open) : Icon(Icons.lock),
                        label: Text(
                          isPublic ? "Private" : "Public",
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
                      buildEditButton(),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Vocabulary",
                        style: TextStyle(
                          fontSize: Dimensions.fontSize(context, 16),
                          fontFamily: "Quicksand",
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (isEditing) {
                            setState(() {
                              Vocabulary newVocabulary =
                                  Vocabulary(term: '', definition: '');

                              widget.userTopic.vocabularies.add(newVocabulary);

                              TextEditingController newTermController =
                                  TextEditingController();
                              TextEditingController newDefinitionController =
                                  TextEditingController();

                              vocabularyItems.add(
                                ItemAddVocabulary(
                                  onRemove: () {
                                    setState(() {
                                      widget.userTopic.vocabularies
                                          .removeLast();
                                      vocabularyItems.removeLast();
                                    });
                                  },
                                  termController: newTermController,
                                  definitionController: newDefinitionController,
                                ),
                              );
                            });
                          }
                        },
                        icon: isEditing
                            ? Icon(Icons.post_add, color: Colors.black)
                            : SizedBox(),
                      )
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.userTopic.vocabularies.length,
                    itemBuilder: (context, index) {
                      var vocabulary = widget.userTopic.vocabularies[index];
                      return ItemViewTopic(
                        onRemove: () {
                          setState(() {
                            widget.userTopic.vocabularies.removeAt(index);
                          });
                        },
                        termController:
                            TextEditingController(text: vocabulary.term),
                        definitionController:
                            TextEditingController(text: vocabulary.definition),
                        isEditing: isEditing,
                      );
                    },
                    reverse: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: isEditing
          ? FloatingActionButton.extended(
              onPressed: () async {
                if (titleController.text.isEmpty ||
                    descriptionController.text.isEmpty) {
                  setState(() {
                    isTitleEmpty = titleController.text.isEmpty;
                    isDescriptionEmpty = descriptionController.text.isEmpty;
                  });
                } else if (vocabularyItems.any((item) =>
                    item.termController.text.isEmpty ||
                    item.definitionController.text.isEmpty)) {
                } else {
                  Topic updatedTopic = Topic(
                    id: widget.userTopic.id,
                    title: titleController.text,
                    description: descriptionController.text,
                    private: isPublic,
                    authorName: authorName,
                    vocabularies: widget.userTopic.vocabularies,
                    author: widget.userTopic.author,
                  );
                  // Call updateTopic function
                  TopicResult result = await TopicController()
                      .updateTopic(updatedTopic, widget.user);
                  _showSuccessDialog();

                  if (result.success) {
                    setState(() {
                      isEditing = false;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result.errorMessage!)),
                    );
                  }
                }
              },
              heroTag: 'uniqueTag',
              backgroundColor: AppColors.mainColor,
              label: Row(
                children: [
                  Icon(Icons.update, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    'Update',
                    style: TextStyle(
                      fontSize: Dimensions.fontSize(context, 16),
                      fontFamily: "QuicksandRegular",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            )
          : null,
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: Dimensions.height(context, 180),
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
                    "Confirm Delete",
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
                    "topic has been updated",
                    style: TextStyle(
                      fontSize: Dimensions.fontSize(context, 16),
                      fontFamily: "QuicksandRegular",
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                      child: Text(
                        "oke",
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
