import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yuuki/models/top_user.dart';
import 'package:yuuki/models/topic.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/utils/demension.dart';

import '../../models/vocabulary.dart';

class ItemUserRank extends StatelessWidget {
  final TopUser topUser;

  const ItemUserRank({
    super.key,
    required this.topUser,
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
                          Icon(
                            Icons.person,
                            size: Dimensions.iconSize(context, 24),
                          ),
                          SizedBox(width: Dimensions.width(context, 16),),
                          Expanded(
                            child: Text(
                              topUser.name,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: Dimensions.fontSize(context, 18),
                                fontFamily: "QuicksandRegular",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildItemInfo(
                            context,
                            "Time: ${topUser.convertRawTimeToFormattedTime()}",
                          ),
                          const SizedBox(width: 12),
                          _buildItemInfo(
                              context,
                            "Score: ${(topUser.score * 10).round() / 10}",
                          ),
                          const SizedBox(width: 12),
                          _buildItemInfo(
                            context,
                            "Times: ${topUser.viewCount}",
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
      height: Dimensions.height(context, 22),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(217, 240, 255, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: Dimensions.fontSize(context, 12),
          fontFamily: "QuicksandRegular",
        ),
      ),
    );
  }

}
