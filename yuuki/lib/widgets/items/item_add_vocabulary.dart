import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yuuki/utils/const.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/customs/custom_delete_dialog.dart';

class ItemAddVocabulary extends StatefulWidget {
  final VoidCallback onRemove;
  final TextEditingController termController;
  final TextEditingController definitionController;

  const ItemAddVocabulary({
    super.key,
    required this.onRemove,
    required this.termController,
    required this.definitionController,
  });

  @override
  State<ItemAddVocabulary> createState() => _ItemAddVocabularyState();
}

class _ItemAddVocabularyState extends State<ItemAddVocabulary> {
  late TextEditingController termController;
  late TextEditingController definitionController;
  bool isTermEmpty = true;
  bool isDefinitionEmpty = true;

  @override
  void initState() {
    super.initState();
    termController = widget.termController;
    definitionController = widget.definitionController;
    termController.text = widget.termController.text;
    definitionController.text = widget.definitionController.text;
  }

  bool hasContent() {
    return termController.text.isNotEmpty || definitionController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Container(
          width: double.infinity,
          height: 320,
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
                        fontSize: 16,
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
                SizedBox(height: 8,),
                TextField(
                  controller: termController,
                  onChanged: (_) {
                    setState(() {
                      isTermEmpty = termController.text.isEmpty;
                    });
                  },
                  keyboardType: TextInputType.text,
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
                        color: isTermEmpty && termController.text.isEmpty
                            ? Colors.red
                            : Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'Enter a term',
                    errorText: isTermEmpty && termController.text.isEmpty
                        ? 'Term cannot be empty'
                        : null,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 8),
                  child: Text(
                    "Definition",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Quicksand",
                      color: Colors.black,
                    ),
                  ),
                ),
                TextField(
                  controller: definitionController,
                  onChanged: (_) {
                    setState(() {
                      isDefinitionEmpty = definitionController.text.isEmpty;
                    });
                  },
                  keyboardType: TextInputType.text,
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
                        color: isDefinitionEmpty && definitionController.text.isEmpty
                            ? Colors.red
                            : Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'Enter a definition',
                    errorText: isDefinitionEmpty && definitionController.text.isEmpty
                        ? 'Definition cannot be empty'
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return CustomDeleteDialog(
              title: "Confirm Delete",
              message: "This item contains text. Are you sure you want to delete it?",
              onFunction: () {
                widget.onRemove();
              }
          );
        }
    );
  }

}
