import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  // Get all users
  Future<List<QueryDocumentSnapshot>> getUserList() async {
    final snapshot = await usersCollection.get();
    return snapshot.docs;
  }

  // Add a new user
  Future<void> addUser(Map<String, dynamic> userData) async {
    await usersCollection.add(userData);
  }

}
