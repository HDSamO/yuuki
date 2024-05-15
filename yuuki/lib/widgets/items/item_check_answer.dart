import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:yuuki/models/question_answer.dart';
import 'package:yuuki/utils/demension.dart';

class ItemCheckAnswer extends StatelessWidget {
  final QuestionAnswer questionAnswer;
  final bool isEnVi;

  const ItemCheckAnswer({
    super.key,
    required this.questionAnswer,
    required this.isEnVi
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = (questionAnswer.check
        ? const Color(0xFF397CFF)
        : const Color(0x80FA6900));

    Color itemColor = (questionAnswer.check
        ? Colors.white
        : Colors.black);

    FlutterTts flutterTts = FlutterTts();

    return GestureDetector(
      onTap: () {
        _showDialog(context);
      },
      child: Container(
        width: double.infinity,
        height: 54,
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(27),
          color: backgroundColor,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 26, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "${questionAnswer.vocabulary.term} : ${questionAnswer.vocabulary.definition}",
                    style: TextStyle(
                      fontSize: Dimensions.fontSize(context, 18),
                      fontWeight: FontWeight.bold,
                      color: itemColor,
                    ),
                  ),
                ),
                IconButton(
                  alignment: Alignment.topRight,
                  onPressed: () {
                    speak(flutterTts, questionAnswer.vocabulary.term, isEnVi);
                  },
                  icon: Icon(
                    Icons.volume_up,
                    size: Dimensions.iconSize(context, 36),
                    color: itemColor,
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              "Your answer",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold
            ),
          ),
          content: Text(
            questionAnswer.answer.isEmpty ? "The answer is empty" : questionAnswer.answer,
            style: TextStyle(
              fontSize: Dimensions.fontSize(context, 18),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void speak(FlutterTts flutterTts, String text, bool isEnVi) async {
    String languageCode = isEnVi ? "en-US" : "vi-VN";

    await flutterTts.setLanguage(languageCode);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

}


