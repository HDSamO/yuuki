import 'package:flutter/material.dart';
import 'package:yuuki/services/topic_service.dart';

import '../models/my_user.dart';
import '../models/user_topic.dart';
import '../models/vocabulary.dart';
import '../results/vocabulary_list_result.dart';
import '../utils/demension.dart';
import '../widgets/items/item_starred_vocabulary.dart';

class StarredVocabulariesScreen extends StatefulWidget {
  final MyUser myUser;

  const StarredVocabulariesScreen({
    super.key,
    required this.myUser,
  });

  @override
  State<StarredVocabulariesScreen> createState() => _StarredVocabulariesScreenState();
}

class _StarredVocabulariesScreenState extends State<StarredVocabulariesScreen> {
  final TopicController topicController = TopicController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(32, 24, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          'assets/images/learning/img_arrow_left.png',
                          width: Dimensions.width(context, 36),
                          height: Dimensions.height(context, 36),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Starred Vocabularies",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Jua',
                              fontSize: Dimensions.fontSize(context, 30),
                              color: Color(0xFFFCEC0A),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStarredVocabularies(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStarredVocabularies(BuildContext context){
    if (widget.myUser.starredTopic!.vocabularies.isEmpty){
      return Padding(
        padding: EdgeInsets.all(Dimensions.fontSize(context, 20)),
        child: Center(
          child: Text(
            textAlign: TextAlign.center,
            "The list is empty!",
            style: TextStyle(
                fontSize: Dimensions.fontSize(context, 24),
                color: Colors.red
            ),
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.myUser.starredTopic!.vocabularies.length,
      itemBuilder: (context, index) {
        return ItemStarredVocabulary(
          myUser: widget.myUser,
          vocabulary: widget.myUser.starredTopic!.vocabularies[index],
        );
      },
    );
  }
}