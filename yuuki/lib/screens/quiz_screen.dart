import 'dart:async';
import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/customs/custom_primary_button.dart';
import 'package:yuuki/widgets/items/item_flash_card.dart';

import '../models/vocabulary.dart';
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

  late int _totalVocabulary;
  late double _progress;
  late List<Vocabulary> _updatedVocabularies = [];
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

  void startCountDownTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_milliseconds < 1000) {
          _handleTimerFinish();
        } else {
          _milliseconds -= 1000; // Giảm đi một giây
        }
      });
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
    if (_index + 1 >= _totalVocabulary) {
      // Nếu đang ở cuối danh sách từ vựng, điều hướng tới màn hình kết thúc hoặc màn hình khác
      // Ví dụ: Navigator.pushReplacementNamed(context, '/end_screen');
    } else {
      // Nếu chưa đạt cuối danh sách từ vựng, điều hướng tới câu hỏi tiếp theo
      _navigate(1);
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
    } else {
      _updatedVocabularies = widget.userTopic.vocabularies;
    }

    startCountDownTimer();
  }

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: Padding(
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
                    Expanded(
                        child: ItemQuiz()
                    ),
                    SizedBox(height: Dimensions.height(context, 24)),
                    // Back and Next Buttons
                    CustomPrimaryButton(
                      onPressed: () => _navigate(1),
                      text: 'CHECK',
                      width: double.infinity,
                      height: Dimensions.height(context, 54),
                      color: Color(0xFF0947E8),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigate(int direction) {
    setState(() {
      if (_index + direction >= 0 && _index + direction < _totalVocabulary) {
        _index += direction;
        _currentVocabulary += direction;
        _progress = _currentVocabulary / _totalVocabulary;
        resetTimer();
      }
    });
  }

  void speak(String text, bool isEnVi) async {
    String languageCode = isEnVi ? "en-US" : "vi-VN";

    await flutterTts.setLanguage(languageCode);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

}

