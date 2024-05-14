import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yuuki/utils/const.dart';
import 'package:yuuki/utils/demension.dart';

class ItemAddVocabulary extends StatefulWidget {
  final VoidCallback onRemove;
  final TextEditingController termController;
  final TextEditingController definitionController;

  ItemAddVocabulary({
    required this.onRemove,
    required this.termController,
    required this.definitionController,
  });

  @override
  _ItemAddVocabularyState createState() => _ItemAddVocabularyState();
}

class _ItemAddVocabularyState extends State<ItemAddVocabulary> {
  TextEditingController termController = TextEditingController();
  TextEditingController definitionController = TextEditingController();

  bool hasContent() {
    return termController.text.isNotEmpty ||
        definitionController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Container(
          width: double.infinity,
          height: 260,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Term",
                      style: TextStyle(
                        fontSize: Dimensions.fontSize(context, 16),
                        fontFamily: "Quicksand",
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (hasContent()) {
                          _showDeleteConfirmationDialog();
                        } else {
                          widget.onRemove();
                        }
                      },
                      icon: Icon(Icons.cancel, color: Colors.black),
                    )
                  ],
                ),
                TextField(
                  controller: termController,
                  cursorColor: Colors.blue,
                  maxLines: null,
                  cursorErrorColor: Colors.red,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'Enter a term',
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 8),
                  child: Text(
                    "Definition",
                    style: TextStyle(
                      fontSize: Dimensions.fontSize(context, 16),
                      fontFamily: "Quicksand",
                      color: Colors.black,
                    ),
                  ),
                ),
                TextField(
                  controller: definitionController,
                  maxLines: null,
                  cursorColor: Colors.blue,
                  cursorErrorColor: Colors.red,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'Enter a definition',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF397CFF),
                        Color(0x803DB7FC),
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Confirm Delete",
                    style: TextStyle(
                      fontSize: Dimensions.fontSize(context, 20),
                      fontFamily: "Quicksand",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  child: Text(
                    "This item contains text. Are you sure you want to delete it?",
                    style: TextStyle(
                      fontSize: Dimensions.fontSize(context, 16),
                      fontFamily: "QuicksandRegular",
                      color: Color(0xffec5b5b),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: Dimensions.fontSize(context, 16),
                          fontFamily: "QuicksandRegular",
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 40,
                        ),
                        foregroundColor: AppColors.mainColor,
                        side: BorderSide(
                          color: AppColors.mainColor,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        widget.onRemove();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Remove",
                        style: TextStyle(
                          fontSize: Dimensions.fontSize(context, 16),
                          fontFamily: "QuicksandRegular",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 40,
                        ),
                        backgroundColor: AppColors.mainColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
