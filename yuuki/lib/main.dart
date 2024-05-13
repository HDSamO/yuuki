import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/my_sign_up_page.dart';
import 'package:yuuki/screens/home_screen.dart';
import 'package:yuuki/pages/library_page.dart';
import 'package:yuuki/screens/login_screen.dart';
import 'package:yuuki/services/user_service.dart';
import 'package:yuuki/listeners/on_user_create_listener.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yuuki/utils/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yuuki/screens/onboarding_screen.dart';

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
  String? _userId;
  String? _userEmail;
  bool? _onboarding;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Ensure 'onboarding' key exists with a default value of false
    bool initialOnboarding = prefs.getBool('onboarding') ?? false;
    prefs.setBool('onboarding', initialOnboarding);

    setState(() {
      _userId = prefs.getString('id');
      _userEmail = prefs.getString('email');
      _onboarding = initialOnboarding; // Use the initial value
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: getMyUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Hiển thị màn hình loading nếu đang tải dữ liệu
            return Scaffold(
              body: Stack(
                children: [
                  // Hình nền
                  Image.asset(
                    "assets/images/onboarding/img_background.jpg",
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  // Widget chứa văn bản và CircularProgressIndicator
                  const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "YUUKI",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 46,
                              fontFamily: "Jua"),
                        ),
                        SizedBox(height: 10),
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text(
                          "Welcome, please wait...",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontFamily: "Jua"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            // Xử lý lỗi nếu có
              return Scaffold(
              body: Text('Error: ${snapshot.error}'),
            );
          } else {
            if (!_onboarding!) {
              return OnboardingScreen();
            }
            // Hiển thị màn hình đăng nhập nếu không tìm thấy người dùng
            if (snapshot.data == null) {
              return LoginScreen();
            } else {
              // Hiển thị màn hình thông tin người dùng nếu đã tìm thấy người dùng
              return HomeScreen(user: snapshot.data!);
            }
          }
        },
      ),
    );
  }

  Future<MyUser?> getMyUser() async {
    if (_userId != null && _userEmail != null) {
      return await _userController.getUserByEmail(_userEmail!);
    }
    return null;
  }
}

/*
class _MyAppState extends State<MyApp> {
  final _userController = UserService();
  String? _userId;
  String? _userEmail;
  MyUser? _foundUser;
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('id');
      _userEmail = prefs.getString('email');
      _isDataLoaded = true;
      getMyUser();
    });
  }

  void getMyUser() async {
    if (_isDataLoaded && _userEmail != null) {
      _foundUser = await _userController.getUserByEmail(_userEmail!);
      if (_foundUser != null) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    if (_foundUser == null){
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: LoginScreen(),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ExampleScreen(user: _foundUser),
      ),
    );
  }
}
*/
