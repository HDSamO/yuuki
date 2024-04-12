import "package:yuuki/models/my_user.dart";


class TopUser {
  final String name;
  final String birthday;
  final String email;
  final String phone;
  final double score;
  final int rawTime; // Assuming long can be represented by int in Flutter
  final String? formattedTime;
  final int viewCount;

  TopUser({
    required this.name,
    required this.birthday,
    required this.email,
    required this.phone,
    required this.score,
    required this.rawTime,
    this.formattedTime, // Optional: Allow null for initial creation
    required this.viewCount,
  });

  factory TopUser.fromUser(MyUser user, double score, int rawTime, int viewCount) {
    return TopUser(
      name: user.name,
      birthday: user.birthday,
      email: user.email,
      phone: user.phone,
      score: score,
      rawTime: rawTime,
      viewCount: viewCount,
    );
  }

  // void convertRawTimeToFormattedTime() {
  //   int hours = Duration.millisecondsSinceEpoch(rawTime) ~/ Duration.hoursInMilliseconds;
  //   int minutes = (Duration.millisecondsSinceEpoch(rawTime) % Duration.hoursInMilliseconds) ~/ Duration.minutesInMilliseconds;
  //   int seconds = (Duration.millisecondsSinceEpoch(rawTime) % Duration.minutesInMilliseconds) ~/ Duration.secondsInMilliseconds;

  //   formattedTime = formattedTime ?? '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'; // Use string interpolation and padLeft for leading zeros
  // }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'birthday': birthday,
      'email': email,
      'phone': phone,
      'score': score,
      'rawTime': rawTime,
      'formattedTime': formattedTime,
      'viewCount': viewCount,
    };
  }

  factory TopUser.fromMap(Map<String, dynamic> map) {
    return TopUser(
      name: map['name'] as String,
      birthday: map['birthday'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      score: map['score'] as double,
      rawTime: map['rawTime'] as int,
      formattedTime: map['formattedTime'] as String?,
      viewCount: map['viewCount'] as int,
    );
  }
}