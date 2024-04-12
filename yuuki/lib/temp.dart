import 'package:flutter/material.dart';
import 'package:yuuki/widgets/user_card.dart';
import 'package:yuuki/services/user_service.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yuuki/utils/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yuuki/models/my_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp()); // Replace MyApp with your app's main widget
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _userController = UserService();
  String _userEmail = "";
  MyUser? _foundUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Search User'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Enter Email',
                ),
                onChanged: (value) => setState(() => _userEmail = value),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  _foundUser = await _userController.getUserByEmail(_userEmail);
                  setState(() {});
                },
                child: const Text('Search'),
              ),
              const SizedBox(height: 16.0),
              if (_foundUser != null) UserCard(user: _foundUser!) else const Text('No user found'),
            ],
          ),
        ),
      ),
    );
  }
}