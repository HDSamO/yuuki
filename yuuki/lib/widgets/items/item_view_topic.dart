import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../customs/custom_delete_dialog.dart';

class ItemViewTopic extends StatefulWidget {
  final VoidCallback onRemove;
  final void Function(String) onTermChanged;
  final void Function(String) onDefinitionChanged;
  final TextEditingController termController;
  final TextEditingController definitionController;
  final bool isEditing;

  const ItemViewTopic({
    super.key,
    required this.onRemove,
    required this.termController,
    required this.definitionController,
    required this.isEditing,
    required this.onTermChanged,
    required this.onDefinitionChanged,
  });

  @override
  State<ItemViewTopic> createState() => _ItemViewTopicState();
}

class _ItemViewTopicState extends State<ItemViewTopic> {
  TextEditingController termController = TextEditingController();
  TextEditingController definitionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    termController.text = widget.termController.text;
    definitionController.text = widget.definitionController.text;
  }

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
                        fontSize: 16,
                        fontFamily: "Quicksand",
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (hasContent() && widget.isEditing) {
                          _showDeleteConfirmationDialog(context);
                        } else {
                          widget.onRemove();
                        }
                      },
                      icon: widget.isEditing
                          ? Icon(Icons.cancel, color: Colors.black)
                          : SizedBox(),
                    )
                  ],
                ),
                TextField(
                  readOnly: !widget.isEditing,
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
                  onChanged: (value) {
                    widget.onTermChanged(value);
                  },
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
                  readOnly: !widget.isEditing,
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
                  onChanged: (value) {
                    widget.onDefinitionChanged(value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context){
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
