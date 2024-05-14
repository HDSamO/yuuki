import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:yuuki/models/learning_result.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/models/question_answer.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/widgets/customs/custom_primary_button.dart';

import '../models/vocabulary.dart';

class LanguagePairScreen extends StatefulWidget {
  final MyUser myUser;
  final UserTopic userTopic;
  final bool isEnVi;

  const LanguagePairScreen({
    super.key,
    required this.myUser,
    required this.userTopic,
    required this.isEnVi,
  });

  @override
  State<LanguagePairScreen> createState() => _LanguagePairScreenState();
}

class _LanguagePairScreenState extends State<LanguagePairScreen> {
  int _index = 0;
  int _currentVocabulary = 1;
  TextEditingController _answerController = TextEditingController();
  List<QuestionAnswer> _questionAnswers = [];

  late int _totalVocabulary;
  late double _progress;
  late List<Vocabulary> _updatedVocabularies = [];
  late bool _isEnVi;
  late FlutterTts flutterTts = FlutterTts();

  List<Vocabulary> _swappedVocabularies(List<Vocabulary> vocabularies) {
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

  @override
  void initState() {
    super.initState();
    _totalVocabulary = widget.userTopic.vocabularies.length;
    _progress = _currentVocabulary / _totalVocabulary;
    _isEnVi = widget.isEnVi;

    if (!widget.isEnVi) {
      _updatedVocabularies =
          _swappedVocabularies(widget.userTopic.vocabularies);
    } else {
      _updatedVocabularies = widget.userTopic.vocabularies;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          Image.asset(
            "assets/images/onboarding/img_background.jpg",
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
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
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "/",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            _totalVocabulary.toString(),
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
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
                                          Navigator.pop(
                                              context); // Close the dialog
                                          Navigator.pop(
                                              context); // Close the screen
                                        },
                                        child: Text("Có"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Close the dialog
                                        },
                                        child: Text("Không"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              size: 36,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: LinearProgressIndicator(
                                minHeight: _totalVocabulary.toDouble(),
                                value: _progress,
                                backgroundColor: Colors.grey[400],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.yellowAccent),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Functional Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dịch từ này:',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      IconButton(
                        onPressed: () {
                          speak(_updatedVocabularies[_index].term, _isEnVi);
                        },
                        icon: Icon(
                          Icons.volume_up,
                          size: 36,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  // CustomViewPager
                  Expanded(
                      child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 60,
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          _updatedVocabularies[_index].term,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Expanded(
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Color(0xFF94D4FE),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Center(
                                  child: Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: TextField(
                                  controller: _answerController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter here',
                                  ),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 26.0, color: Colors.black),
                                  keyboardType: TextInputType
                                      .text, // Kiểu bàn phím là text
                                  textInputAction: TextInputAction
                                      .done, // Hành động khi nhấn nút hoàn tất
                                  autocorrect: true, // Tự động sửa chính tả
                                  enableSuggestions: true, // Hiện gợi ý từ điển
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
                  SizedBox(height: 20),
                  // Back and Next Buttons
                  CustomPrimaryButton(
                    onPressed: () => {
                      if (_answerController.text.toLowerCase() ==
                          _updatedVocabularies[_index].definition.toLowerCase())
                        {_showCheckRight(context)}
                      else
                        {_showCheckFail(context)}
                    },
                    text: 'CHECK',
                    width: double.infinity,
                    height: 60,
                    color: Color(0xFF0947E8),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  void _navigate(int direction) {
    setState(() {
      if (_index + direction >= 0 && _index + direction < _totalVocabulary) {
        _index += direction;
        _currentVocabulary += direction;
        _progress = _currentVocabulary / _totalVocabulary;
        _answerController.clear();
      }
    });
  }

  void speak(String text, bool isEnVi) async {
    String languageCode = isEnVi ? "en-US" : "vi-VN";

    await flutterTts.setLanguage(languageCode);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  void _showCheckRight(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Color(0xFF32CD32),
                    size: 32,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Làm tốt lắm',
                    style: TextStyle(
                        fontSize: 28,
                        color: Color(0xFF32CD32),
                        fontWeight: FontWeight.bold,
                        fontFamily: "Cabin"),
                  ),
                ],
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  // Kết thúc học và chuyển trang
                  if (_index == _totalVocabulary - 1){
                    _questionAnswers.add(
                        QuestionAnswer(
                            vocabulary: _updatedVocabularies[_index],
                            answer: _answerController.text.trim(),
                            check: true
                        )
                    );
                    LearningResult learningResult = LearningResult(questionAnswers: _questionAnswers);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                  _questionAnswers.add(
                      QuestionAnswer(
                          vocabulary: _updatedVocabularies[_index],
                          answer: _answerController.text.trim(),
                          check: true
                      )
                  );
                  _navigate(1);
                  Navigator.pop(context);
                },
                child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: Color(0xFF32CD32),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        "Tiếp tục",
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontFamily: "Cabin",
                        ),
                      ),
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCheckFail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.cancel,
                    color: Color(0xFFCC0000),
                    size: 32,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Không chính xác",
                    style: TextStyle(
                        fontSize: 28,
                        color: Color(0xFFCC0000),
                        fontWeight: FontWeight.bold,
                        fontFamily: "Cabin"),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Trả lời đúng:",
                style: TextStyle(
                    color: Color(0xFFCC0000),
                    fontSize: 26,
                    fontFamily: "Cabin",
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                _updatedVocabularies[_index].definition,
                style: TextStyle(
                    color: Color(0xFFCC0000),
                    fontSize: 20,
                    fontFamily: "Cabin"),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  // Kết thúc học và chuyển trang
                  if (_index == _totalVocabulary - 1){
                    _questionAnswers.add(
                        QuestionAnswer(
                            vocabulary: _updatedVocabularies[_index],
                            answer: _answerController.text.trim(),
                            check: false
                        )
                    );
                    LearningResult learningResult = LearningResult(questionAnswers: _questionAnswers);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                  _questionAnswers.add(
                      QuestionAnswer(
                          vocabulary: _updatedVocabularies[_index],
                          answer: _answerController.text.trim(),
                          check: false
                      )
                  );
                  _navigate(1);
                  Navigator.pop(context);
                },
                child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: Color(0xFFCC0000),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        "Đã hiểu",
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontFamily: "Cabin",
                        ),
                      ),
                    )),
              ),
            ],
          ),
        );
      },
    );
  }
}
