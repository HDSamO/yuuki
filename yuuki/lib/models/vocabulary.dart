import 'package:cloud_firestore/cloud_firestore.dart';

class Vocabulary {
  final String term;
  final String definition;
  final bool stared;
  final String? category;

  Vocabulary({
    required this.term,
    required this.definition,
    this.stared = false, // Optional with default value
    this.category, // Optional
  });

  factory Vocabulary.fromMap(Map<String, dynamic> map) {
    return Vocabulary(
      term: map['term'] as String,
      definition: map['definition'] as String,
      stared: map['stared'] != null ?
        map['stared'] as bool: false, // Handle null value
      category: map['category'] as String?, 
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'term': term,
      'definition': definition,
      'stared': stared,
      'category': category,
    };
  }
}