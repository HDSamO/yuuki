import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:yuuki/models/question_answer.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/customs/custom_notification_dialog.dart';

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
        : const Color(0xFFFA6900));

    Color itemColor = (questionAnswer.check
        ? Colors.white
        : Colors.black);

    FlutterTts flutterTts = FlutterTts();

    return GestureDetector(
        onTap: () {
          _showDialog(context);
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: backgroundColor,
          child: Container(
            width: double.infinity,
            height: 42,
            margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 26, right: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${questionAnswer.vocabulary.term} : ${questionAnswer.vocabulary.definition}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: itemColor,
                          ),
                        ),
                      ),
                      IconButton(
                        alignment: Alignment.centerRight,
                        onPressed: () {
                          speak(flutterTts, questionAnswer.vocabulary.term, isEnVi);
                        },
                        icon: Icon(
                          Icons.volume_up,
                          size: 30,
                          color: itemColor,
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ),
        )
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomNotificationDialog(
            title: "Your answer",
            message: questionAnswer.answer.isEmpty ? "The answer is empty" : questionAnswer.answer,
            isSuccess: questionAnswer.check
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


