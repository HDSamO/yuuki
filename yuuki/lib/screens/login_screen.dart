import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/screens/example_screen.dart';
import 'package:yuuki/screens/library_screen.dart';
import 'package:yuuki/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/signup_screen.dart';
import '../widgets/custom_input_text.dart';
import '../widgets/custom_login_button.dart';
import '../widgets/custom_login_scaffold.dart';
import '../theme/theme.dart';
import '../results/user_result.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = UserService();
  final _formLoginKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _isSubmit = false;
  bool _isLoading = false;

  // Lưu thông tin người dùng vào SharedPreferences
  Future<void> saveUserToSharedPreferences(String? id, String? email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (id != null) {
      prefs.setString('id', id);
    }

    if (email != null){
      prefs.setString('email', email);
    }
  }

  void _handleSubmit() async{
    setState(() {
      _isSubmit = true;
    });

    if (_formLoginKey.currentState?.validate() ?? false) {
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();

      setState(() {
        _isLoading = true;
      });

      // Show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text("Loading..."),
            ],
          ),
          duration: Duration(seconds: 5),
        ),
      );

      // Chờ cho đến khi quá trình đăng nhập hoàn thành
      UserResult userResult = await _userController.userLogin(username, password);

      // After login process completed
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide the loading snackbar

      if (userResult.success) {
        setState(() {
          _isSubmit = false;
        });

        // Clear form fields
        _usernameController.clear();
        _passwordController.clear();

        MyUser? myUser = userResult.user;

        if (_rememberMe){
          String? id = myUser!.id;
          String? email = myUser.email;

          // Lưu thông tin người dùng vào SharedPreferences
          await saveUserToSharedPreferences(id, email);
        } else {
          await saveUserToSharedPreferences("", "");
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (e) => LibraryScreen(myUser: myUser),
          ),
        );

        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Processing Data'),
        //   ),
        // );
      } else {
        String message = userResult.errorMessage ?? "";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } else {
      // Form validation failed
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomLoginScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 10,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                padding: const EdgeInsets.fromLTRB(25.0, 30.0, 25.0, 25.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0)
                  ),
                ),
                child: Form(
                  key: _formLoginKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF57A4FF),
                          fontFamily: "Cabin"
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      CustomInputText(
                        controller: _usernameController,
                        hintText: "Username",
                        keyboardType: TextInputType.name,
                        autoFocus: true,
                        onChanged: (_) {
                          if (_isSubmit) {
                            _formLoginKey.currentState!.validate();
                          }
                        },
                        onSaved: (v) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Username';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 25.0,
                      ),
                      CustomInputText(
                        controller: _passwordController,
                        hintText: "Password",
                        keyboardType: TextInputType.name,
                        autoFocus: false,
                        onChanged: (_) {
                          if (_isSubmit) {
                            _formLoginKey.currentState!.validate();
                          }
                        },
                        onSaved: (v) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _rememberMe = value!;
                                  });
                                },
                                activeColor: lightColorScheme.primary,
                              ),
                              const Text(
                                'Remember me',
                                style: TextStyle(
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightColorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      CustomLoginButton(
                        onPressed: () {
                          _handleSubmit();
                        },
                        text: 'LOGIN',
                        width: double.infinity,
                        height: 54,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account? ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightColorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
