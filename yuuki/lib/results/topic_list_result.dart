import 'package:yuuki/models/topic.dart';

class TopicListResult {
  final bool success;
  final List<Topic>? topics;
  final String? errorMessage;

  TopicListResult({required this.success, this.topics, this.errorMessage,});
}