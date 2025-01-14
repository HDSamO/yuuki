import 'package:flutter/material.dart';
import 'package:yuuki/screens/starred_vocabularies_screen.dart';
import 'package:yuuki/widgets/customs/custom_fragment_scaffold.dart';
import 'package:yuuki/widgets/library_folders.dart';
import 'package:yuuki/widgets/library_topics.dart';

import '../models/my_user.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key, required this.myUser});
  final MyUser myUser;

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomFragmentScaffold(
      pageName: 'Library',
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.blue,
                    indicatorColor: Colors.blue,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(text: "Topics"),
                      Tab(text: "Folders")
                    ],
                  ),
                ),
                SizedBox(width: 16,),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (e) => StarredVocabulariesScreen(myUser: widget.myUser),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue),
                      color: Colors.transparent, // Set white background
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 14,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'VOCABULARIES',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                SizedBox(width: 16,),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: TabBarView(
                controller: _tabController,
                children: [
                  LibraryTopics(myUser: widget.myUser),
                  LibraryFolders(myUser: widget.myUser)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
