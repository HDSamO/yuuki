import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yuuki/listeners/on_topic_create_listener.dart';
import 'package:yuuki/listeners/on_topics_fetch_listener.dart';
import 'package:yuuki/listeners/on_user_topic_create_listener.dart';
import 'package:yuuki/models/folder.dart';
import 'package:yuuki/models/my_user.dart';
import 'package:yuuki/models/top_user.dart';
import 'package:yuuki/models/topic.dart';
import 'package:yuuki/models/user_topic.dart';
import 'package:yuuki/models/vocabulary.dart';
import 'package:yuuki/results/finish_study_result.dart';
import 'package:yuuki/results/save_top_user_result.dart';
import 'package:yuuki/results/start_study_result.dart';
import 'package:yuuki/results/top_user_result.dart';
import 'package:yuuki/results/topic_list_result.dart';
import 'package:yuuki/results/topic_result.dart';
import 'package:yuuki/results/user_topic_result.dart';
import 'package:yuuki/results/vocabulary_list_result.dart';

class TopicController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

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
        final Topic topic = Topic.fromMap(topicSnapshot.data()!
            as Map<String, dynamic>); // Safe cast after existence check

        final UserTopic userTopic = UserTopic.fromTopic(topic);
        userTopic.setView(1);
        userTopic.setLastOpen(DateTime.now().millisecondsSinceEpoch);

        final String userId =
            topic.getAuthor!; // Safe access after existence check

        final DocumentReference userRef =
            _firestore.collection("users").doc(userId);
        final CollectionReference createdTopicsCollection =
            userRef.collection("userTopics");

        await createdTopicsCollection.doc(topicId).set(userTopic.toFirestore());

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
        final Topic topic = Topic.fromMap(topicSnapshot.data()!
            as Map<String, dynamic>); // Safe cast after existence check

        final UserTopic userTopic = UserTopic.fromTopic(topic);
        userTopic.setView(1);
        userTopic.setLastOpen(DateTime.now().millisecondsSinceEpoch);

        final String? userId = user.id; // Assuming user.id holds the user ID

        final CollectionReference usersCollection =
            _firestore.collection("users");
        final DocumentReference userRef = usersCollection.doc(userId);
        final CollectionReference createdTopicsCollection =
            userRef.collection("userTopics");

        await createdTopicsCollection.doc(topicId).set(userTopic.toFirestore());

        return UserTopicResult(success: true, userTopic: userTopic);
      } else {
        return UserTopicResult(success: false, errorMessage: "Topic not found");
      }
    } on FirebaseException catch (e) {
      return UserTopicResult(success: false, errorMessage: e.message);
    }
  }

  Future<TopicListResult> getTopTopicsByViews() async {
    try {
      final CollectionReference topicsCollection =
          FirebaseFirestore.instance.collection("topics");
      final Query topTopicsQuery = topicsCollection
          .where("private", isEqualTo: false)
          .orderBy("views", descending: true);

      final QuerySnapshot querySnapshot = await topTopicsQuery.get();

      final List<Topic> topTopics = querySnapshot.docs
          .map((doc) => Topic.fromMap(doc.data()! as Map<String, dynamic>))
          .toList();

      return TopicListResult(success: true, topics: topTopics);
    } on FirebaseException catch (e) {
      return TopicListResult(
          success: false,
          errorMessage: e.message); // Re-throw as a generic Exception
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

        final List<UserTopic> userTopics = querySnapshot.docs.map((doc) {
          //arrow function WITHOUT the arrow is the only way
          UserTopic userTopic =
              UserTopic.fromMap(doc.data()! as Map<String, dynamic>);
          userTopic.setId(doc.id);
          return userTopic;
        } // Add the missing closing parenthesis here
            ).toList();

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
      final String topicId = topic.id; // Ensure topic ID is not null

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
        await topicRef.update(topic.toFirestore());

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
        final Topic topic =
            Topic.fromMap(topicSnapshot.data()! as Map<String, dynamic>);

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
        await userTopicRef.set(userTopic.toFirestore());

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
          UserTopic userTopic = UserTopic.fromMap(
              userTopicSnapshot.data()! as Map<String, dynamic>);

          // Fetch the latest topic document
          final DocumentSnapshot topicSnapshot = await FirebaseFirestore
              .instance
              .collection("topics")
              .doc(topicId)
              .get();

          if (topicSnapshot.exists) {
            final Topic updatedTopic =
                Topic.fromMap(topicSnapshot.data()! as Map<String, dynamic>);

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
            final Topic topic =
                Topic.fromMap(topicSnapshot.data()! as Map<String, dynamic>);
            final UserTopic newUserTopic = UserTopic.fromTopic(topic);
            newUserTopic.setView(1);
            newUserTopic.setLastOpen(DateTime.now().millisecondsSinceEpoch);

            await userTopicsCollection
                .doc(topicId)
                .set(newUserTopic.toFirestore());

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

  Future<TopicListResult> getPublishedTopics(MyUser user) async {
    try {
      final userId = user.id;

      final topicsCollection = FirebaseFirestore.instance.collection('topics');

      final topicsQuery = await topicsCollection
          .where('author', isEqualTo: userId)
          .where('private', isEqualTo: false)
          .get();

      final topics =
          topicsQuery.docs.map((doc) => Topic.fromMap(doc.data()!)).toList();
      return TopicListResult(success: true, topics: topics);
    } catch (e) {
      return TopicListResult(success: false, errorMessage: e.toString());
    }
  }

  Future<TopicListResult> getPrivateTopics(MyUser user) async {
    try {
      final userId = user.id;

      final topicsCollection = FirebaseFirestore.instance.collection('topics');

      final topicsQuery = await topicsCollection
          .where('author', isEqualTo: userId)
          .where('private', isEqualTo: true)
          .get();

      final topics =
          topicsQuery.docs.map((doc) => Topic.fromMap(doc.data()!)).toList();
      return TopicListResult(success: true, topics: topics);
    } catch (e) {
      return TopicListResult(success: false, errorMessage: e.toString());
    }
  }

  Future<void> updateAuthorName(MyUser user) async {
    try {
      final String? userId = user.id;
      final querySnapshot = await FirebaseFirestore.instance
          .collection("topics")
          .where("author", isEqualTo: userId)
          .get();

      final batch = FirebaseFirestore.instance.batch();
      for (final queryDocSnapshot in querySnapshot.docs) {
        final topicRef = queryDocSnapshot.reference;
        batch.update(topicRef, {"authorName": user.name});
      }

      await batch.commit();
      print("Author name updated for all topics by ${user.name}");
    } on FirebaseException catch (e) {
      print("Error updating author name: ${e.message}");
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
          final UserTopic userTopic = UserTopic.fromMap(
              userTopicSnapshot.data() as Map<String, dynamic>);
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

      final Folder folder =
          Folder.fromMap(folderSnapshot.data()! as Map<String, dynamic>);
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
        topics.addAll(documents
            .map((doc) => Topic.fromMap(doc.data()! as Map<String, dynamic>))
            .toList());
      }

      return topics;
    } on Exception catch (e) {
      print(
          "Error fetching topics: $e"); // Log for debugging (remove in production)
      return []; // Return empty list on error
    }
  }

  // Future<StartStudyResult> startStudyUserTopic(
  //     MyUser user, String topicId) async {
  //   try {
  //     final userId = user.id;
  //
  //     // Reference to the user's topic document
  //     final userTopicRef =
  //         usersCollection.doc(userId).collection("userTopics").doc(topicId);
  //
  //     // Update the "startTime" field with current timestamp
  //     await userTopicRef.update({"startTime": FieldValue.serverTimestamp()});
  //
  //     return StartStudyResult(success: true); // Return success result
  //   } on FirebaseException catch (e) {
  //     return StartStudyResult(
  //         success: false,
  //         errorMessage: e.message!); // Return failure result with error message
  //   } catch (e) {
  //     // Handle other exceptions (optional)
  //     return StartStudyResult(
  //         success: false,
  //         errorMessage: e.toString()); // Return generic failure result
  //   }
  // }

  Future<StartStudyResult> startStudyUserTopic(
      MyUser user, String topicId) async {
    try {
      final userId = user.id;

      // Reference to the user's topic document
      final userTopicRef =
          usersCollection.doc(userId).collection("userTopics").doc(topicId);

      final int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;

      // Update the "startTime" field with current timestamp
      await userTopicRef.update({"startTime": currentTimeMillis});

      return StartStudyResult(success: true); // Return success result
    } on FirebaseException catch (e) {
      return StartStudyResult(
          success: false,
          errorMessage: e.message!); // Return failure result with error message
    } catch (e) {
      // Handle other exceptions (optional)
      return StartStudyResult(
          success: false,
          errorMessage: e.toString()); // Return generic failure result
    }
  }

  Future<FinishStudyResult> finishStudyUserTopic(
      MyUser user, String topicId, double score) async {
    try {
      // Get a reference to the users collection
      final usersCollection = FirebaseFirestore.instance.collection("users");

      final userId = user.id;

      // Reference to the user's topic document
      final userTopicRef =
          usersCollection.doc(userId).collection("userTopics").doc(topicId);

      // Get the user topic document
      final docSnapshot = await userTopicRef.get();

      if (!docSnapshot.exists) {
        return FinishStudyResult(
            success: false, errorMessage: "User topic document not found");
      }

      // Get the UserTopic data
      final userTopic =
          UserTopic.fromMap(docSnapshot.data()! as Map<String, dynamic>);

      // Calculate end time and last time
      // final endTime = FieldValue.serverTimestamp(); // Use server timestamp
      // final longStartTime = (userTopic.startTime as int?)?.millisecondsSinceEpoch ?? 0; // Handle potential null startTime
      // final longEndTime = endTime.millisecondsSinceEpoch;
      // final longLastTime = longEndTime - longStartTime;
      final startTime = userTopic.startTime; // Assuming startTime is an int
      // final currentTime =
      final endTime =
          DateTime.now().millisecondsSinceEpoch; // Use server timestamp
      final longLastTime = endTime - (startTime ?? 0);

      // Prepare updates for the user topic document
      final updates = {
        "endTime": endTime,
        "lastTime": longLastTime,
      };

      // Update the user topic document
      await userTopicRef.update(updates);

      updateBestTimeAndScore(userTopicRef, score);

      return FinishStudyResult(success: true);
    } on FirebaseException catch (e) {
      return FinishStudyResult(success: false, errorMessage: e.message!);
    } catch (e) {
      // Handle other exceptions (optional)
      return FinishStudyResult(success: false, errorMessage: e.toString());
    }
  }

  Future<void> updateBestTimeAndScore(
      DocumentReference userTopicRef, double score) async {
    try {
      // Get the user topic document
      final docSnapshot = await userTopicRef.get();

      if (!docSnapshot.exists) {
        return; // User topic document not found
      }

      // Get the UserTopic data
      final userTopic =
          UserTopic.fromMap(docSnapshot.data()! as Map<String, dynamic>);

      if (userTopic == null) {
        return; // UserTopic object is null
      }

      final longLastTime = userTopic.lastTime;
      final longBestTime = userTopic.bestTime;
      final double lastScore = userTopic.lastScore;
      final double bestScore = userTopic.bestScore;

      // Update best time if needed
      final updates = <String, dynamic>{};
      if (longLastTime < longBestTime || longBestTime == 0) {
        updates["bestTime"] = longLastTime;
      }

      // Update best score if needed
      if (lastScore > bestScore) {
        updates["bestScore"] = lastScore;
      }

      // Update last score
      updates["lastScore"] = score;

      // Update the user topic document (if any updates)
      if (updates.isNotEmpty) {
        await userTopicRef.update(updates);
      }
    } catch (e) {
      // Handle errors (optional, you can log the error)
      print("Error updating best time and score: $e");
    }
  }

  Future<TopUserResult> getTopScorers(String topicId) async {
    try {
      // Reference the top scorers collection
      final topScorersRef = FirebaseFirestore.instance
          .collection('topics')
          .doc(topicId)
          .collection('topScorers');

      // Query top scorers with sorting and limit
      final querySnapshot = await topScorersRef
          .orderBy('score', descending: true)
          .orderBy('rawTime', descending: false)
          .limit(10)
          .get();

      // Extract top user data
      final topScorers = querySnapshot.docs
          .map((doc) => TopUser.fromMap(doc.data()! as Map<String, dynamic>))
          .toList();

      // Return successful result
      return TopUserResult(success: true, topScorers: topScorers);
    } catch (e) {
      // Handle errors
      print("Error fetching top scorers: $e");
      return TopUserResult(success: false, errorMessage: e.toString());
    }
  }

  Future<TopUserResult> getTopViewers(String topicId) async {
    try {
      // Reference the top viewers collection
      final topViewersRef = FirebaseFirestore.instance
          .collection('topics')
          .doc(topicId)
          .collection('topViewers');

      // Query top viewers with sorting and limit
      final querySnapshot = await topViewersRef
          .orderBy('viewCount', descending: true)
          .limit(10)
          .get();

      // Extract top user data
      final topViewers = querySnapshot.docs
          .map((doc) => TopUser.fromMap(doc.data()! as Map<String, dynamic>))
          .toList();

      // Return successful result
      return TopUserResult(success: true, topScorers: topViewers);
    } catch (e) {
      // Handle errors
      print("Error fetching top viewers: $e");
      return TopUserResult(success: false, errorMessage: e.toString());
    }
  }

  Future<SaveTopUserResult> saveUserIfTopScorer(String topicId, MyUser user,
      double score, int rawTime, int viewCount) async {
    try {
      // Create a TopUser object
      final topUser = TopUser(
        name: user.name, // Assuming getName() exists in User
        birthday: user.birthday, // Assuming methods exist in User
        email: user.email,
        phone: user.phone, // Assuming methods exist in User
        score: score,
        rawTime: rawTime,
        viewCount: viewCount,
      );

      // Reference the top scorers collection
      final topScorersRef = FirebaseFirestore.instance
          .collection('topics')
          .doc(topicId)
          .collection('topScorers');

      // Check if user already exists in top scorers
      final existingDoc = await topScorersRef
          .where('email', isEqualTo: user.email)
          .get()
          .then(
              (snapshot) => snapshot.docs.isEmpty ? null : snapshot.docs.first);

      if (existingDoc == null) {
        // User not found, check if score qualifies for top 10
        final querySnapshot = await topScorersRef
            .orderBy('score', descending: true)
            .limit(10)
            .get();

        final lastDocScore = querySnapshot.docs.isEmpty
            ? 0
            : querySnapshot.docs.last.data()['score'];

        final shouldAddUser = querySnapshot.docs.isEmpty ||
            score > lastDocScore ||
            (score == lastDocScore &&
                rawTime < querySnapshot.docs.last.data()['rawTime']);

        if (shouldAddUser) {
          // Add user as a new top scorer
          await topScorersRef.add(topUser.toFirestore());
          return SaveTopUserResult(success: true);
        } else {
          return SaveTopUserResult(
              success: false, errorMessage: "Not top scorers");
        }
      } else {
        // User exists, update if score qualifies
        final existingTopUser = TopUser.fromMap(existingDoc.data()!);
        if (score > existingTopUser.score ||
            (score == existingTopUser.score &&
                rawTime < existingTopUser.rawTime)) {
          await existingDoc.reference.update({
            'score': score,
            'rawTime': rawTime,
            'viewCount': viewCount,
          });
          return SaveTopUserResult(success: true);
        } else {
          return SaveTopUserResult(
              success: false, errorMessage: "Not top scorers");
        }
      }
    } catch (e) {
      print("Error saving top scorer: $e");
      return SaveTopUserResult(success: false, errorMessage: e.toString());
    }
  }

  Future<SaveTopUserResult> saveUserIfTopViewer(String topicId, MyUser user,
      double score, int rawTime, int viewCount) async {
    try {
      // Create a TopUser object
      final topUser = TopUser(
        name: user.name, // Assuming methods exist in User
        birthday: user.birthday, // Assuming methods exist in User
        email: user.email,
        phone: user.phone, // Assuming methods exist in User
        viewCount: viewCount,
        rawTime: rawTime,
        score: score,
      );

      // Reference the top viewers collection
      final topViewersRef = FirebaseFirestore.instance
          .collection('topics')
          .doc(topicId)
          .collection('topViewers');

      // Check if user already exists in top viewers
      final existingDoc = await topViewersRef
          .where('email', isEqualTo: user.email)
          .get()
          .then(
              (snapshot) => snapshot.docs.isEmpty ? null : snapshot.docs.first);

      if (existingDoc == null) {
        // User not found, check if viewCount qualifies for top 10
        final querySnapshot = await topViewersRef
            .orderBy('viewCount', descending: true)
            .limit(10)
            .get();

        final shouldAddUser = querySnapshot.docs.isEmpty ||
            viewCount > querySnapshot.docs.last.data()['viewCount'];

        if (shouldAddUser) {
          // Add user as a new top viewer
          await topViewersRef.add(topUser.toFirestore());
          return SaveTopUserResult(success: true);
        } else {
          return SaveTopUserResult(
              success: false, errorMessage: "Not a top viewer");
        }
      } else {
        // User exists, update if viewCount qualifies
        final existingTopUser = TopUser.fromMap(existingDoc.data()!);
        if (viewCount > existingTopUser.viewCount) {
          await existingDoc.reference.update({
            'viewCount': viewCount,
            'score': score, // Assuming score is also relevant for top viewers
            'rawTime':
                rawTime, // Assuming rawTime is also relevant for top viewers
          });
          return SaveTopUserResult(success: true);
        } else {
          return SaveTopUserResult(
              success: false, errorMessage: "Not a top viewer");
        }
      }
    } catch (e) {
      print("Error saving top viewer: $e");
      return SaveTopUserResult(success: false, errorMessage: e.toString());
    }
  }

  Future<VocabularyListResult> starVocabularyInUserTopic(MyUser user,
      String topicId, Vocabulary vocabulary, bool isStarred) async {
    try {
      final userId = user.id;

      final userTopicsRef =
          usersCollection.doc(userId).collection('userTopics');
      final topicRef = userTopicsRef.doc(topicId);

      final topicSnapshot = await topicRef.get();

      if (!topicSnapshot.exists) {
        // UserTopic document not found
        return VocabularyListResult(
            success: false, errorMessage: "UserTopic not found");
      }

      final userTopic =
          UserTopic.fromMap(topicSnapshot.data()! as Map<String, dynamic>);

      final vocabList = userTopic.vocabularies;
      if (vocabList == null) {
        // Vocabulary list is null (unlikely scenario)
        return VocabularyListResult(
            success: false, errorMessage: "Vocabulary list is null");
      }

      // final existingVocab = vocabList.firstWhere((vocab) => vocab.term == vocabulary.term, orElse: () => null);
      final existingVocab =
          vocabList.firstWhere((vocab) => vocab.term == vocabulary.term);

      if (existingVocab != null) {
        existingVocab.stared = isStarred;
      } else {
        // Vocabulary not found in userTopic
        return VocabularyListResult(
            success: false,
            errorMessage: "Vocabulary not found in the userTopic");
      }

      userTopic.vocabularies =
          vocabList; // Update the vocabulary list in userTopic

      await topicRef
          .set(userTopic.toFirestore()); // Update the userTopic document

      if (isStarred) {
        if (user.starredTopic == null) {
          user.starredTopic = UserTopic(
            id: 'starredTopic',
            title: 'Starred Topic',
            author: user.id,
            authorName: user.name,
            description: 'Starred Topic',
            private: true,
            vocabularies: [],
            lastOpen: 0,
            startTime: 0,
            endTime: 0,
            lastTime: 0,
            bestTime: 0,
            lastScore: 0.0,
            bestScore: 0.0,
            view: 0,
          ); // Initialize with an empty list
        }

        user.starredTopic!.vocabularies!.add(vocabulary);
      } else {
        user.starredTopic?.vocabularies
            ?.removeWhere((vocab) => vocab.term == vocabulary.term);
      }

      final userUpdate = {
        'starredTopic': user.starredTopic?.toFirestore(),
      };
      await usersCollection.doc(userId).update(userUpdate);

      // await usersCollection.doc(userId).set(user.toFirestore()); // Update the user document

      return VocabularyListResult(success: true);
    } catch (e) {
      return VocabularyListResult(success: false, errorMessage: e.toString());
    }
  }

  Future<VocabularyListResult> getStarredVocabulariesInUserTopic(
      MyUser user, String topicId) async {
    try {
      final userId = user.id;

      final userTopicsRef =
          usersCollection.doc(userId).collection('userTopics');
      final topicRef = userTopicsRef.doc(topicId);

      final topicSnapshot = await topicRef.get();

      if (!topicSnapshot.exists) {
        // UserTopic document not found
        return VocabularyListResult(
            success: false, errorMessage: "UserTopic not found");
      }

      final userTopic =
          UserTopic.fromMap(topicSnapshot.data()! as Map<String, dynamic>);
      final vocabList = userTopic.vocabularies;

      if (vocabList == null) {
        // Vocabulary list is null (unlikely scenario)
        return VocabularyListResult(
            success: false, errorMessage: "Vocabulary list is null");
      }

      final starredVocabularies =
          vocabList.where((vocab) => vocab.stared).toList();

      return VocabularyListResult(
          success: true, vocabularies: starredVocabularies);
    } catch (e) {
      return VocabularyListResult(success: false, errorMessage: e.toString());
    }
  }

// Future<VocabularyListResult> starVocabularyInUserTopic(MyUser user, String topicId, Vocabulary vocabulary) async {
//   try {
//     final userCollection = FirebaseFirestore.instance.collection('users');
//     final userEmail = user.email;

//     final userSnapshot = await userCollection.where('email', isEqualTo:  userEmail).get();

//     if (userSnapshot.docs.isEmpty) {
//       // User not found
//       return VocabularyListResult(success: false, errorMessage: "User not found");
//     }

//     final userDoc = userSnapshot.docs.first;
//     final userId = userDoc.id;

//     final userTopicsRef = userCollection.doc(userId).collection('userTopics');
//     final topicRef = userTopicsRef.doc(topicId);

//     final topicSnapshot = await topicRef.get();

//     if (!topicSnapshot.exists) {
//       // UserTopic document not found
//       return VocabularyListResult(success: false, errorMessage: "UserTopic not found");
//     }

//     final userTopic = UserTopic.fromMap(topicSnapshot.data()! as Map<String, dynamic>);

//     final vocabList = userTopic.vocabularies;
//     if (vocabList == null) {
//       // Vocabulary list is null (unlikely scenario)
//       return VocabularyListResult(success: false, errorMessage: "Vocabulary list is null");
//     }

//     final existingVocab = vocabList.firstWhere((vocab) => vocab.term == vocabulary.term, orElse: () => null);

//     if (existingVocab != null) {
//       existingVocab.stared = !existingVocab.stared; // Invert the starred value
//     } else {
//       // Vocabulary not found in userTopic
//       return VocabularyListResult(success: false, errorMessage: "Vocabulary not found in the userTopic");
//     }

//     userTopic.vocabularies = vocabList; // Update the vocabulary list in userTopic

//     await topicRef.set(userTopic.toFirestore()); // Update the userTopic document

//     // Update starredTopic in user object (if applicable)
//     if (user.starredTopic?.term == vocabulary.term) {
//       user.starredTopic?.starred = !user.starredTopic?.starred;
//     }

//     await userCollection.doc(userId).set(user.toMap()); // Update the user document

//     return VocabularyListResult(success: true);
//   } catch (e) {
//     return VocabularyListResult(success: false, errorMessage: e.toString());
//   }
// }
}
