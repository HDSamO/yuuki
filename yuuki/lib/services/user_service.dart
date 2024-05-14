import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yuuki/listeners/on_password_change_listener.dart';
import 'package:yuuki/listeners/on_password_reset_listener.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/listeners/on_user_create_listener.dart';
import 'package:yuuki/listeners/on_login_listener.dart';
import 'package:yuuki/results/password_result.dart';
import 'package:yuuki/results/user_result.dart';

import '../models/user_topic.dart';

class UserService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Get all users
  Future<List<QueryDocumentSnapshot>> getUserList() async {
    final snapshot = await usersCollection.get();
    return snapshot.docs;
  }

  //not tested
  Future<MyUser?> getUserById(String userId) async {
    DocumentReference userRef = usersCollection.doc(userId);
    DocumentSnapshot snapshot = await userRef.get();

    if (snapshot.exists) {
      return MyUser.fromMap(snapshot.data()! as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<UserResult> addUser(MyUser user, String password) async {
    try {
      // Create a new user with email and password
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      // Get the newly created user
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Create a document reference with the user's UID as the ID
        DocumentReference userRef = usersCollection.doc(firebaseUser.uid);
        user.id = firebaseUser.uid;
        await userRef.set(user.toFirestore());

        // Get the newly created user document
        DocumentSnapshot documentSnapshot = await userRef.get();

        if (documentSnapshot.exists) {
          // Convert the document data back to a MyUser object
          MyUser createdUser =
              MyUser.fromMap(documentSnapshot.data()! as Map<String, dynamic>);
          return UserResult(success: true, user: createdUser);
        } else {
          // Handle case where the document doesn't exist (unlikely)
          return UserResult(
              success: false, errorMessage: "User document not found");
        }
      } else {
        // Handle failed user creation with Firebase Authentication
        return UserResult(
            success: false,
            errorMessage: "Failed to create user with Firebase Authentication");
      }
    } on FirebaseAuthException catch (e) {
      return UserResult(success: false, errorMessage: e.toString());
    } catch (e) {
      // Handle other exceptions
      return UserResult(success: false, errorMessage: e.toString());
    }
  }

  Future<MyUser?> getUserByEmail(String email) async {
    Query usersQuery = usersCollection.where('email', isEqualTo: email);
    QuerySnapshot snapshot = await usersQuery.get();

    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      print(doc.data());

      final subcollectionRef = doc.reference.collection('userTopics');
      final subcollectionSnapshot = await subcollectionRef.get();

      final List<UserTopic> userTopics = subcollectionSnapshot.docs
          .map((doc) => UserTopic.fromMap(doc.data()! as Map<String, dynamic>))
          .toList();
      MyUser? myUser =
          MyUser.fromMap(snapshot.docs.first.data()! as Map<String, dynamic>);
      myUser.id = doc.id; //use document id
      myUser?.userTopics = userTopics;
      return myUser;
    } else {
      return null;
    }
  }

  Future<UserResult> userLogin(String email, String password) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        final DocumentReference userRef =
            firestore.collection("users").doc(firebaseUser.uid);
        final DocumentSnapshot userSnapshot = await userRef.get();

        if (userSnapshot.exists) {
          // final MyUser user = userSnapshot.data() as MyUser;
          MyUser user =
              MyUser.fromMap(userSnapshot.data() as Map<String, dynamic>);
          user.id = firebaseUser.uid;
          // Save login history
          // ... (Not yet implemented)
          return UserResult(success: true, user: user);
        } else {
          return UserResult(
              success: false, errorMessage: "User data not found");
        }
      } else {
        return UserResult(success: false, errorMessage: "User not found");
      }
    } on FirebaseAuthException catch (e) {
      return UserResult(
          success: false, errorMessage: "Login failed: ${e.message}");
    } catch (e) {
      return UserResult(
          success: false, errorMessage: "An error occurred: ${e.toString()}");
    }
  }

//not tested
  Future<PasswordResult> changePassword(String newPassword,) async {
    final User? user = firebaseAuth.currentUser;

    if (user != null) {
      try {
        await user.updatePassword(newPassword);
        return PasswordResult(success: true);
      } on FirebaseAuthException catch (e) {
        return PasswordResult(success: false, errorMessage: e.message);
      }
    } else {
      return PasswordResult(
          success: false, errorMessage: "User is not authenticated");
    }
  }

// //not tested
  Future<PasswordResult> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return PasswordResult(success: true);
    } on FirebaseAuthException catch (e) {
      return PasswordResult(success: false, errorMessage: e.message);
    }
  }

//   Future<void> addUser(MyUser user, String password, OnUserCreateListener listener) async {
//   try {
//     // Create a new user with email and password
//     UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
//       email: user.email,
//       password: password,
//     );

//     // Get the newly created user
//     User? firebaseUser = userCredential.user;

//     if (firebaseUser != null) {
//       // Create a document reference with the user's UID as the ID
//       DocumentReference userRef = usersCollection.doc(firebaseUser.uid);
//       user.id = firebaseUser.uid;
//       await userRef.set(user.toFirestore());

//       // Get the newly created user document
//       DocumentSnapshot documentSnapshot = await userRef.get();

//       if (documentSnapshot.exists) {
//         // Convert the document data back to a MyUser object
//         MyUser createdUser = MyUser.fromMap(documentSnapshot.data()! as Map<String, dynamic>);
//         // Notify listener about successful user creation
//         listener.onUserCreateSuccess(createdUser);
//       } else {
//         // Handle case where the document doesn't exist (unlikely)
//         // print("Error: User document not found after creation");
//         listener.onUserCreateFailure("User document not found");
//       }
//     } else {
//       // Handle failed user creation with Firebase Authentication
//       // print("Error: Failed to create user with Firebase Authentication");
//       listener.onUserCreateFailure("Failed to create user with Firebase Authentication");
//     }
//   } on FirebaseAuthException catch (e) {
//     listener.onUserCreateFailure(e.toString());
//   } catch (e) {
//     // Handle other exceptions
//     // print(e.toString());
//     listener.onUserCreateFailure(e.toString());
//   }
// }
}
