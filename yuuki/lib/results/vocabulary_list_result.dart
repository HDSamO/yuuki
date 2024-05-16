import 'package:yuuki/models/vocabulary.dart';

class VocabularyListResult {
  final bool success;
  final List<Vocabulary>? vocabularies;
  final String? errorMessage;

  VocabularyListResult({required this.success, this.vocabularies, this.errorMessage,});
}