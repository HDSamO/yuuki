import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/utils/demension.dart';

import '../../models/user_topic.dart';
import '../customs/custom_delete_dialog.dart';

class ItemUserTopicFolder extends StatelessWidget {
  final MyUser myUser;
  final UserTopic userTopic;
  final VoidCallback onRemove;

  const ItemUserTopicFolder({
    super.key,
    required this.myUser,
    required this.userTopic,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Container(
        width: double.infinity,
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              userTopic.title,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: Dimensions.fontSize(context, 18),
                                fontFamily: "QuicksandRegular",
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _showDeleteConfirmationDialog(context);
                            },
                            icon: Icon(
                              Icons.delete_outline,
                              size: Dimensions.iconSize(context, 26),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildItemInfo(
                            context,
                            "${userTopic.vocabularies.length} Items",
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.person,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              userTopic.authorName,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "QuicksandRegular",
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildItemInfo(BuildContext context, String text) {
    return Container(
      alignment: Alignment.center,
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(217, 240, 255, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: "QuicksandRegular",
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
              message: "Are you sure you want to delete it?",
              onFunction: () {
                onRemove();
              }
          );
        }
    );
  }

}
