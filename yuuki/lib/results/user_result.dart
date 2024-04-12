import 'package:yuuki/models/my_user.dart';

class UserResult {
  final bool success;
  final MyUser? user;
  final String? errorMessage;

  const UserResult({required this.success, this.user, this.errorMessage});
}