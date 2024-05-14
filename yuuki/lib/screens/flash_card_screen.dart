import 'dart:async';
import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/widgets/customs/custom_primary_button.dart';
import 'package:yuuki/widgets/item_flash_card.dart';

import '../models/vocabulary.dart';

class FlashCardScreen extends StatefulWidget {
  final MyUser myUser;
  final UserTopic userTopic;
  final bool isEnVi;

  const FlashCardScreen({
    super.key,
    required this.myUser,
    required this.userTopic,
    required this.isEnVi,
  });

  @override
  State<FlashCardScreen> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  int _index = 0;
  int _currentVocabulary = 1;
  Timer? _autoPlayTimer;

  late int _totalVocabulary;
  late double _progress;
  late List<Vocabulary> _updatedVocabularies = [];
  late List<Vocabulary> _originalVocabularies = [];
  late bool _isEnVi;

  bool _isLanguageSelected = false;
  bool _isAutoPlaySelected = false;
  bool _isShuffleSelected = false;
  bool _isFilterSelected = false;

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

  @override
  void initState() {
    super.initState();
    _totalVocabulary = widget.userTopic.vocabularies.length;
    _progress = _currentVocabulary / _totalVocabulary;
    _isEnVi = widget.isEnVi;

    if (!widget.isEnVi){
      _updatedVocabularies = _swappedVocabularies(widget.userTopic.vocabularies);
      _originalVocabularies = _swappedVocabularies(widget.userTopic.vocabularies);
    } else {
      _updatedVocabularies = widget.userTopic.vocabularies;
      _originalVocabularies = widget.userTopic.vocabularies;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
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
                            style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8,),
                          Text(
                            "/",
                            style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8,),
                          Text(
                            _totalVocabulary.toString(),
                            style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
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
                            icon: Icon(Icons.arrow_back, size: 36,),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
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
                  SizedBox(height: 10),
                  // Functional Buttons
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), // Độ cong của viền bo góc
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isAutoPlaySelected = !_isAutoPlaySelected;
                              if (_isAutoPlaySelected) {
                                startAutoPlay();
                              } else {
                                stopAutoPlay();
                              }
                            });
                          },
                          icon: Icon(
                            Icons.play_arrow,
                            size: 30,
                            color: _isAutoPlaySelected ? Colors.blue : Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isShuffleSelected = !_isShuffleSelected;
                              if (_isShuffleSelected) {
                                _updatedVocabularies.shuffle();
                              } else {
                                _updatedVocabularies = List.from(_originalVocabularies);
                              }
                            });
                          },
                          icon: Icon(
                              Icons.shuffle,
                            size: 30,
                            color: _isShuffleSelected ? Colors.blue : Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isLanguageSelected = !_isLanguageSelected;
                              _updatedVocabularies = _swappedVocabularies(_updatedVocabularies);
                              _originalVocabularies = _swappedVocabularies(_originalVocabularies);
                              _isEnVi = !_isEnVi;
                            });
                          },
                          icon: Icon(
                              Icons.language,
                            size: 30,
                            color: _isLanguageSelected ? Colors.blue : Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isFilterSelected = !_isFilterSelected;
                            });
                          },
                          icon: Icon(
                              Icons.filter_alt,
                            size: 30,
                            color: _isFilterSelected ? Colors.blue : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  // CustomViewPager
                  Expanded(
                    child: FlipCard(
                      front: ItemFlashCard(myUser: widget.myUser, userTopic: widget.userTopic, text: _updatedVocabularies[_index].term, isEnVi: _isEnVi, vocabulary: _updatedVocabularies[_index],),
                      back: ItemFlashCard(myUser: widget.myUser, userTopic: widget.userTopic, text: _updatedVocabularies[_index].definition, isEnVi: _isEnVi, vocabulary: _updatedVocabularies[_index],)
                    )
                  ),
                  SizedBox(height: 20),
                  // Back and Next Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomPrimaryButton(
                        onPressed: () => _navigate(-1),
                        text: 'Back',
                        width: 150,
                        height: 60,
                        color: Colors.blue,
                      ),
                      CustomPrimaryButton(
                        onPressed: () => _navigate(1),
                        text: 'Next',
                        width: 150,
                        height: 60,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
        print("Current Index: $_index");
      }
    });
  }

  void startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        // Luôn nằm trong phạm vi từ 0 đến _totalVocabulary - 1.
        _index = (_index + 1) % _totalVocabulary;

        // Làm cho _currentVocabulary tăng từ 1 đến _totalVocabulary sau mỗi chu kỳ và nó cũng sẽ quay lại 1 sau khi đạt đến _totalVocabulary.
        _currentVocabulary = (_currentVocabulary % _totalVocabulary) + 1;

        _progress = _currentVocabulary / _totalVocabulary;
      });
    });
  }

  void stopAutoPlay() {
    setState(() {
      _isAutoPlaySelected = false;
      _autoPlayTimer?.cancel();
      _autoPlayTimer = null;
    });
  }

}