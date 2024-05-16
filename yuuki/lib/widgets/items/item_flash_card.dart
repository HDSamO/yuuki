import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:yuuki/models/topic.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/models/vocabulary.dart';

import '../../models/my_user.dart';

class ItemFlashCard extends StatefulWidget {
  final MyUser myUser;
  final UserTopic? userTopic;
  final Topic? topic;
  final Vocabulary vocabulary;
  final String text;
  final bool isEnVi;

  const ItemFlashCard({
    Key? key,
    required this.myUser,
    this.userTopic,
    this.topic,
    required this.text,
    required this.isEnVi,
    required this.vocabulary,
  }) : super(key: key);

  @override
  State<ItemFlashCard> createState() => _ItemFlashCardState();
}

class _ItemFlashCardState extends State<ItemFlashCard> {
  late Vocabulary vocabulary;
  late String text;
  late bool isEnVi;
  late FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    vocabulary = widget.vocabulary;
    text = widget.text;
    isEnVi = widget.isEnVi;
  }

  @override
  void didUpdateWidget(covariant ItemFlashCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != text) {
      setState(() {
        text = widget.text;
      });
    }

    if (widget.isEnVi != isEnVi) {
      setState(() {
        isEnVi = widget.isEnVi;
      });
    }

    if (widget.vocabulary.term != vocabulary.term){
      setState(() {
        vocabulary = widget.vocabulary;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: const Color(0xFF94D4FE),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print('Container được tap vào');
                        },
                        child: Container(
                          width: 140,
                          padding:
                              EdgeInsets.symmetric(horizontal: 26, vertical: 3),
                          decoration: BoxDecoration(
                            color: Color(0xFFD9F0FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                Icon(Icons.lightbulb_outline,
                                    size: 24, color: Colors.black),
                                Text(
                                  "Hint",
                                  style: TextStyle(
                                      fontSize: 28, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            vocabulary.stared = !vocabulary.stared;
                          });
                        },
                        icon: vocabulary.stared
                            ? Icon(
                                Icons.star,
                                size: 48,
                                color: Colors.yellow,
                              )
                            : Icon(Icons.star_border,
                                size: 48, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () {
                          speak(text, isEnVi);
                        },
                        icon: Icon(
                          Icons.volume_up,
                          size: 48,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 52, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void speak(String text, bool isEnVi) async {
    String languageCode = isEnVi ? "en-US" : "vi-VN";

    await flutterTts.setLanguage(languageCode);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }
}
