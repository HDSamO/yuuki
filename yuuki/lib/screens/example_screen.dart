import 'package:flutter/material.dart';
import 'package:yuuki/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yuuki/models/my_user.dart';

class ExampleScreen extends StatelessWidget {
  late final MyUser? user;

  ExampleScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user!.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(user!.email),
            const SizedBox(height: 8.0),
            Text(user!.phone),
          ],
        ),
      ),
    );
  }
}
