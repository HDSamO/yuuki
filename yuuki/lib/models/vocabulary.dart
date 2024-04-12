import 'package:cloud_firestore/cloud_firestore.dart';

class Vocabulary {
  final String term;
  final String definition;
  final bool isStarred;
  final String? category;

  Vocabulary({
    required this.term,
    required this.definition,
    this.isStarred = false, // Optional with default value
    this.category, // Optional
  });

  factory Vocabulary.fromMap(Map<String, dynamic> map) {
    return Vocabulary(
      term: map['term'] as String,
      definition: map['definition'] as String,
      isStarred: map['isStarred'] as bool ?? false, // Handle null value
      category: map['category'] as String, 
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'term': term,
      'definition': definition,
      'isStarred': isStarred,
      'category': category,
    };
  }
}