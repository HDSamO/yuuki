import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yuuki/models/folder.dart';
import 'package:yuuki/models/my_user.dart';

class FolderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFolderToUser(MyUser user, String folderName) async {
    try {
      final String userId = user.id as String; // Use unique ID from MyUser

      final DocumentReference userRef = _firestore.collection("users").doc(userId);
      final CollectionReference foldersCollection = userRef.collection("folders");

      final Folder folder = Folder(folderName:  folderName, topics: [], lastOpen:  DateTime.now().millisecondsSinceEpoch);

      final DocumentReference folderDocRef = await foldersCollection.add(folder);
      folder.setId(folderDocRef.id); // Update folder ID

      await folderDocRef.update({"id": folderDocRef.id}); // Update document with ID

      print("Folder added successfully");
    } on FirebaseException catch (e) {
      print("Error adding folder: ${e.message}");
      // Handle error and notify listener (if applicable)
    }
  }
}