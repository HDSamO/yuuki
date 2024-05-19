import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/models/vocabulary.dart';
import 'package:yuuki/utils/demension.dart';

import '../../screens/choose_language_screen.dart';

class ItemStarredVocabulary extends StatefulWidget {
  final MyUser myUser;
  final Vocabulary vocabulary;

  const ItemStarredVocabulary({
    super.key,
    required this.myUser,
    required this.vocabulary,
  });

  @override
  State<ItemStarredVocabulary> createState() => _ItemStarredVocabularyState();
}

class _ItemStarredVocabularyState extends State<ItemStarredVocabulary> {
  late FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Center(
              child: Row(
                children: [
                  Expanded(
                      child: Row(
                        children: [
                          _buildItemInfo(
                            context,
                            widget.vocabulary.term,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            ":",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontFamily: "QuicksandRegular",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          _buildItemInfo(
                            context,
                            widget.vocabulary.definition,
                          ),
                        ],
                      )
                  ),
                  IconButton(
                    onPressed: () {
                      speak(widget.vocabulary.term);
                    },
                    icon: Icon(
                      Icons.volume_up,
                      size: 48,
                      color: Colors.black,
                    ),
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }

  void speak(String text) async {
    String languageCode = "en-US";

    await flutterTts.setLanguage(languageCode);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  Widget _buildItemInfo(BuildContext context, String text) {
    return Container(
      alignment: Alignment.center,
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: Dimensions.height(context, 8)),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(217, 240, 255, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontFamily: "QuicksandRegular",
        ),
      ),
    );
  }

}
