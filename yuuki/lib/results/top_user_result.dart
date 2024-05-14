import 'package:yuuki/models/top_user.dart';

class TopUserResult {
  final bool success;
  final String? errorMessage;
  final List<TopUser>? topScorers;

  TopUserResult({
    required this.success,
    this.errorMessage,
    this.topScorers,
  });
}