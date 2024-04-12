import 'package:yuuki/models/my_user.dart';

abstract class OnLoginListener {
    void onLoginSuccess(MyUser user);
    void onLoginFailure(String? message);
}