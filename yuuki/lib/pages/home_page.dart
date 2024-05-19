import 'package:avatar_glow/avatar_glow.dart';
import 'package:card_actions/card_action_button.dart';
import 'package:card_actions/card_actions.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scaled_list/scaled_list.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tab_container/tab_container.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/models/topic.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/models/vocabulary.dart';
import 'package:yuuki/results/topic_list_result.dart';
import 'package:yuuki/services/topic_service.dart';
import 'package:yuuki/utils/const.dart';
import 'package:yuuki/utils/demension.dart';
import 'package:yuuki/widgets/items/item_home_recent.dart';
import 'package:yuuki/widgets/items/item_home_published.dart';

class HomePage extends StatefulWidget {
  final MyUser? user;

  const HomePage({Key? key, this.user}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _greeting = '';
  final controller = PageController(viewportFraction: 0.8, keepPage: true);

  late Future<List<UserTopic>> _recentTopicsFuture;
  late Future<TopicListResult> _publishedTopicsFuture;
  late Future<TopicListResult> _privateTopicsFuture;

  @override
  void initState() {
    super.initState();
    _updateGreeting();
    _recentTopicsFuture = _getRecentTopics();
    _publishedTopicsFuture = _getPublishedTopics();
    _privateTopicsFuture = _getPrivateTopics();
  }

  Future<List<UserTopic>> _getRecentTopics() async {
    return await TopicController().getRecentTopics(widget.user!);
  }

  Future<TopicListResult> _getPublishedTopics() async {
    return await TopicController().getPublishedTopics(widget.user!);
  }

  Future<TopicListResult> _getPrivateTopics() async {
    return await TopicController().getPrivateTopics(widget.user!);
  }

  void _updateGreeting() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 0 && hour < 12) {
      setState(() {
        _greeting = 'Good morning';
      });
    } else if (hour >= 12 && hour < 18) {
      setState(() {
        _greeting = 'Good afternoon';
      });
    } else {
      setState(() {
        _greeting = 'Good evening';
      });
    }
  }

  List<Widget> buildPages(BuildContext context) {
    return [
      buildPage("Ultimate Grinder", "123 Topics Learned",
          Color.fromRGBO(52, 131, 4, 1), context),
      buildPage("Flawless Ace", "102 Perfect Scores",
          Color.fromRGBO(8, 111, 233, 1), context),
      buildPage("Streak Master", "100 Consecutive Days",
          Color.fromRGBO(241, 51, 59, 1), context),
    ];
  }

  Widget buildPage(
      String title, String subTitle, Color textColor, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
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
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: Dimensions.fontSize(context, 20),
                fontFamily: "Quicksand",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Image.asset(
              "assets/images/login_signup/${title.toLowerCase().replaceAll(" ", "")}Icon.png",
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              alignment: Alignment.center,
              height: 32,
              width: double.infinity,
              decoration: BoxDecoration(
                color: textColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                subTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimensions.fontSize(context, 16),
                  fontFamily: "Quicksand",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = List.generate(
      3,
      (index) => buildPages(context)[index],
    );
    final controller =
        PageController(initialPage: 1, viewportFraction: 0.8, keepPage: true);
    return DraggableHome(
      title: Text(
        widget.user!.name,
        style: TextStyle(
          fontFamily: "Pacifico",
          color: Colors.white,
        ),
      ),
      headerWidget: headerWidget(context),
      headerBottomBar: headerBottomBarWidget(),
      body: [
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 240,
                child: PageView.builder(
                  controller: controller,
                  itemCount: pages.length,
                  itemBuilder: (_, index) {
                    return pages[index % pages.length];
                  },
                ),
              ),
              SizedBox(height: 16),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Recent",
                  style: TextStyle(
                    color: AppColors.mainColor,
                    fontSize: Dimensions.fontSize(context, 20),
                    fontFamily: "Quicksand",
                  ),
                ),
              ),
              FutureBuilder<List<UserTopic>>(
                future: _recentTopicsFuture,
                builder: (context, AsyncSnapshot<List<UserTopic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final recentTopics = snapshot.data ?? [];
                    final filteredTopics = recentTopics
                        .where((userTopic) =>
                            userTopic.author == widget.user!.id ||
                            userTopic.private == false)
                        .toList();
                    return Container(
                      height: 180,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: filteredTopics.map((userTopic) {
                          return ItemHomeResent(
                            userTopic: userTopic,
                            user: widget.user!,
                            onRefresh: () {
                              setState(() {
                                _recentTopicsFuture = _getRecentTopics();
                                _publishedTopicsFuture = _getPublishedTopics();
                                _privateTopicsFuture = _getPrivateTopics();
                              });
                            },
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 8),
              FutureBuilder<TopicListResult>(
                future: _privateTopicsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final recentTopics = snapshot.data?.topics ?? [];

                    if (recentTopics.isEmpty) {
                      return SizedBox.shrink();
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Private",
                              style: TextStyle(
                                color: AppColors.mainColor,
                                fontSize: Dimensions.fontSize(context, 20),
                                fontFamily: "Quicksand",
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final topic = recentTopics[index];
                              return ItemHomePublished(
                                topic: topic,
                                user: widget.user!,
                                onRefresh: () {
                                  setState(() {
                                    _recentTopicsFuture = _getRecentTopics();
                                    _publishedTopicsFuture =
                                        _getPublishedTopics();
                                    _privateTopicsFuture = _getPrivateTopics();
                                  });
                                },
                              );
                            },
                            itemCount: recentTopics.length,
                          ),
                        ],
                      );
                    }
                  }
                },
              ),
              SizedBox(height: 16),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Published",
                  style: TextStyle(
                    color: AppColors.mainColor,
                    fontSize: Dimensions.fontSize(context, 20),
                    fontFamily: "Quicksand",
                  ),
                ),
              ),
              SizedBox(height: 8),
              FutureBuilder<TopicListResult>(
                future: _publishedTopicsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final recentTopics = snapshot.data?.topics ?? [];

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final topic = recentTopics[index];
                        return ItemHomePublished(
                          topic: topic,
                          user: widget.user!,
                          onRefresh: () {
                            setState(() {
                              _recentTopicsFuture = _getRecentTopics();
                              _publishedTopicsFuture = _getPublishedTopics();
                              _privateTopicsFuture = _getPrivateTopics();
                            });
                          },
                        );
                      },
                      itemCount: recentTopics.length,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
      fullyStretchable: true,
      // backgroundColor: AppColors.backroundColor,
      appBarColor: AppColors.mainColor,
    );
  }

  Row headerBottomBarWidget() {
    return const Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }

  Widget headerWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF397CFF),
            Color(0x803DB7FC),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AvatarGlow(
              startDelay: const Duration(milliseconds: 1000),
              glowColor: Colors.white,
              glowShape: BoxShape.circle,
              animate: true,
              curve: Curves.easeInOut,
              child: const Material(
                elevation: 8.0,
                shape: CircleBorder(),
                color: Colors.transparent,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://ps.w.org/user-avatar-reloaded/assets/icon-128x128.png?rev=2540745"),
                  radius: 70,
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.height(context, 24),
            ),
            Text(
              _greeting,
              style: TextStyle(
                  fontSize: Dimensions.fontSize(context, 24),
                  fontFamily: "Pacifico",
                  color: Colors.white),
            ),
            SizedBox(
              height: Dimensions.height(context, 4),
            ),
            Text(
              widget.user!.name,
              style: TextStyle(
                  fontSize: Dimensions.fontSize(context, 28),
                  fontFamily: "Quicksand",
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
