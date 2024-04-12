import 'package:yuuki/models/topic.dart';
import 'package:yuuki/models/user_topic.dart';

class UserTopicResult {
  final bool success;
  final UserTopic? userTopic;
  final String? errorMessage;

  UserTopicResult({required this.success, this.userTopic, this.errorMessage,});
}