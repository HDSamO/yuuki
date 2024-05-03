import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/my_sign_up_page.dart';
import 'package:yuuki/screens/home_screen.dart';
import 'package:yuuki/services/user_service.dart';
import 'package:yuuki/listeners/on_user_create_listener.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yuuki/utils/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: HomeScreen(),
        ),
      ),
    );
  }
}
