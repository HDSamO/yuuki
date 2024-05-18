import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/results/password_result.dart';
import 'package:yuuki/screens/home_screen.dart';
import 'package:yuuki/services/topic_service.dart';
import 'package:yuuki/services/user_service.dart';
import 'package:yuuki/utils/const.dart';
import 'package:yuuki/utils/demension.dart';

class CustomDialogEditProfile extends StatefulWidget {
  final MyUser user;

  CustomDialogEditProfile(this.user);

  @override
  State<CustomDialogEditProfile> createState() =>
      _CustomDialogEditProfileState();
}

class _CustomDialogEditProfileState extends State<CustomDialogEditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  String _nameError = '';
  String _dobError = '';
  String _phoneNumberError = '';

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
    _dateOfBirthController.text = widget.user.birthday;
    _phoneNumberController.text = widget.user.phone;
  }

  _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            // Set the background color of the DatePicker to white
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // Text color
              onPrimary: Colors.white, // Text color when selected
              surface: Colors.white, // Background color
              onSurface: Colors.black, // Text color on background
            ),
          ),
          child: child ?? Container(),
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _dateOfBirthController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // barrierDismissible: false,
      child: Container(
        height: 440,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                "Edit Profile",
                style: TextStyle(
                  fontSize: Dimensions.fontSize(context, 20),
                  fontFamily: "Quicksand",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameController,
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
                              labelText: 'Name',
                              labelStyle: TextStyle(
                                color: Colors.blue,
                              ),
                              errorText:
                                  _nameError.isNotEmpty ? _nameError : null,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _nameError =
                                    value.isEmpty ? 'Name cannot be empty' : '';
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            onTap: () {
                              _showDatePicker(context);
                            },
                            controller: _dateOfBirthController,
                            readOnly: true,
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
                              labelText: 'Birthday',
                              labelStyle: TextStyle(
                                color: Colors.blue,
                              ),
                              errorText:
                                  _dobError.isNotEmpty ? _dobError : null,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _dobError = value.isEmpty
                                    ? 'Please select your date of birth'
                                    : '';
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: _phoneNumberController,
                            keyboardType:
                                TextInputType.number, // Numeric keyboard
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
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
                              labelText: 'Phone number',
                              labelStyle: TextStyle(
                                color: Colors.blue,
                              ),
                              errorText: _phoneNumberError.isNotEmpty
                                  ? _phoneNumberError
                                  : null,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _phoneNumberError = value.isEmpty
                                    ? 'Phone number cannot be empty'
                                    : '';
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
                              fontSize: Dimensions.fontSize(context, 16),
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
                            if (_nameError.isNotEmpty ||
                                _dobError.isNotEmpty ||
                                _phoneNumberError.isNotEmpty) {
                              return;
                            }

                            MyUser updatedUser = MyUser(
                              email: widget.user.email,
                              name: _nameController.text,
                              birthday: _dateOfBirthController.text,
                              phone: _phoneNumberController.text,
                              folders: widget.user.folders,
                              id: widget.user.id,
                              starredTopic: widget.user.starredTopic,
                              userTopics: widget.user.userTopics,
                            );
                            TopicController().updateAuthorName(updatedUser);
                            await UserService().updateUser(updatedUser);

                            _showSuccessDialog(updatedUser);
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(
                              fontSize: Dimensions.fontSize(context, 16),
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
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(MyUser updatedUser) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: Dimensions.height(context, 180),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
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
                        Color(0x803DB7FC),
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Confirm Update",
                    style: TextStyle(
                      fontSize: Dimensions.fontSize(context, 20),
                      fontFamily: "Quicksand",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  child: Text(
                    "User information has been updated",
                    style: TextStyle(
                      fontSize: Dimensions.fontSize(context, 16),
                      fontFamily: "QuicksandRegular",
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomeScreen(user: updatedUser)),
                        );
                      },
                      child: Text(
                        "oke",
                        style: TextStyle(
                          fontSize: Dimensions.fontSize(context, 16),
                          fontFamily: "QuicksandRegular",
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 40,
                        ),
                        foregroundColor: AppColors.mainColor,
                        side: BorderSide(
                          color: AppColors.mainColor,
                        ),
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
