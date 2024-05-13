import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yuuki/listeners/on_topic_create_listener.dart';
import 'package:yuuki/listeners/on_topics_fetch_listener.dart';
import 'package:yuuki/listeners/on_user_topic_create_listener.dart';
import 'package:yuuki/models/folder.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/models/topic.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/results/topic_list_result.dart';
import 'package:yuuki/results/topic_result.dart';
import 'package:yuuki/results/user_topic_result.dart';

class TopicController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<TopicResult> addTopic(MyUser user, Topic topic) async {
    try {
      final DocumentReference userRef =
          _firestore.collection("users").doc(user.id);
      final DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        topic.setLastModify(DateTime.now().millisecondsSinceEpoch);
        topic.setViews(0);
        topic.authorName = (userSnapshot.get('name') as String);
        topic.setAuthor(user.id); // Use user.id instead of author

        final DocumentReference topicRef =
            await _firestore.collection("topics").add(topic.toFirestore());
        final String topicId = topicRef.id;
        topic.setId(topicId);

        await topicRef
            .update({'id': topicId}); // Update topic with generated ID

        return TopicResult(success: true, topic: topic);
      } else {
        return TopicResult(success: false, errorMessage: "User not found");
      }
    } on FirebaseException catch (e) {
      return TopicResult(success: false, errorMessage: e.message);
    }
  }

  Future<UserTopicResult> addTopicToAuthor(String topicId) async {
    try {
      final DocumentReference topicRef =
          _firestore.collection("topics").doc(topicId);
      final DocumentSnapshot topicSnapshot = await topicRef.get();

      if (topicSnapshot.exists) {
        final Topic topic =
            topicSnapshot.data()! as Topic; // Safe cast after existence check

        final UserTopic userTopic = UserTopic.fromTopic(topic);
        userTopic.setView(1);
        userTopic.setLastOpen(DateTime.now().millisecondsSinceEpoch);

        final String userId =
            topic.getAuthor!; // Safe access after existence check

        final DocumentReference userRef =
            _firestore.collection("users").doc(userId);
        final CollectionReference createdTopicsCollection =
            userRef.collection("userTopics");

        await createdTopicsCollection.doc(topicId).set(userTopic);

        return UserTopicResult(success: true, userTopic: userTopic);
      } else {
        return UserTopicResult(success: false, errorMessage: "Topic not found");
      }
    } on FirebaseException catch (e) {
      return UserTopicResult(success: false, errorMessage: e.message);
    }
  }

  Future<UserTopicResult> addTopicToUser(String topicId, MyUser user) async {
    try {
      final DocumentReference topicRef =
          _firestore.collection("topics").doc(topicId);
      final DocumentSnapshot topicSnapshot = await topicRef.get();

      if (topicSnapshot.exists) {
        final Topic topic =
            topicSnapshot.data()! as Topic; // Safe cast after existence check

        final UserTopic userTopic = UserTopic.fromTopic(topic);
        userTopic.setView(1);
        userTopic.setLastOpen(DateTime.now().millisecondsSinceEpoch);

        final String? userId = user.id; // Assuming user.id holds the user ID

        final CollectionReference usersCollection =
            _firestore.collection("users");
        final DocumentReference userRef = usersCollection.doc(userId);
        final CollectionReference createdTopicsCollection =
            userRef.collection("userTopics");

        await createdTopicsCollection.doc(topicId).set(userTopic);

        return UserTopicResult(success: true, userTopic: userTopic);
      } else {
        return UserTopicResult(success: false, errorMessage: "Topic not found");
      }
    } on FirebaseException catch (e) {
      return UserTopicResult(success: false, errorMessage: e.message);
    }
  }

  Future<List<Topic>> getTopTopicsByViews() async {
    try {
      final CollectionReference topicsCollection =
          _firestore.collection("topics");
      final Query topTopicsQuery = topicsCollection
          .where("private", isEqualTo: "false")
          .orderBy("views", descending: true)
          .limit(10);

      final QuerySnapshot querySnapshot = await topTopicsQuery.get();

      final List<Topic> topTopics =
          querySnapshot.docs.map((doc) => doc.data()! as Topic).toList();
      return topTopics;
    } on FirebaseException catch (e) {
      throw Exception(
          "Error fetching top topics: ${e.message}"); // Re-throw as a generic Exception
    }
  }

  // Future<List<Topic>> getRandomTopics() async {
  //   try {
  //     final CollectionReference topicsCollection = FirebaseFirestore.instance.collection("topics");
  //     final Query randomTopicsQuery = topicsCollection
  //         .where("private", isEqualTo: false) // Filter out private topics
  //         .orderBy("lastModify", descending: true) // Order by last modified date (descending)
  //         .limit(10); // Fetch a maximum of 10 topics

  //     final QuerySnapshot querySnapshot = await randomTopicsQuery.get();

  //     final List<Topic> topics = querySnapshot.docs
  //         .map((doc) => Topic.fromMap(doc.data()! as Map<String, dynamic>))
  //         .toList();

  //     return topics;
  //   } on FirebaseException catch (e) {
  //     throw Exception("Error fetching random topics: ${e.message}"); // Re-throw as a generic Exception
  //   }
  // }

  Future<TopicListResult> getRandomTopics() async {
    try {
      final CollectionReference topicsCollection =
          FirebaseFirestore.instance.collection("topics");
      final Query randomTopicsQuery = topicsCollection
          .where("private", isEqualTo: false) // Filter out private topics
          .orderBy("lastModify",
              descending: true) // Order by last modified date (descending)
          .limit(10); // Fetch a maximum of 10 topics

      final QuerySnapshot querySnapshot = await randomTopicsQuery.get();

      final List<Topic> topics = querySnapshot.docs
          .map((doc) => Topic.fromMap(doc.data()! as Map<String, dynamic>))
          .toList();

      return TopicListResult(success: true, topics: topics);
    } on FirebaseException catch (e) {
      throw Exception(
          "Error fetching random topics: ${e.message}"); // Re-throw as a generic Exception
    }
  }

  Future<List<UserTopic>> getRecentTopics(MyUser user) async {
    try {
      final String? userId = user.id; // Use the user ID from MyUser object

      final DocumentReference userRef =
          FirebaseFirestore.instance.collection("users").doc(userId);
      final DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        final CollectionReference userTopicsCollection =
            userRef.collection("userTopics");
        final Query recentTopicsQuery = userTopicsCollection.orderBy("lastOpen",
            descending: true); // Order by lastOpen in descending order

        final QuerySnapshot querySnapshot = await recentTopicsQuery.get();
        final List<UserTopic> userTopics = querySnapshot.docs
            .map((doc) { //arrow function WITHOUT the arrow is the only way
                  UserTopic userTopic = UserTopic.fromMap(doc.data()! as Map<String, dynamic>);
                  userTopic.setId(doc.id);
                  return userTopic;
                } // Add the missing closing parenthesis here
            )
            .toList();

        return userTopics;
      } else {
        throw Exception("User not found"); // Re-throw as a generic Exception
      }
    } on FirebaseException catch (e) {
      throw Exception(
          "Error fetching recent topics: ${e.message}"); // Re-throw as a generic Exception
    }
  }

  Future<Topic?> getTopicById(String topicId) async {
    try {
      final DocumentReference topicRef =
          FirebaseFirestore.instance.collection("topics").doc(topicId);
      final DocumentSnapshot documentSnapshot = await topicRef.get();

      if (documentSnapshot.exists) {
        final Topic topic = documentSnapshot.data()! as Topic;
        return topic;
      } else {
        return null; // Indicate topic not found
      }
    } on FirebaseException catch (e) {
      throw Exception(
          "Error fetching topic: ${e.message}"); // Re-throw as a generic Exception
    }
  }

  Future<TopicResult> updateTopic(Topic topic, MyUser user) async {
    try {
      final String topicId = topic.getId!; // Ensure topic ID is not null

      final DocumentReference userRef =
          FirebaseFirestore.instance.collection("users").doc(user.id);
      final DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        if (userSnapshot.id != topic.getAuthor) {
          return TopicResult(
              success: false,
              errorMessage: "User is not authorized to update the topic");
        }

        final DocumentReference topicRef =
            FirebaseFirestore.instance.collection("topics").doc(topicId);
        await topicRef.set(topic);

        return TopicResult(
            success: true, topic: topic); // Topic updated successfully
      } else {
        return TopicResult(success: false, errorMessage: "User not found");
      }
    } on FirebaseException catch (e) {
      return TopicResult(
          success: false,
          errorMessage:
              "Error updating topic: ${e.message}"); // Re-throw as a generic Exception
    }
  }

  Future<TopicResult> updateTopicOfUser(String topicId) async {
    try {
      final DocumentReference topicRef =
          FirebaseFirestore.instance.collection("topics").doc(topicId);
      final DocumentSnapshot topicSnapshot = await topicRef.get();

      if (topicSnapshot.exists) {
        final Topic topic = topicSnapshot.data()! as Topic;

        final String userId = topic.getAuthor!;
        final DocumentReference userRef =
            FirebaseFirestore.instance.collection("users").doc(userId);
        final CollectionReference createdTopicsCollection =
            userRef.collection("userTopics");

        final UserTopic userTopic = UserTopic.fromTopic(topic);
        userTopic.setLastOpen(
            DateTime.now().millisecondsSinceEpoch); // Update lastOpen

        final DocumentReference userTopicRef =
            createdTopicsCollection.doc(topicId);
        await userTopicRef.set(userTopic);

        return TopicResult(
            success: true, topic: topic); // Topic updated successfully
      } else {
        return TopicResult(success: false, errorMessage: "Topic not found");
      }
    } on FirebaseException catch (e) {
      return TopicResult(
          success: false,
          errorMessage:
              "Error updating topic: ${e.message}"); // Re-throw as a generic Exception
    }
  }

  //don't use this
  // Future<void> deleteTopicById(String topicId) async {
  //   try {
  //     final DocumentReference topicRef = FirebaseFirestore.instance.collection("topics").doc(topicId);
  //     await topicRef.delete();
  //     // Topic deleted successfully
  //   } on FirebaseException catch (e) {
  //     throw Exception("Error deleting topic: ${e.message}"); // Re-throw as a generic Exception
  //   }
  // }

  Future<TopicResult> deleteTopicById(MyUser user, String topicId) async {
    try {
      final DocumentReference userRef = FirebaseFirestore.instance
          .collection("users")
          .doc(user.id); // Use user.id directly
      final DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        final DocumentReference topicRef =
            FirebaseFirestore.instance.collection("topics").doc(topicId);
        final DocumentSnapshot topicSnapshot = await topicRef.get();

        if (topicSnapshot.exists) {
          final String authorId = topicSnapshot.get("author") as String;
          if (authorId == user.id) {
            // Check against user ID
            await topicRef.delete();
            return TopicResult(success: true); // Topic deleted successfully
          } else {
            return TopicResult(
                success: false,
                errorMessage:
                    "User does not have permission to delete the topic");
          }
        } else {
          return TopicResult(success: false, errorMessage: "Topic not found");
        }
      } else {
        return TopicResult(success: false, errorMessage: "User not found");
      }
    } on FirebaseException catch (e) {
      return TopicResult(
          success: false,
          errorMessage:
              "Error deleting topic: ${e.message}"); // Handle Firebase errors
    }
  }

  Future<UserTopicResult> deleteUserTopicById(
      MyUser user, String userTopicId) async {
    try {
      final DocumentReference userRef = FirebaseFirestore.instance
          .collection("users")
          .doc(user.id); // Use user.id directly
      final DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        final DocumentReference userTopicRef =
            userRef.collection("userTopics").doc(userTopicId);
        await userTopicRef.delete();
        return UserTopicResult(
            success: true); // User topic deleted successfully
      } else {
        return UserTopicResult(success: false, errorMessage: "User not found");
      }
    } on FirebaseException catch (e) {
      return UserTopicResult(
          success: false,
          errorMessage:
              "Error deleting user topic: ${e.message}"); // Handle Firebase errors
    }
  }

  // Future<UserTopicResult> viewTopic(User user, String topicId) async {
  //   try {
  //     final DocumentReference userRef = FirebaseFirestore.instance.collection("users").doc(user.id); // Use user.id directly
  //     final DocumentSnapshot userSnapshot = await userRef.get();

  //     if (userSnapshot.exists) {
  //       final DocumentReference userTopicRef = userRef.collection("userTopics").doc(topicId);
  //       final DocumentSnapshot userTopicSnapshot = await userTopicRef.get();

  //       if (userTopicSnapshot.exists) {
  //         final UserTopic userTopic = userTopicSnapshot.data()! as UserTopic;

  //         // Update view count and last open in userTopic document
  //         userTopic.incrementView();
  //         userTopic.setLastOpen(DateTime.now().millisecondsSinceEpoch);
  //         await userTopicRef.update({
  //           'view': userTopic.view,
  //           'lastOpen': userTopic.lastOpen,
  //         });

  //         // Update view count in the topic document
  //         await FirebaseFirestore.instance.collection("topics").doc(topicId).update({
  //           'views': FieldValue.increment(1),
  //         });

  //         return UserTopicResult(success: true, userTopic: userTopic);
  //       } else {
  //         // UserTopic document doesn't exist, create a new one
  //         final DocumentSnapshot topicSnapshot = await FirebaseFirestore.instance.collection("topics").doc(topicId).get();

  //         if (topicSnapshot.exists) {
  //           final Topic topic = topicSnapshot.data()! as Topic;
  //           final UserTopic newUserTopic = UserTopic(topic);
  //           newUserTopic.setView(1);
  //           newUserTopic.setLastOpen(DateTime.now().millisecondsSinceEpoch);

  //           await userTopicsCollection.doc(topicId).set(newUserTopic);

  //           // Update view count in the topic document (same as before)
  //           await FirebaseFirestore.instance.collection("topics").doc(topicId).update({
  //             'views': FieldValue.increment(1),
  //           });

  //           return UserTopicResult(success: true, userTopic: newUserTopic);
  //         } else {
  //           return UserTopicResult(success: false, errorMessage: "Topic not found");
  //         }
  //       }
  //     } else {
  //       return UserTopicResult(success: false, errorMessage: "User not found");
  //     }
  //   } on FirebaseException catch (e) {
  //     return UserTopicResult(success: false, errorMessage: "Error viewing topic: ${e.message}"); // Handle Firebase errors
  //   }
  // }

  Future<UserTopicResult> viewTopic(MyUser user, String topicId) async {
    try {
      final DocumentReference userRef = FirebaseFirestore.instance
          .collection("users")
          .doc(user.id); // Use user.id directly
      final DocumentSnapshot userSnapshot = await userRef.get();
      CollectionReference userTopicsCollection =
          userRef.collection("userTopics");
      if (userSnapshot.exists) {
        final DocumentReference userTopicRef =
            userRef.collection("userTopics").doc(topicId);
        final DocumentSnapshot userTopicSnapshot = await userTopicRef.get();

        if (userTopicSnapshot.exists) {
          UserTopic userTopic = userTopicSnapshot.data()! as UserTopic;

          // Fetch the latest topic document
          final DocumentSnapshot topicSnapshot = await FirebaseFirestore
              .instance
              .collection("topics")
              .doc(topicId)
              .get();

          if (topicSnapshot.exists) {
            final Topic updatedTopic = topicSnapshot.data()! as Topic;

            // Check if userTopic data needs to be updated based on Topic changes
            bool updateRequired = false;
            // Customize this logic based on your specific fields of interest
            if (userTopic.lastOpen != updatedTopic.lastModify) {
              updateRequired = true;
            }

            if (updateRequired) {
              // Update userTopic with latest data
              userTopic = UserTopic.fromTopic(
                  updatedTopic); // Implement updateFromTopic method
              await userTopicRef
                  .update(userTopic.toFirestore() // Update userTopic document
                      // ..remove('view')
                      // ..remove('lastOpen')
                      );
            }

            // Update view count and last open in userTopic document
            userTopic.incrementView();
            userTopic.setLastOpen(DateTime.now().millisecondsSinceEpoch);
            await userTopicRef.update({
              'view': userTopic.view,
              'lastOpen': userTopic.lastOpen,
            });

            // Update view count in the topic document (same as before)
            await FirebaseFirestore.instance
                .collection("topics")
                .doc(topicId)
                .update({
              'views': FieldValue.increment(1),
            });

            return UserTopicResult(success: true, userTopic: userTopic);
          } else {
            return UserTopicResult(
                success: false, errorMessage: "Topic not found");
          }
        } else {
          // UserTopic document doesn't exist, create a new one
          final DocumentSnapshot topicSnapshot = await FirebaseFirestore
              .instance
              .collection("topics")
              .doc(topicId)
              .get();

          if (topicSnapshot.exists) {
            final Topic topic = topicSnapshot.data()! as Topic;
            final UserTopic newUserTopic = UserTopic.fromTopic(topic);
            newUserTopic.setView(1);
            newUserTopic.setLastOpen(DateTime.now().millisecondsSinceEpoch);

            await userTopicsCollection.doc(topicId).set(newUserTopic);

            // Update view count in the topic document (same as before)
            await FirebaseFirestore.instance
                .collection("topics")
                .doc(topicId)
                .update({
              'views': FieldValue.increment(1),
            });

            return UserTopicResult(success: true, userTopic: newUserTopic);
          } else {
            return UserTopicResult(
                success: false, errorMessage: "Topic not found");
          }
        }
      } else {
        return UserTopicResult(success: false, errorMessage: "User not found");
      }
    } on FirebaseException catch (e) {
      return UserTopicResult(
          success: false,
          errorMessage:
              "Error viewing topic: ${e.message}"); // Handle Firebase errors
    }
  }

  Future<UserTopic?> getUserTopicforUser(MyUser user, String topicId) async {
    try {
      final DocumentReference userRef = FirebaseFirestore.instance
          .collection("users")
          .doc(user.id); // Use user.id directly

      final DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        final DocumentReference userTopicRef =
            userRef.collection("userTopics").doc(topicId);
        final DocumentSnapshot userTopicSnapshot = await userTopicRef.get();

        if (userTopicSnapshot.exists) {
          final UserTopic userTopic = userTopicSnapshot.data()! as UserTopic;
          return userTopic;
        } else {
          return null; // User topic not found
        }
      } else {
        return null; // User not found
      }
    } on FirebaseException catch (e) {
      print("Error getting user topic: ${e.message}");
      return null; // Handle errors in UI
    }
  }

  Future<List<Topic>> fetchTopicsNotInFolder(
      MyUser user, String folderId) async {
    try {
      final String userId = user.id as String; // Use unique ID from MyUser

      final CollectionReference topicsCollection =
          FirebaseFirestore.instance.collection("topics");
      final DocumentReference folderDocRef = FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("folders")
          .doc(folderId);

      final DocumentSnapshot folderSnapshot = await folderDocRef.get();
      if (!folderSnapshot.exists) {
        throw Exception("Folder document not found");
      }

      final Folder folder = folderSnapshot.data()! as Folder;
      final List<String> topicIdsInFolder =
          folder.topics?.map((userTopic) => userTopic.id).toList() ?? [];

      Query publicTopicsQuery =
          topicsCollection.where("private", isEqualTo: false);
      Query privateTopicsQuery = topicsCollection
          .where("private", isEqualTo: true)
          .where("author", isEqualTo: userId);

      if (topicIdsInFolder.isNotEmpty) {
        publicTopicsQuery = publicTopicsQuery
            .where("id", whereNotIn: topicIdsInFolder)
            .limit(15);
        privateTopicsQuery = privateTopicsQuery
            .where("id", whereNotIn: topicIdsInFolder)
            .limit(10);
      } else {
        publicTopicsQuery = publicTopicsQuery.limit(15);
        privateTopicsQuery = privateTopicsQuery.limit(10);
      }

      final List<Future<QuerySnapshot>> queries = [
        publicTopicsQuery.get(),
        privateTopicsQuery.get()
      ];
      final List<QuerySnapshot> snapshots = await Future.wait(queries);

      final List<Topic> topics = [];
      for (final QuerySnapshot snapshot in snapshots) {
        final List<DocumentSnapshot> documents = snapshot.docs;
        topics.addAll(documents.map((doc) => doc.data()! as Topic).toList());
      }

      return topics;
    } on Exception catch (e) {
      print(
          "Error fetching topics: $e"); // Log for debugging (remove in production)
      return []; // Return empty list on error
    }
  }
}
