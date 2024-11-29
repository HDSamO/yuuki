import 'user_topic.dart'; // Assuming user_topic.dart is defined with the UserTopic class

class Folder {
  String folderName;
  String? id; // Optional: Allow null for initial creation
  List<UserTopic> topics;
  int lastOpen; // Assuming long can be represented by int in Flutter

  Folder({
    required this.folderName,
    this.id,
    required this.topics,
    required this.lastOpen,
  });

  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      folderName: map['folderName'] as String,
      id: map['id'] as String, // Allow null id
      topics: (map['topics'] as List)
          .map((topicMap) => UserTopic.fromMap(topicMap))
          .toList(),
      lastOpen: map['lastOpen'] != null ? map['lastOpen'] as int : 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'folderName': folderName,
      'id': id,
      'topics': topics.map((topic) => topic.toFirestore()).toList(),
      'lastOpen': lastOpen,
    };
  }

  String get getFolderName =>
      folderName; // Getter for folderName (already final)
  String? get getId => id; // Getter for id with null safety
  get getLastOpen => lastOpen; // Getter for lastOpen (already final)

  void setFolderName(String value) {
    folderName = value;
  }

  void setId(String? value) {
    id = value;
  }

  List<UserTopic> get getTopics => topics; // Getter for topics (immutable)

  void setTopics(List<UserTopic> value) {
    topics = value;
  }

  void setLastOpen(int value) {
    lastOpen = value;
  }
}
