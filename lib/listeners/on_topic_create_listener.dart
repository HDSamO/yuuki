import 'package:yuuki/models/topic.dart';

abstract class OnTopicCreateListener {
    void onTopicCreateSucess(String topicId);
    void onTopicCreateFailure(String? message);
}