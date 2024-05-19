import 'package:flutter/material.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/screens/login_screen.dart';
import 'package:yuuki/theme/theme.dart';
import 'package:yuuki/widgets/customs/custom_login_button.dart';
import 'package:yuuki/widgets/customs/custom_login_scaffold.dart';

import '../results/user_result.dart';
import '../services/user_service.dart';
import '../widgets/customs/custom_input_text.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignupKey = GlobalKey<FormState>();
  final _userController = UserService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  DateTime? _dob;
  bool _isSubmit = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  bool _validateEmail(String email) {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  bool _validatePhoneNumber(String phoneNumber) {
    // Kiểm tra độ dài của chuỗi và xem nó có phải là số hay không
    return phoneNumber.length == 10 &&
        RegExp(r'^[0-9]+$').hasMatch(phoneNumber);
  }

  bool _validatePassword(String password) {
    // Kiểm tra độ dài của mật khẩu
    if (password.length < 6) {
      return false;
    }

    // Kiểm tra xem mật khẩu có ít nhất một chữ in hoa, một chữ thường và một số
    bool hasUpperCase = password.contains(new RegExp(r'[A-Z]'));
    bool hasLowerCase = password.contains(new RegExp(r'[a-z]'));
    bool hasDigit = password.contains(new RegExp(r'[0-9]'));

    // Trả về true nếu mật khẩu thỏa mãn tất cả các điều kiện
    return hasUpperCase && hasLowerCase && hasDigit;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = _dob ?? DateTime(now.year - 10);
    final DateTime firstDate = DateTime(now.year - 99);
    final DateTime lastDate = DateTime(now.year - 10);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != _dob) {
      setState(() {
        _dob = picked;
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _handleSubmit() async {
    setState(() {
      _isSubmit = true;
    });

    if (_formSignupKey.currentState?.validate() ?? false) {
      String fullName = _nameController.text.trim();
      String dob = _dobController.text.trim();
      String email = _emailController.text.trim();
      String phoneNumber = _phoneController.text.trim();
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
              Text("SignUp..."),
            ],
          ),
          duration: Duration(seconds: 5),
        ),
      );

      // Chờ cho đến khi quá trình đăng nhập hoàn thành
      MyUser? myUser = MyUser(
          name: fullName, birthday: dob, email: email, phone: phoneNumber);

      UserResult userResult = await _userController.addUser(myUser, password);

      // After login process completed
      setState(() {
        _isLoading = false;
      });

      if (userResult.success) {
        setState(() {
          _isSubmit = false;
        });

        // Clear form fields
        _nameController.clear();
        _dobController.clear();
        _emailController.clear();
        _phoneController.clear();
        _passwordController.clear();
        _rePasswordController.clear();

        Navigator.pop(context);
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
                      margin: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                      padding:
                          const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                        ),
                      ),
                      child: Container(
                        width: 500,
                        child: Column(
                          children: [
                            Form(
                              key: _formSignupKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Create a new account!",
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: "Jua"),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  const Text(
                                    "Tell us a bit about yourself",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: "Cabin",
                                        fontStyle: FontStyle.italic),
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  // Full Name
                                  CustomInputText(
                                    controller: _nameController,
                                    hintText: "Full name",
                                    keyboardType: TextInputType.name,
                                    autoFocus: true,
                                    onChanged: (_) {
                                      if (_isSubmit) {
                                        _formSignupKey.currentState!.validate();
                                      }
                                    },
                                    onSaved: (v) {},
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter full name';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15.0),
                                  TextFormField(
                                    controller: _dobController,
                                    readOnly: true,
                                    onTap: () {
                                      _selectDate(context);
                                    },
                                    decoration: const InputDecoration(
                                      hintText: "Select Date",
                                      hintStyle: TextStyle(color: Colors.blue),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2),
                                      ),
                                    ),
                                    style: const TextStyle(color: Colors.blue),
                                    onChanged: (_) {
                                      if (_isSubmit) {
                                        _formSignupKey.currentState!.validate();
                                      }
                                    },
                                    onSaved: (v) {},
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select date of birth';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  // Email
                                  CustomInputText(
                                    controller: _emailController,
                                    hintText: "Email",
                                    keyboardType: TextInputType.name,
                                    onChanged: (_) {
                                      if (_isSubmit) {
                                        _formSignupKey.currentState!.validate();
                                      }
                                    },
                                    onSaved: (v) {},
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter email';
                                      }
                                      if (!_validateEmail(value)) {
                                        return 'This is a not a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  // Phone
                                  CustomInputText(
                                    controller: _phoneController,
                                    hintText: "Phone number",
                                    keyboardType: TextInputType.number,
                                    onChanged: (_) {
                                      if (_isSubmit) {
                                        _formSignupKey.currentState!.validate();
                                      }
                                    },
                                    onSaved: (v) {},
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter phone number';
                                      }
                                      if (!_validatePhoneNumber(value)) {
                                        return 'This is a not a valid phone number';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  // Full Name
                                  CustomInputText(
                                    controller: _passwordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    hintText: "Password",
                                    onChanged: (_) {
                                      if (_isSubmit) {
                                        _formSignupKey.currentState!.validate();
                                      }
                                    },
                                    onSaved: (v) {},
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter password';
                                      }
                                      if (!_validatePassword(value)) {
                                        return 'The password at least 6 characters long with at least one uppercase letter, one lowercase letter, and one digit';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  // Email
                                  CustomInputText(
                                    controller: _rePasswordController,
                                    hintText: "Confirm Password",
                                    keyboardType: TextInputType.visiblePassword,
                                    onChanged: (_) {
                                      if (_isSubmit) {
                                        _formSignupKey.currentState!.validate();
                                      }
                                    },
                                    onSaved: (v) {},
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter confirm password';
                                      }
                                      if (_passwordController.text.trim() !=
                                          value) {
                                        return 'The password and confirmation password do not match';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            // already have an account
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Already have an account? ',
                                  style: TextStyle(
                                    color: Colors.black45,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (e) => const LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Sign in',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: lightColorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            CustomLoginButton(
                                onPressed: () {
                                  _handleSubmit();
                                },
                                text: "SIGN UP",
                                width: double.infinity,
                                height: 54)
                          ],
                        ),
                      )),
                )),
          ],
        ),
      ),
    );
  }
}
