import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yuuki/models/folder.dart';
import 'package:yuuki/models/my_user.dart';

import '../models/topic.dart';
import '../models/user_topic.dart';
import '../results/folder_list_result.dart';
import '../results/folder_result.dart';
import '../results/user_topic_result.dart';

class FolderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFolderToUser(MyUser user, String folderName) async {
    try {
      final String userId = user.id as String; // Use unique ID from MyUser

      final DocumentReference userRef = _firestore.collection("users").doc(userId);
      final CollectionReference foldersCollection = userRef.collection("folders");

      final Folder folder = Folder(folderName:  folderName, topics: [], lastOpen:  DateTime.now().millisecondsSinceEpoch);

      final DocumentReference folderDocRef = await foldersCollection.add(folder.toFirestore());
      folder.setId(folderDocRef.id); // Update folder ID

      await folderDocRef.update({"id": folderDocRef.id}); // Update document with ID

      print("Folder added successfully");
    } on FirebaseException catch (e) {
      print("Error adding folder: ${e.message}");
      // Handle error and notify listener (if applicable)
    }
  }

  Future<FolderListResult> getAllFoldersOfUser(MyUser user) async {
    try {
      final userId = user.id;

      final foldersCollection = FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("folders");

      final foldersQuerySnapshot = await foldersCollection.get();
      final folders = foldersQuerySnapshot.docs
          .map((docSnapshot) => Folder.fromMap(docSnapshot.data()!))
          .toList();

      return FolderListResult(success: true, folders: folders);
    } catch (e) {
      return FolderListResult(success: false, errorMessage: e.toString());
    }
  }

  Future<UserTopicResult> addTopicToFolder(MyUser user, String folderId, String topicId) async {
    try {
      Topic? topic;
      // Fetch the topic using TopicController (replace with actual implementation)
      final DocumentReference topicRef =
      FirebaseFirestore.instance.collection("topics").doc(topicId);
      final DocumentSnapshot documentSnapshot = await topicRef.get();

      if (documentSnapshot.exists) {
        topic = Topic.fromMap(documentSnapshot.data()! as Map<String, dynamic>) ;
      }

      final userId = user.id;

      final folderRef = FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("folders")
          .doc(folderId);

      final folderDocSnapshot = await folderRef.get();
      if (!folderDocSnapshot.exists) {
        // Folder document not found
        return UserTopicResult(success: false, errorMessage: "Folder not found");
      }

      final folder = Folder.fromMap(folderDocSnapshot.data()!);

      final existingUserTopic = folder.topics?.firstWhere((ut) => ut.id == topicId);

      if (existingUserTopic != null) {
        folder.topics!.remove(existingUserTopic);
      }

      final newUserTopic = UserTopic.fromTopic(topic!);
      newUserTopic.id = topicId;
      folder.topics!.add(newUserTopic);

      await folderRef.set(folder.toFirestore());

      // Update the folder's last open timestamp (optional)
      await folderRef.update({"lastOpen": DateTime.now().millisecondsSinceEpoch});

      return UserTopicResult(success: true, userTopic: newUserTopic);
    } catch (e) {
      // Handle errors
      print("Error adding topic to folder: $e");
      return UserTopicResult(success: false, errorMessage: e.toString());
    }
  }

  Future<UserTopicResult> deleteUserTopicFromFolder(MyUser user, String folderId, String userTopicId) async {
    try {

      final userId = user.id;

      final folderRef = FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("folders")
          .doc(folderId);

      final folderDocSnapshot = await folderRef.get();
      if (!folderDocSnapshot.exists) {
        // Folder document not found
        return UserTopicResult(success: false, errorMessage: "Folder not found");
      }

      final folder = Folder.fromMap(folderDocSnapshot.data()!);
      final topics = folder.topics;

      if (topics == null) {
        // No topics in the folder
        return UserTopicResult(success: false, errorMessage: "No topics found in the folder");
      }

      final index = topics.indexWhere((ut) => ut.id == userTopicId);
      if (index == -1) {
        // UserTopic not found in the folder
        return UserTopicResult(success: false, errorMessage: "UserTopic not found in the folder");
      }

      topics.removeAt(index);

      await folderRef.set(folder.toFirestore());

      // Update the folder's last open timestamp (optional)
      await folderRef.update({"lastOpen": DateTime.now().millisecondsSinceEpoch});

      return UserTopicResult(success: true);
    } catch (e) {
      print("Error deleting user topic from folder: $e");
      // Consider returning a more generic error message here
      return UserTopicResult(success: false, errorMessage: "An error occurred");
    }
  }

  Future<FolderResult> getFolderById(MyUser user, String folderId) async {
    try {

      final userId = user.id;

      final folderRef = FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("folders")
          .doc(folderId);

      final folderDocSnapshot = await folderRef.get();
      if (!folderDocSnapshot.exists) {
        // Folder document not found
        return FolderResult(success: false, errorMessage: "Folder not found");
      }

      final folder = Folder.fromMap(folderDocSnapshot.data()!);
      return FolderResult(success: true, folder: folder);
    } catch (e) {
      print("Error fetching folder by ID: $e");
      return FolderResult(success: false, errorMessage: "An error occurred");
    }
  }

  Future<FolderResult> deleteFolder(MyUser user, String folderId) async {
    try {
      final userId = user.id;

      final folderRef = FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("folders")
          .doc(folderId);

      await folderRef.delete();
      return FolderResult(success: true);
    } catch (e) {
      print("Error deleting folder: $e");
      return FolderResult(success: false, errorMessage: "An error occurred");
    }
  }

}