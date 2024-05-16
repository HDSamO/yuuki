import 'package:flutter/material.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/customs/custom_quiz_button.dart';

import '../../models/vocabulary.dart';

class ItemQuiz extends StatefulWidget {
  final Vocabulary vocabulary;
  final List<Vocabulary> vocabularies;
  final Function(String) onOptionSelected;

  const ItemQuiz({
    super.key,
    required this.vocabulary,
    required this.vocabularies,
    required this.onOptionSelected,
  });

  @override
  State<ItemQuiz> createState() => ItemQuizState();
}

class ItemQuizState extends State<ItemQuiz> {
  late List<bool> _buttonStates = [false, false, false, false];
  String get selectedOption => _selectedOption;
  late String _selectedOption;

  void _handleOptionSelected(int indexButton, String option) {
    // Cập nhật trạng thái của các nút và lựa chọn được chọn
    setState(() {
      _buttonStates = List.filled(_buttonStates.length, false);
      _buttonStates[indexButton] = true;
      _selectedOption = option;
    });

    // Gọi hàm callback để thông báo về sự thay đổi của lựa chọn
    widget.onOptionSelected(option);
  }

  @override
  void didUpdateWidget(covariant ItemQuiz oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.vocabulary.term != widget.vocabulary.term){
      setState(() {
        _buttonStates = List.filled(_buttonStates.length, false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: Dimensions.width(context, MediaQuery.of(context).size.width - 60),
                  padding: EdgeInsets.symmetric(vertical: Dimensions.height(context, 10), horizontal: Dimensions.width(context, 20)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Choose the correct answer:',
                        style: TextStyle(
                          fontSize: Dimensions.fontSize(context, 24),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Dimensions.height(context, 10)),
                      Text(
                        widget.vocabulary.term,
                        style: TextStyle(
                          fontSize: Dimensions.fontSize(context, 36),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.height(context, 30)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.width(context, 16)),
                  child: Column(
                    children: [
                      CustomQuizButton(
                        text: widget.vocabularies[0].definition,
                        onTap: () {
                          _handleOptionSelected(0, widget.vocabularies[0].definition);
                        },
                        isSelected: _buttonStates[0],
                      ),
                      SizedBox(height: Dimensions.height(context, 16)),
                      CustomQuizButton(
                        text: widget.vocabularies[1].definition,
                        onTap: () {
                          _handleOptionSelected(1, widget.vocabularies[1].definition);
                        },
                        isSelected: _buttonStates[1],
                      ),
                      SizedBox(height: Dimensions.height(context, 16)),
                      CustomQuizButton(
                        text: widget.vocabularies[2].definition,
                        onTap: () {
                          _handleOptionSelected(2, widget.vocabularies[2].definition);
                        },
                        isSelected: _buttonStates[2],
                      ),
                      SizedBox(height: Dimensions.height(context, 16)),
                      CustomQuizButton(
                        text: widget.vocabularies[3].definition,
                        onTap: () {
                          _handleOptionSelected(3, widget.vocabularies[3].definition);
                        },
                        isSelected: _buttonStates[3],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
