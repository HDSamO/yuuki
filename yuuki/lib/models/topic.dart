import "package:yuuki/models/my_user.dart";
import "package:yuuki/models/top_user.dart";
import "package:yuuki/models/user_topic.dart";
import "package:yuuki/models/vocabulary.dart";


class Topic {
  String id;
  String title;
  String? author; // Assuming author information is available (modify if not)
  String authorName; // Assuming author information is available (modify if not)
  String description;
  List<Vocabulary> vocabularies;
  bool isPrivate;
  int lastModify; // Assuming long can be represented by int in Flutter
  int views;
  List<TopUser> bestScorers;
  List<TopUser> bestViewers;

  Topic({
    required this.id,
    required this.title,
    required this.description,
    required this.vocabularies,
    required this.isPrivate,
    this.author, // Optional: Modify based on availability
    required this.authorName, // Optional: Modify based on availability
    this.lastModify = 0, // Assuming default last modified time
    this.views = 0,
    this.bestScorers = const [], // Empty list by default
    this.bestViewers = const [], // Empty list by default
  });

  factory Topic.fromUserCreated(MyUser user, String title, String description, List<Vocabulary> vocabularies, bool isPrivate) {
    return Topic(
      id: "", // Assuming ID is generated elsewhere
      title: title,
      description: description,
      vocabularies: vocabularies,
      isPrivate: isPrivate,
      author: user.id,
      authorName: user.name
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'authorName': authorName,
      'description': description,
      'vocabularies': vocabularies.map((vocab) => vocab.toFirestore()).toList(),
      'isPrivate': isPrivate,
      'lastModified': lastModify,
      'views': views,
      'bestScorers': bestScorers.map((user) => user.toFirestore()).toList(),
      'bestViewers': bestViewers.map((user) => user.toFirestore()).toList(),
    };
  }

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      id: map['id'] as String,
      title: map['title'] as String,
      author: map['author'] as String?,
      authorName: map['authorName'] as String,
      description: map['description'] as String,
      vocabularies: (map['vocabularies'] as List)
          .map((vocabMap) => Vocabulary.fromMap(vocabMap))
          .toList(),
      isPrivate: map['isPrivate'] as bool,
      lastModify: map['lastModified'] as int,
      views: map['views'] as int,
      bestScorers: (map['bestScorers'] as List)
          .map((userMap) => TopUser.fromMap(userMap))
          .toList(),
      bestViewers: (map['bestViewers'] as List)
          .map((userMap) => TopUser.fromMap(userMap))
          .toList(),
    );
  }

  // Getters
  String get getId => id;
  String get getTitle => title;
  String? get getAuthor => author;
  String get getAuthorName => authorName;
  String get getDescription => description;
  List<Vocabulary> get getVocabularies => vocabularies;
  bool get getIsPrivate => isPrivate;
  int get getLastModify => lastModify;
  int get getViews => views;
  List<TopUser> get getBestScorers => bestScorers;
  List<TopUser> get getBestViewers => bestViewers;

  // Setters
  void setId(String value) => id = value;
  void setTitle(String value) => title = value;
  void setAuthor(String? value) => author = value;
  void setAuthorName(String value) => authorName = value;
  void setDescription(String value) => description = value;
  void setVocabularies(List<Vocabulary> value) => vocabularies = value;
  void setIsPrivate(bool value) => isPrivate = value;
  void setLastModify(int value) => lastModify = value;
  void setViews(int value) => views = value;
  void setBestScorers(List<TopUser> value) => bestScorers = value;
  void setBestViewers(List<TopUser> value) => bestViewers = value;


}