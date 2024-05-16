import 'package:yuuki/models/question_answer.dart';

class LearningResult {
  // Assuming QuestionAnswer class is already defined (refer to previous conversion)
  final List<QuestionAnswer> questionAnswers;
  double? avgScore;
  int? rawTime;
  String? formattedTime;

  LearningResult({required this.questionAnswers}) {
    calculateAvgScore();
  }

  void calculateAvgScore() {
    final totalAnswers = questionAnswers.length;
    var correctAnswers = 0;

    for (final questionAnswer in questionAnswers) {
      if (questionAnswer.check) {
        correctAnswers++;
      }
    }

    avgScore = (correctAnswers * 100) / totalAnswers;
  }

  String? convertRawTimeToFormattedTime() {
    final hours = Duration(milliseconds: rawTime!).inHours;
    final minutes = Duration(milliseconds: rawTime!).inMinutes % 60;
    final seconds = Duration(milliseconds: rawTime!).inSeconds % 60;

    formattedTime =
        "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    return formattedTime;
  }

  List<QuestionAnswer> getCorrectAnswers() {
    final correctAnswersList = <QuestionAnswer>[];

    for (final questionAnswer in questionAnswers) {
      if (questionAnswer.check) {
        correctAnswersList.add(questionAnswer);
      }
    }

    return correctAnswersList;
  }
}
