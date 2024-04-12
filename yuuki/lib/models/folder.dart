import 'user_topic.dart'; // Assuming user_topic.dart is defined with the UserTopic class

class Folder {
  final String folderName;
  final String id; // Optional: Allow null for initial creation
  final List<UserTopic> topics;
  final int lastOpen; // Assuming long can be represented by int in Flutter

  Folder({
    required this.folderName,
    required this.id, 
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
      lastOpen: map['lastOpen'] as int,
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
}