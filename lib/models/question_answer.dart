import 'package:yuuki/models/vocabulary.dart';

class QuestionAnswer {
  final Vocabulary vocabulary;
  final String answer;
  final bool check;

  QuestionAnswer({
    required this.vocabulary,
    required this.answer,
    required this.check,
  });
}
