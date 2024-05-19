import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/customs/custom_primary_button.dart';
import 'package:yuuki/widgets/items/item_flash_card.dart';

import '../models/vocabulary.dart';
import '../results/vocabulary_list_result.dart';
import '../services/topic_service.dart';
import '../widgets/customs/custom_dialog_confirm.dart';

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
  Timer? _flipTimer;

  late int _totalVocabulary;
  late double _progress;
  late List<Vocabulary> _updatedVocabularies = [];
  late List<Vocabulary> _originalVocabularies = [];
  late bool _isEnVi;

  bool _isLanguageSelected = false;
  bool _isAutoPlaySelected = false;
  bool _isShuffleSelected = false;
  bool _isFilterSelected = false;
  bool _isFrontCard = true;

  final FlipCardController _flipController = FlipCardController();

  List<Vocabulary> _swappedVocabularies(List<Vocabulary> vocabularies){
    List<Vocabulary> newVocabularies = [];

    for (var vocabulary in vocabularies) {
      newVocabularies.add(
        Vocabulary(
          term: vocabulary.definition,
          definition: vocabulary.term,
          stared: vocabulary.stared,
        ),
      );
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
      _originalVocabularies = List.from(_updatedVocabularies);
    } else {
      _updatedVocabularies = widget.userTopic.vocabularies;
      _originalVocabularies = List.from(_updatedVocabularies);
    }
  }

  Future<void> _toggleStarred(Vocabulary vocabulary, bool stared) async {
    setState(() {
      vocabulary.stared = stared;
    });

    VocabularyListResult result = await TopicController().starVocabularyInUserTopic(
      widget.myUser,
      widget.userTopic.id,
      vocabulary,
      stared,
    );

    if (!result.success){
      print("Error: ${result.errorMessage}");
    }
  }

  void _updateFilterVocabularies(List<Vocabulary> vocabularies) {
    setState(() {
      _index = 0;
      _currentVocabulary = _index + 1;
      _isFilterSelected = !_isFilterSelected;
      _updatedVocabularies = List.from(vocabularies);
      _totalVocabulary = _updatedVocabularies.length;
      _progress = _currentVocabulary / _totalVocabulary;
    });
  }

  void _showEmptyDialog(BuildContext context, String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'No Stared Vocabularies',
            style: TextStyle(
              fontSize: Dimensions.fontSize(context, 20)
            ),
          ),
          content: Text(
              message,
            style: TextStyle(
              fontSize: Dimensions.fontSize(context, 16)
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                  'OK',
                style: TextStyle(
                    fontSize: Dimensions.fontSize(context, 16)
                ),
              ),
            ),
          ],
        );
      },
    );
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
                                  return CustomDialogConfirm(
                                    title: "Confirm",
                                    content: "Do you want to exit",
                                    onPressed: () {
                                      Navigator.pop(context); // Close the dialog
                                      Navigator.pop(context); // Close the screen
                                    },
                                    okeText: "Exit",
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
                                minHeight: 20,
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
                                _originalVocabularies = List.from(_updatedVocabularies);
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
                              _isEnVi = !_isEnVi;
                              _isLanguageSelected = !_isLanguageSelected;
                              _originalVocabularies = _swappedVocabularies(_originalVocabularies);
                              _updatedVocabularies = _swappedVocabularies(_updatedVocabularies);
                            });
                          },
                          icon: Icon(
                              Icons.language,
                            size: 30,
                            color: _isLanguageSelected ? Colors.blue : Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (_isFilterSelected) {
                              _updateFilterVocabularies(_originalVocabularies);
                            } else {
                              VocabularyListResult result = await TopicController().getStarredVocabulariesInUserTopic(widget.myUser, widget.userTopic.id);
                              if (result.success){
                                if (result.vocabularies!.isEmpty) {
                                  _showEmptyDialog(context, 'The list of vocabularies is empty!');
                                } else {
                                  _updateFilterVocabularies(result.vocabularies!);
                                }
                              } else {
                                _showEmptyDialog(context, result.errorMessage!);
                              }
                            }
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
                  // Expanded(
                  //   child: FlipCard(
                  //     front: ItemFlashCard(myUser: widget.myUser, userTopic: widget.userTopic, text: _updatedVocabularies[_index].term, isEnVi: _isEnVi, vocabulary: _updatedVocabularies[_index],),
                  //     back: ItemFlashCard(myUser: widget.myUser, userTopic: widget.userTopic, text: _updatedVocabularies[_index].definition, isEnVi: _isEnVi, vocabulary: _updatedVocabularies[_index],)
                  //   )
                  // ),
                  Expanded(
                    child: FlipCard(
                      controller: _flipController,
                      flipOnTouch: true, // Disable the automatic flip on touch
                      onFlipDone: (isFront) {
                        setState(() {
                          _isFrontCard = !isFront;
                        });
                      },
                      speed: 150,
                      front: ItemFlashCard(
                        myUser: widget.myUser,
                        userTopic: widget.userTopic,
                        text: _updatedVocabularies[_index].term,
                        isEnVi: _isEnVi,
                        vocabulary: _updatedVocabularies[_index],
                        onStaredChanged: (bool stared) async {
                          _toggleStarred(_updatedVocabularies[_index], stared);
                        },
                      ),
                      back: ItemFlashCard(
                        myUser: widget.myUser,
                        userTopic: widget.userTopic,
                        text: _updatedVocabularies[_index].definition,
                        isEnVi: _isEnVi,
                        vocabulary: _updatedVocabularies[_index],
                        onStaredChanged: (bool stared) async {
                          _toggleStarred(_updatedVocabularies[_index], stared);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Back and Next Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomPrimaryButton(
                        onPressed: () => {
                          if (_isFrontCard){
                            _navigate(-1),
                          } else {
                            _flipController.toggleCard(),
                            _navigate(-1),
                          }
                        },
                        text: 'Back',
                        width: 120,
                        height: 60,
                        color: Colors.blue,
                      ),
                      CustomPrimaryButton(
                        onPressed: () => {
                          if (_isFrontCard){
                            _navigate(1),
                          } else {
                            _flipController.toggleCard(),
                            _navigate(1),
                          }
                        },
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
        // _currentVocabulary += direction;
        _currentVocabulary = _index + 1;
        _progress = _currentVocabulary / _totalVocabulary;
      }
    });
  }

  void startAutoPlay() {
    _flipTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _flipController.toggleCard();
    });

    _autoPlayTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
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
      _flipTimer?.cancel();
      _autoPlayTimer = null;
      _flipTimer = null;
    });
  }

}