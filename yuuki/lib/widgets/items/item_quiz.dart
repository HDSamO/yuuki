import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
                  width: 700,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.vocabulary.term,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(10),
                    itemCount: 4,
                    itemBuilder: (BuildContext context, int index) {
                      return CustomQuizButton(
                        text: widget.vocabularies[index].definition,
                        onTap: () {
                          _handleOptionSelected(index, widget.vocabularies[index].definition);
                        },
                        isSelected: _buttonStates[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 16,),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
