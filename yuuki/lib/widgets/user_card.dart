import 'package:flutter/material.dart';
import 'package:yuuki/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserCard extends StatelessWidget {
  final List<QueryDocumentSnapshot> users;

  const UserCard({Key? key, required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder( // Use ListView.builder for efficient list building
      itemCount: users.length,
      itemBuilder: (context, index) {
        final userData = users[index].data() as Map<String, dynamic>;
        final userName = userData['name'];
        final userEmail = userData['email'];

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: TextStyle(fontSize: 18.0)),
                Text(userEmail, style: TextStyle(fontSize: 16.0)),
              ],
            ),
          ),
        );
      },
    );
  }
}
