import 'package:flutter/material.dart';

import '../models/my_user.dart';

class LibraryFolders extends StatelessWidget {
  const LibraryFolders({super.key, required this.myUser});

  final MyUser? myUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Library Folders"),
        Text(myUser!.name),
      ],
    );
  }
}


