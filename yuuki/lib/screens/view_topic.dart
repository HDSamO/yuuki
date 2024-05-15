import 'package:flutter/material.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/utils/const.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/customs/custom_fragment_scaffold.dart';
import 'package:yuuki/widgets/items/item_add_vocabulary.dart';

class ViewTopic extends StatefulWidget {
  final MyUser? user;
  ViewTopic({Key? key, required this.user, required this.userTopic})
      : super(key: key);
  final UserTopic userTopic;

  @override
  State<ViewTopic> createState() => _ViewTopicState();
}

class _ViewTopicState extends State<ViewTopic> {
  late bool isPublic = false;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.userTopic.title;
    descriptionController.text = widget.userTopic.description;
    isPublic = widget.userTopic.private;
  }

  List<ItemAddVocabulary> vocabularyItems = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isTitleEmpty = false;
  bool isDescriptionEmpty = false;

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
                    enabled: false,
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
                    enabled: false,
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
                      // ElevatedButton.icon(
                      //   onPressed: () {},
                      //   icon: Icon(Icons.import_export, color: Colors.white),
                      //   label: Text(
                      //     "Import",
                      //     style: TextStyle(
                      //       fontSize: Dimensions.fontSize(context, 16),
                      //       fontFamily: "QuicksandRegular",
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: AppColors.mainColor,
                      //     padding:
                      //         EdgeInsets.symmetric(vertical: 8, horizontal: 48),
                      //   ),
                      // ),
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
                          setState(() {
                            vocabularyItems.add(ItemAddVocabulary(
                              onRemove: () {
                                setState(() {
                                  vocabularyItems.removeLast();
                                });
                              },
                              termController: TextEditingController(),
                              definitionController: TextEditingController(),
                            ));
                          });
                        },
                        icon: Icon(Icons.post_add, color: Colors.black),
                      )
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.userTopic.vocabularies.length,
                    itemBuilder: (context, index) {
                      var vocabulary = widget.userTopic.vocabularies[index];
                      return ItemAddVocabulary(
                        onRemove: () {
                          setState(() {
                            widget.userTopic.vocabularies.removeAt(index);
                          });
                        },
                        termController:
                            TextEditingController(text: vocabulary.term),
                        definitionController:
                            TextEditingController(text: vocabulary.definition),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (titleController.text.isEmpty ||
              descriptionController.text.isEmpty) {
            setState(() {
              isTitleEmpty = titleController.text.isEmpty;
              isDescriptionEmpty = descriptionController.text.isEmpty;
            });
          } else if (vocabularyItems.any((item) =>
              item.termController.text.isEmpty ||
              item.definitionController.text.isEmpty)) {
          } else {}
        },
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
}
