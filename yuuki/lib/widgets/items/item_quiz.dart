import 'package:flutter/material.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/customs/custom_quiz_button.dart';

class ItemQuiz extends StatelessWidget {
  const ItemQuiz({super.key});

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
                        'Salt',
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
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.width(context, 16)),
                    child: Column(
                      children: [
                        CustomQuizButton(
                          text: "Option A",
                          onTap: () {  },
                        ),
                        SizedBox(height: Dimensions.height(context, 16)),
                        CustomQuizButton(
                          text: "Option B",
                          onTap: () {  },
                        ),
                        SizedBox(height: Dimensions.height(context, 16)),
                        CustomQuizButton(
                          text: "Option C",
                          onTap: () {  },
                        ),
                        SizedBox(height: Dimensions.height(context, 16)),
                        CustomQuizButton(
                          text: "Option D",
                          onTap: () {  },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
