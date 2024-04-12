import 'package:yuuki/models/my_user.dart';

abstract class OnUserCreateListener {
    void onUserCreateSuccess(MyUser user);
    void onUserCreateFailure(String? message);
}