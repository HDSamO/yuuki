import 'package:yuuki/models/topic.dart';
import 'package:yuuki/models/vocabulary.dart';


class UserTopic {
  String id;
  String title;
  String? author;
  String authorName;
  String description;
  bool private;
  List<Vocabulary> vocabularies;
  int lastOpen; // Assuming long can be represented by int in Flutter
  int startTime; // Assuming long can be represented by int in Flutter
  int endTime; // Assuming long can be represented by int in Flutter
  int lastTime; // Assuming long can be represented by int in Flutter
  int bestTime; // Assuming long can be represented by int in Flutter
  double lastScore;
  double bestScore;
  int view;

  UserTopic({
    required this.id,
    required this.title,
    this.author,
    required this.authorName,
    required this.description,
    required this.private,
    required this.vocabularies,
    required this.lastOpen,
    required this.startTime,
    required this.endTime,
    required this.lastTime,
    required this.bestTime,
    required this.lastScore,
    required this.bestScore,
    required this.view,
  });

  factory UserTopic.fromTopic(Topic topic) {
    return UserTopic(
      id: topic.id, // Assuming ID is available in Topic
      title: topic.title,
      author: topic.author,
      authorName: topic.authorName,
      description: topic.description,
      private: topic.private,
      vocabularies: handleVocab(topic.vocabularies),
      lastOpen: DateTime.now().millisecondsSinceEpoch, // Use current time
      startTime: 0, // Assuming default start time (modify if needed)
      endTime: 0, // Assuming default end time (modify if needed)
      lastTime: 0, // Assuming default last time (modify if needed)
      bestTime: 0, // Assuming default best time (modify if needed)
      lastScore: 0.0, // Assuming default last score (modify if needed)
      bestScore: 0.0, // Assuming default best score (modify if needed)
      view: 0, // Assuming default view count (modify if needed)
    );
  }

    factory UserTopic.updateFromTopic(Topic topic) {
    return UserTopic(
      id: topic.id, // Assuming ID is available in Topic
      title: topic.title,
      author: topic.author,
      authorName: topic.authorName,
      description: topic.description,
      private: topic.private,
      vocabularies: handleVocab(topic.vocabularies),
      lastOpen: DateTime.now().millisecondsSinceEpoch, // Use current time
      startTime: 0, // Assuming default start time (modify if needed)
      endTime: 0, // Assuming default end time (modify if needed)
      lastTime: 0, // Assuming default last time (modify if needed)
      bestTime: 0, // Assuming default best time (modify if needed)
      lastScore: 0.0, // Assuming default last score (modify if needed)
      bestScore: 0.0, // Assuming default best score (modify if needed)
      view: 0, // Assuming default view count (modify if needed)
    );
  }


  static List<Vocabulary> handleVocab(List<Vocabulary> newVocabs) {
    List<Vocabulary> currentVocabs = []; // Assuming no initial vocabularies
    List<Vocabulary> output = [];

    // Iterate through the new vocabularies list
    for (Vocabulary newVocab in newVocabs) {
      Vocabulary? matchedVocab;

      // Find a matching vocabulary based on term and definition
      for (Vocabulary currentVocab in currentVocabs) {
        if (currentVocab.term == newVocab.term &&
            currentVocab.definition == newVocab.definition) {
          matchedVocab = currentVocab;
          break;
        }
      }

      // Merge vocabulary if matched, otherwise add new
      if (matchedVocab != null) {
        output.add(Vocabulary(
          term: matchedVocab.term,
          definition: matchedVocab.definition,
          stared: matchedVocab.stared,
          category: matchedVocab.category,
        ));
      } else {
        output.add(newVocab);
      }
    }

    return output;
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'authorName': authorName,
      'description': description,
      'private': private,
      'vocabularies': vocabularies.map((vocab) => vocab.toFirestore()).toList(),
      'lastOpen': lastOpen,
      'startTime': startTime,
      'endTime': endTime,
      'lastTime': lastTime,
      'bestTime': bestTime,
      'lastScore': lastScore,
      'bestScore': bestScore,
      'view': view,
    };
  }

  factory UserTopic.fromMap(Map<String, dynamic> map) {
    return UserTopic(
      id: map['id'] as String,
      title: map['title'] as String,
      author: map['author'] as String?,
      authorName: map['authorName'] as String,
      description: map['description'] as String,
      private: map['private'] as bool,
      vocabularies: (map['vocabularies'] as List)
          .map((vocabMap) => Vocabulary.fromMap(vocabMap))
          .toList(),
      lastOpen: map['lastOpen'] as int,
      startTime: map['startTime'] as int,
      endTime: map['endTime'] as int,
      lastTime: map['lastTime'] as int,
      bestTime: map['bestTime'] as int,
      lastScore: map['lastScore'] as double,
      bestScore: map['bestScore'] as double,
      view: map['view'] as int,
    );
  }

  // Getters
  String get getId => id;
  String get getTitle => title;
  String? get getAuthor => author;
  String get getAuthorName => authorName;
  String get getDescription => description;
  bool get getPrivate => private;
  List<Vocabulary> get getVocabularies => vocabularies;
  int get getLastOpen => lastOpen;
  int get getStartTime => startTime;
  int get getEndTime => endTime;
  int get getLastTime => lastTime;
  int get getBestTime => bestTime;
  double get getLastScore => lastScore;
  double get getBestScore => bestScore;
  int get getView => view;

  // Setters
  void setId(String value) => id = value;
  void setTitle(String value) => title = value;
  void setAuthor(String? value) => author = value;
  void setAuthorName(String? value) => author = value;
  void setDescription(String value) => description = value;
  void setPrivate(bool value) => private = value;
  void setVocabularies(List<Vocabulary> value) => vocabularies = value;
  void setLastOpen(int value) => lastOpen = value;
  void setStartTime(int value) => startTime = value;
  void setEndTime(int value) => endTime = value;
  void setLastTime(int value) => lastTime = value;
  void setBestTime(int value) => bestTime = value;
  void setLastScore(double value) => lastScore = value;
  void setBestScore(double value) => bestScore = value;
  void setView(int value) => view = value;

  void incrementView() {view++;}
}