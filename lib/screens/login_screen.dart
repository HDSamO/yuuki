import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/pages/library_page.dart';
import 'package:yuuki/screens/home_screen.dart';
import 'package:yuuki/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yuuki/utils/demension.dart';

import '../results/password_result.dart';
import '../screens/signup_screen.dart';
import '../utils/const.dart';
import '../widgets/customs/custom_input_text.dart';
import '../widgets/customs/custom_login_button.dart';
import '../widgets/customs/custom_login_scaffold.dart';
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
  bool _isPasswordVisible = false;

  // Lưu thông tin người dùng vào SharedPreferences
  Future<void> saveUserToSharedPreferences(String? id, String? email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (id != null) {
      prefs.setString('id', id);
    }

    if (email != null) {
      prefs.setString('email', email);
    }
  }

  void _handleSubmit() async {
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
              Text("Logging in..."),
            ],
          ),
          duration: Duration(seconds: 5),
        ),
      );

      // Chờ cho đến khi quá trình đăng nhập hoàn thành
      UserResult userResult =
          await _userController.userLogin(username, password);

      // After login process completed
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .hideCurrentSnackBar(); // Hide the loading snackbar

      if (userResult.success) {
        setState(() {
          _isSubmit = false;
        });

        // Clear form fields
        _usernameController.clear();
        _passwordController.clear();

        MyUser? myUser = userResult.user;

        if (_rememberMe) {
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
            builder: (e) => HomeScreen(user: myUser!),
          ),
        );
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
      child: Center(
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
                        bottomRight: Radius.circular(30.0)),
                  ),
                  child: Form(
                    key: _formLoginKey,
                    child: Container(
                      width: 500,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'LOGIN',
                            style: TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF57A4FF),
                                fontFamily: "Cabin"),
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
                            keyboardType: TextInputType.visiblePassword,
                            autoFocus: false,
                            obscureText: !_isPasswordVisible,
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
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
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
                                onTap: () {
                                  _showForgotPasswordDialog(context);
                                },
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
                                      builder: (e) => SignUpScreen(),
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
      ),
    );
  }

  bool _validateEmail(String email) {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  Widget showDialogMessage(Color color, String title, String message) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: color,
        ),
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            if (title == "Error") {
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
              Navigator.pop(context);
            }
          },
          child: Text('OK'),
        ),
      ],
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 500,
            padding: EdgeInsets.only(bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF397CFF),
                        Color(0x803DB7FC), // 0x80 for 50% opacity
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Quicksand",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.all(Dimensions.fontSize(context, 20)),
                  child: TextField(
                    controller: emailController,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.blue,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(
                        color: Colors.blue,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height(context, 16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "QuicksandRegular",
                          color: Color(0xffec5b5b),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 40,
                        ),
                        foregroundColor: Color(0xffec5b5b),
                        side: BorderSide(
                          color: Color(0xffec5b5b),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        String email = emailController.text;

                        if (email.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return showDialogMessage(Colors.red, "Error",
                                  "Please enter your email");
                            },
                          );
                        } else if (!_validateEmail(email)) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return showDialogMessage(Colors.red, "Error",
                                  "This is a not a valid email");
                            },
                          );
                        } else {
                          PasswordResult passwordResult =
                              await UserService().sendPasswordResetEmail(email);

                          if (passwordResult.success) {
                            emailController.clear();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return showDialogMessage(Colors.green,
                                    "Success", "Please check your email!");
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return showDialogMessage(
                                    Colors.red,
                                    "Error",
                                    passwordResult.errorMessage ??
                                        "An error occurred. Please check your entered email");
                              },
                            );
                          }
                        }
                      },
                      child: Text(
                        "Send",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "QuicksandRegular",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 40,
                        ),
                        backgroundColor: AppColors.mainColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
