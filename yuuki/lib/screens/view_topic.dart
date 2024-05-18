import 'package:flutter/material.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/models/topic.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/models/vocabulary.dart';
import 'package:yuuki/results/topic_result.dart';
import 'package:yuuki/services/topic_service.dart';
import 'package:yuuki/utils/const.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/customs/custom_fragment_scaffold.dart';
import 'package:yuuki/widgets/items/item_add_vocabulary.dart';
import 'package:yuuki/widgets/items/item_view_topic.dart';

class ViewTopic extends StatefulWidget {
  final MyUser user;
  final UserTopic userTopic;

  const ViewTopic({
    super.key,
    required this.user,
    required this.userTopic,
  });

  @override
  State<ViewTopic> createState() => _ViewTopicState();
}

class _ViewTopicState extends State<ViewTopic> {
  late bool isPrivate;
  late String userName;
  late String authorName;
  final TopicController topicController = TopicController();

  late List<ItemViewTopic> vocabularyItems = [];
  List<TextEditingController> termControllers = [];
  List<TextEditingController> definitionControllers = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isTitleEmpty = false;
  bool isDescriptionEmpty = false;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.userTopic.title;
    descriptionController.text = widget.userTopic.description;
    isPrivate = widget.userTopic.private;
    userName = widget.user.name ?? '';
    authorName = widget.userTopic.authorName ?? '';
    topicController.viewTopic(widget.user, widget.userTopic.id);
    _fetchVocabularyItems(widget.userTopic.vocabularies);
  }

  @override
  void dispose() {
    super.dispose();
    vocabularyItems.clear();
    termControllers.clear();
    definitionControllers.clear();
  }

  void _fetchVocabularyItems(List<Vocabulary> vocabularies){
    vocabularyItems.clear();
    termControllers.clear();
    definitionControllers.clear();

    for (Vocabulary vocabulary in vocabularies){
      TextEditingController termController = TextEditingController();
      TextEditingController definitionController = TextEditingController();

      termController.text = vocabulary.term;
      definitionController.text = vocabulary.definition;

      termControllers.add(termController);
      definitionControllers.add(definitionController);

      vocabularyItems.add(
        ItemViewTopic(
          key: UniqueKey(),
          termController: termController,
          definitionController: definitionController,
          onRemove: () {
            removeItem(termController, definitionController);
          },
          isEditing: isEditing,
          onTermChanged: (String term) {
            setState(() {
              termController.text = term;
            });
          },
          onDefinitionChanged: (String definition) {
            setState(() {
              definitionController.text = definition;
            });
          },
        ),
      );
    }
  }

  List<Vocabulary> _getVocabularies() {
    return List.generate(vocabularyItems.length, (index) {
      return Vocabulary(
        term: termControllers[index].text,
        definition: definitionControllers[index].text,
      );
    });
  }

  Future<void> _updateTopic() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      setState(() {
        isTitleEmpty = titleController.text.isEmpty;
        isDescriptionEmpty = descriptionController.text.isEmpty;
      });
    } else if (termControllers.any((controller) => controller.text.isEmpty) ||
        definitionControllers.any((controller) => controller.text.isEmpty)) {
      _showNotificationDialog("Error","Please enter terms or definitions of all vocabulary!", false);
    } else {
      _showLoadingDialog();
      try {
        Topic updatedTopic = Topic(
          id: widget.userTopic.id,
          title: titleController.text,
          description: descriptionController.text,
          private: isPrivate,
          authorName: authorName,
          vocabularies: _getVocabularies(),
          author: widget.userTopic.author,
        );

        TopicResult updateTopicResult = await topicController.updateTopic(updatedTopic, widget.user);

        if (!updateTopicResult.success){
          _showNotificationDialog("Error", updateTopicResult.errorMessage!, false);
        } else {
          TopicResult topicResult = await topicController.updateTopicOfUser(updateTopicResult.topic!.id);

          if (!topicResult.success){
            Navigator.of(context).pop(); // Close the loading dialog
            _showNotificationDialog("Error", topicResult.errorMessage!, false);
          } else {
            setState(() {
              isEditing = false;
              _fetchVocabularyItems(_getVocabularies());
            });
            Navigator.of(context).pop(); // Close the loading dialog
            _showNotificationDialog("Success", "Topic has been updated!", true);
          }
        }
      } catch (error) {
        Navigator.of(context).pop(); // Close the loading dialog
        _showNotificationDialog("Error", error.toString(), false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomFragmentScaffold(
        pageName: 'View Topic',
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 20),
                _buildTextField(
                  controller: titleController,
                  label: 'Title',
                  isEmpty: isTitleEmpty,
                  onChanged: (_) {
                    setState(() {
                      isTitleEmpty = false;
                    });
                  },
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: descriptionController,
                  label: 'Description',
                  isEmpty: isDescriptionEmpty,
                  onChanged: (_) {
                    setState(() {
                      isDescriptionEmpty = false;
                    });
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          isPrivate = !isPrivate;
                        });
                      },
                      icon: Icon(isPrivate ? Icons.lock : Icons.lock_open),
                      label: Text(
                        isPrivate ? "Private" : "Public",
                        style: TextStyle(
                          fontSize: Dimensions.fontSize(context, 16),
                          fontFamily: "QuicksandRegular",
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 44),
                        foregroundColor: AppColors.mainColor,
                        side: BorderSide(color: AppColors.mainColor),
                      ),
                    ),
                    _buildEditButton(),
                  ],
                ),
                SizedBox(height: 20),
                _buildVocabularySection(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: isEditing
          ? FloatingActionButton.extended(
            onPressed: _updateTopic,
            heroTag: 'Edit',
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
                ),
              ],
            ),
          )
          : FloatingActionButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            heroTag: 'Exit',
            backgroundColor: AppColors.mainColor,
            child: Icon(Icons.arrow_back, color: Colors.white),
            ),
    );
  }

  Widget _buildEditButton() {
    bool canEdit = userName == authorName;

    return canEdit
        ? ElevatedButton.icon(
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
                _fetchVocabularyItems(_getVocabularies());
              });
            },
            icon: Icon(
              isEditing ? Icons.cancel : Icons.edit,
              color: isEditing ? AppColors.mainColor : Colors.white,
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
          )
        : SizedBox();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool isEmpty,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.fontSize(context, 16),
              fontFamily: "Quicksand",
              color: Colors.black,
            ),
          ),
        ),
        TextField(
          enabled: isEditing,
          controller: controller,
          onChanged: onChanged,
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
                color: isEmpty && controller.text.isEmpty
                    ? Colors.red
                    : Colors.blue,
                width: 2.0,
              ),
            ),
            hintText: 'Enter a $label',
            errorText: isEmpty && controller.text.isEmpty
                ? '$label cannot be empty'
                : null,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            if (isEditing)
              IconButton(
                onPressed: () {
                  setState(() {
                    TextEditingController termController = TextEditingController();
                    TextEditingController definitionController = TextEditingController();

                    termControllers.add(termController);
                    definitionControllers.add(definitionController);

                    vocabularyItems.add(
                      ItemViewTopic(
                        key: UniqueKey(),
                        termController: termController,
                        definitionController: definitionController,
                        onRemove: () {
                          removeItem(termController, definitionController);
                        },
                        isEditing: isEditing,
                        onTermChanged: (String term) {
                          setState(() {
                            termController.text = term;
                          });
                        },
                        onDefinitionChanged: (String definition) {
                          setState(() {
                            definitionController.text = definition;
                          });
                        },
                      ),
                    );
                  });
                },
                icon: Icon(Icons.post_add, color: Colors.black),
              ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: vocabularyItems.length,
          itemBuilder: (context, index) {
            return vocabularyItems[index];
          },
          reverse: true,
        ),
      ],
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