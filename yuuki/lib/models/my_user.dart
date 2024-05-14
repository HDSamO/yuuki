import "package:yuuki/models/folder.dart";
import "package:yuuki/models/user_topic.dart";

class MyUser {
  String? id;
  String name;
  String birthday;
  String email;
  String phone;
  UserTopic? starredTopic;
  List<Folder> folders = [];
  List<UserTopic> userTopics = [];

  MyUser({
    this.id,
    required this.name,
    required this.birthday,
    required this.email,
    required this.phone,
    this.starredTopic,
    this.folders = const [],
    this.userTopics = const [],
  });

  // Factory constructor for mapping from Firestore data
  factory MyUser.fromMap(Map<String, dynamic> data) {
    return MyUser(
      id: data['id'],
      name: data['name'],
      birthday: data['birthday'],
      email: data['email'],
      phone: data['phone'],
      starredTopic: data['starredTopic'] != null
          ? UserTopic.fromMap(data['starredTopic'] as Map<String, dynamic>)
          : null,
      folders: (data['folders'] as List<dynamic>?)
              ?.map((folderData) =>
                  Folder.fromMap(folderData as Map<String, dynamic>))
              .toList() ??
          [],
      userTopics: (data['userTopics'] as List<dynamic>?)
              ?.map((topicData) =>
                  UserTopic.fromMap(topicData as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  factory MyUser.fromMapUser(Map<String, dynamic> data) {
    return MyUser(
      id: data['id'],
      name: data['name'],
      birthday: data['birthday'],
      email: data['email'],
      phone: data['phone'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'birthday': birthday,
      'email': email,
      'phone': phone,
      'starredTopic': starredTopic?.toFirestore(),
      'folders': folders.map((folder) => folder.toFirestore()).toList(),
      'userTopics': userTopics.map((topic) => topic.toFirestore()).toList(),
    };
  }

  @override
  String toString() {
    return 'User{name: $name, birthday: $birthday, email: $email, phone: $phone}';
  }
}
