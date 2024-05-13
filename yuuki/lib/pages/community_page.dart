import 'package:flutter/material.dart';
import 'package:yuuki/widgets/customs/custom_fragment_scaffold.dart';

import '../models/my_user.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key, required this.myUser});
  final MyUser? myUser;

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomFragmentScaffold(
      pageName: 'Community',
      child: Center(
        child: Text("Community Page"),
      )
    );
  }
}
