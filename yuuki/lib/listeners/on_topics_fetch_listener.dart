
import 'package:yuuki/models/topic.dart';

abstract class OnTopicsFetchListener {
    void onTopicsFetchSuccess(List<Topic> topicId);
    void onTopicsFetchFailure(String? message);
}