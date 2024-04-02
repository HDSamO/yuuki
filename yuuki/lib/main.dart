import 'package:flutter/material.dart';
import 'package:yuuki/widgets/user_card.dart';
import 'package:yuuki/services/user_service.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yuuki/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp()); // Replace MyApp with your app's main widget
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userService = UserService();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My App'),
        ),
        body: FutureBuilder<List<QueryDocumentSnapshot>>(
          future: userService.getUserList(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final users = snapshot.data!; // List<QueryDocumentSnapshot>
            return UserCard(users: users);
          },
        ),
      ),
    );
  }
}
