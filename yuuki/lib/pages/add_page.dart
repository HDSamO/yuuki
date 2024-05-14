import 'package:flutter/material.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/utils/const.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/customs/custom_fragment_scaffold.dart';
import 'package:yuuki/widgets/items/item_add_vocabulary.dart';

class AddPage extends StatefulWidget {
  final MyUser? user;
  AddPage({Key? key, required this.user}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  bool isPublic = true;
  List<ItemAddVocabulary> vocabularyItems = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isTitleEmpty = false;
  bool isDescriptionEmpty = false;

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
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 48),
                        ),
                      ),
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
                    itemCount: vocabularyItems.length,
                    itemBuilder: (context, index) {
                      return ItemAddVocabulary(
                        onRemove: () {
                          setState(() {
                            vocabularyItems.removeAt(index);
                          });
                        },
                        termController: TextEditingController(),
                        definitionController: TextEditingController(),
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
            // Nếu có ít nhất một TextField trong vocabularyItems trống
            // Hiển thị thông báo hoặc thực hiện hành động phù hợp
          } else {
            // Thực hiện hành động tạo mới với tiêu đề, mô tả và tất cả các trường vocabularyItems không rỗng
          }
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
