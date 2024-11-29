
import 'package:yuuki/models/topic.dart';
import 'package:yuuki/models/user_topic.dart';

abstract class OnUserTopicCreateListener {
    void onUserTopicCreateSuccess(UserTopic userTopic);
    void onUserTopicCreateFailure(String? message);
}