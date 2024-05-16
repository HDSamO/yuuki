import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/screens/score_screen.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/customs/custom_primary_button.dart';

import '../models/learning_result.dart';
import '../models/question_answer.dart';
import '../models/vocabulary.dart';
import '../services/topic_service.dart';
import '../widgets/items/item_quiz.dart';

class QuizScreen extends StatefulWidget {
  final MyUser myUser;
  final UserTopic userTopic;
  final bool isEnVi;

  const QuizScreen({
    super.key,
    required this.myUser,
    required this.userTopic,
    required this.isEnVi,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _index = 0;
  int _currentVocabulary = 1;
  Timer? _timer;
  int _milliseconds = 59000;
  List<QuestionAnswer> _questionAnswers = [];
  final TopicController _topicController = TopicController();
  String _selectedOption = '';

  late int _totalVocabulary;
  late double _progress;
  late List<Vocabulary> _updatedVocabularies = [];
  late List<Vocabulary> _randomVocabularies = [];
  late bool _isEnVi;
  late FlutterTts flutterTts = FlutterTts();

  List<Vocabulary> _swappedVocabularies(List<Vocabulary> vocabularies){
    List<Vocabulary> newVocabularies = [];

    for (var vocabulary in vocabularies) {
      String tempTerm = vocabulary.term;
      String tempDefinition = vocabulary.definition;

      // Create a new Vocabulary object with swapped values
      Vocabulary swappedVocabulary = Vocabulary(
        term: tempDefinition,
        definition: tempTerm,
      );

      newVocabularies.add(swappedVocabulary);
    }

    return newVocabularies;
  }

  List<Vocabulary> _getRandomVocabularies(List<Vocabulary> vocabularies, Vocabulary currentVocabulary) {
    List<Vocabulary> randomVocabularies;

    if (vocabularies.length < 4) {
      randomVocabularies = [
        currentVocabulary,
        Vocabulary(term: "none", definition: "none"),
        Vocabulary(term: "none", definition: "none"),
        Vocabulary(term: "none", definition: "none"),
      ];
    } else {
      List<Vocabulary> temp = List.from(vocabularies);
      temp.shuffle();

      randomVocabularies =  temp.where((vocabulary) => vocabulary.term != currentVocabulary.term).take(3).toList();
      randomVocabularies.add(currentVocabulary);
    }

    randomVocabularies.shuffle();
    return randomVocabularies;
  }

  void startCountDownTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_milliseconds < 1000) {
        _handleTimerFinish();
      } else {
        setState(() {
          _milliseconds -= 1000; // Giảm đi một giây
        });
      }
    });
  }

  void resetTimer() {
    // Hủy timer hiện tại nếu đang chạy
    if (_timer != null) {
      _timer!.cancel();
    }

    // Reset lại giá trị của bộ đếm
    _milliseconds = 59000;
    startCountDownTimer(); // Bắt đầu bộ đếm mới
  }

  void _handleTimerFinish() {
    if (_milliseconds <= 0) {
      if (_index + 1 >= _totalVocabulary) {
        // code here
      } else {
        _navigate(1);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _totalVocabulary = widget.userTopic.vocabularies.length;
    _progress = _currentVocabulary / _totalVocabulary;
    _isEnVi = widget.isEnVi;

    if (!widget.isEnVi){
      _updatedVocabularies = _swappedVocabularies(widget.userTopic.vocabularies);
      _randomVocabularies = _getRandomVocabularies(_updatedVocabularies, _updatedVocabularies[0]);
    } else {
      _updatedVocabularies = widget.userTopic.vocabularies;
      _randomVocabularies = _getRandomVocabularies(_updatedVocabularies, _updatedVocabularies[0]);
    }

    startCountDownTimer();
    _topicController.startStudyUserTopic(widget.myUser, widget.userTopic.id);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Hàm callback để xử lý sự kiện khi lựa chọn được thay đổi
  void handleOptionSelected(String option) {
    setState(() {
      if (option.isEmpty){
        _selectedOption = "";
      }
      _selectedOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    LearningResult learningResult;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              "assets/images/onboarding/img_background.jpg",
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width(context, 20), vertical: Dimensions.height(context, 30)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Progress Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentVocabulary.toString(),
                            style: TextStyle(fontSize: Dimensions.fontSize(context, 20), color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: Dimensions.width(context, 8),),
                          Text(
                            "/",
                            style: TextStyle(fontSize: Dimensions.fontSize(context, 20), color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: Dimensions.width(context, 8),),
                          Text(
                            _totalVocabulary.toString(),
                            style: TextStyle(fontSize: Dimensions.fontSize(context, 20), color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Xác nhận"),
                                    content: Text("Bạn có muốn thoát không?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          getLearningResult(widget.myUser, widget.userTopic, _questionAnswers);

                                          Navigator.pop(context); // Close the dialog
                                          Navigator.pop(context); // Close the screen
                                        },
                                        child: Text("Có"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context); // Close the dialog
                                        },
                                        child: Text("Không"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.arrow_back, size: Dimensions.iconSize(context, 36),),
                          ),
                          SizedBox(width: Dimensions.width(context, 8)),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radius(context, 12)),
                              child: LinearProgressIndicator(
                                minHeight: _totalVocabulary.toDouble(),
                                value: _progress,
                                backgroundColor: Colors.grey[400],
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height(context, 10)),
                  // Functional Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: (){
                              speak(_updatedVocabularies[_index].term, _isEnVi);
                            },
                            icon: Icon(Icons.volume_up, size: Dimensions.iconSize(context, 36), color: Colors.black,),
                          ),
                          SizedBox(width: Dimensions.width(context, 10)),
                          Text(
                              "Listen",
                              style: TextStyle(
                                fontSize: Dimensions.fontSize(context, 24),
                              )
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.timer_outlined, size: Dimensions.iconSize(context, 36),),
                          SizedBox(width: Dimensions.width(context, 10),),
                          Text(
                            "00:${_milliseconds ~/ 1000}",
                            style: TextStyle(
                              fontSize: Dimensions.fontSize(context, 24),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height(context, 16),),
                  // CustomViewPager
                  Flexible(
                    child: ItemQuiz(
                      vocabulary: _updatedVocabularies[_index],
                      vocabularies: _randomVocabularies,
                      onOptionSelected: handleOptionSelected,
                    ),
                  ),
                  SizedBox(height: Dimensions.height(context, 24)),
                  // Back and Next Buttons
                  CustomPrimaryButton(
                    onPressed: () async => {
                      _questionAnswers.add(QuestionAnswer(
                        vocabulary: _updatedVocabularies[_index],
                        answer: _selectedOption,
                        check: _updatedVocabularies[_index].definition == _selectedOption)),

                      // Kết thúc học và chuyển trang
                      if (_index == _totalVocabulary - 1) {
                        learningResult = await getLearningResult(widget.myUser, widget.userTopic, _questionAnswers),

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (e) => ScoreScreen(
                                myUser: widget.myUser,
                                userTopic: widget.userTopic,
                                learningResult: learningResult,
                                isEnVi: widget.isEnVi,
                              )
                          ),
                        ),
                      } else {
                        _navigate(1),
                      }
                    },
                    text: 'CHECK',
                    width: double.infinity,
                    height: Dimensions.height(context, 54),
                    color: Color(0xFF0947E8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<LearningResult> getLearningResult(MyUser myUser, UserTopic userTopic, List<QuestionAnswer> questionAnswers) async {
    // Calculate the learning result
    LearningResult learningResult = LearningResult(questionAnswers: questionAnswers);
    learningResult.calculateAvgScore();

    // Finish the study session for the user topic
    await _topicController.finishStudyUserTopic(
      myUser,
      userTopic.id,
      learningResult.avgScore ?? 0,
    );

    // Fetch the updated user topic
    UserTopic? updatedUserTopic = await _topicController.getUserTopicforUser(myUser, userTopic.id);

    // Process the raw time if the updated user topic is available
    if (updatedUserTopic != null) {
      saveRawTime(learningResult, updatedUserTopic);
    } else {
      print('Error: Unable to fetch updated UserTopic.');
    }

    _topicController.saveUserIfTopScorer(userTopic.id, myUser, learningResult.avgScore ?? 0.0, learningResult.rawTime ?? 0, userTopic.view);
    _topicController.saveUserIfTopViewer(userTopic.id, myUser, learningResult.avgScore ?? 0.0, learningResult.rawTime ?? 0, userTopic.view);

    return learningResult;
  }

  void saveRawTime(LearningResult learningResult, UserTopic userTopic) {
    int rawTime = userTopic.endTime - userTopic.startTime;
    learningResult.rawTime = rawTime;
    learningResult.convertRawTimeToFormattedTime();
    print("Start time: ${userTopic.startTime}");
    print("End time: ${userTopic.endTime}");
    print("Raw time: ${learningResult.rawTime}");
    print("Formatted time: ${learningResult.formattedTime}");
  }

  void _navigate(int direction) {
    if (_index + direction >= 0 && _index + direction < _totalVocabulary) {
      setState(() {
        _index += direction;
        _currentVocabulary += direction;
        _progress = _currentVocabulary / _totalVocabulary;
        _randomVocabularies = _getRandomVocabularies(_updatedVocabularies, _updatedVocabularies[_index]);
      });
      resetTimer();
    }
  }

  void speak(String text, bool isEnVi) async {
    String languageCode = isEnVi ? "en-US" : "vi-VN";

    await flutterTts.setLanguage(languageCode);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

}

