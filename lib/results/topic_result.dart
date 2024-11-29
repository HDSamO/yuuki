import 'package:yuuki/models/topic.dart';

class TopicResult {
  final bool success;
  final Topic? topic;
  final String? errorMessage;

  TopicResult({required this.success, this.topic, this.errorMessage,});
}