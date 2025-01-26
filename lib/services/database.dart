import 'package:tamazotchi/models/user.dart';
import 'package:tamazotchi/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid = ''});
  String filter = '';

  // collection references

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  // Users

  Future<void> updateUserData({
    required String name,
    required String email,
    required int points,
    required String tamagotchi,
    required bool isCompany,
    required String friendId,
    int percentCarbonEmissionsReduced = 0,
    int percentSustainableMaterials = 0,
    int numGreenPartnerships = 0,
    int energyCostSavings = 0,
    int employeeVolunteerHours = 0,
    int miles = 0,
    int itemsRecycledOrComposted = 0,
    int numEcoFriendlyItems = 0,
    int ounces = 0,
    int hoursVolunteered = 0,
    List<String>? posts,
    List<String>? likedPosts,
    List<String>? reportedPosts,
    List<String>? friends,
    List<String>? sentRequests,
    List<String>? receivedRequests,
  }) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'points': points,
      'tamagotchi': tamagotchi,
      'isCompany': isCompany,
      'friendId': friendId,
      'percentCarbonEmissionsReduced': percentCarbonEmissionsReduced,
      'percentSustainableMaterials': percentSustainableMaterials,
      'numGreenPartnerships': numGreenPartnerships,
      'energyCostSavings': energyCostSavings,
      'employeeVolunteerHours': employeeVolunteerHours,
      'miles': miles,
      'itemsRecycledOrComposted': itemsRecycledOrComposted,
      'numEcoFriendlyItems': numEcoFriendlyItems,
      'ounces': ounces,
      'hoursVolunteered': hoursVolunteered,
      'posts': posts ?? [],
      'likedPosts': likedPosts ?? [],
      'reportedPosts': reportedPosts ?? [],
      'friends': friends ?? [],
      'sentRequests': sentRequests ?? [],
      'receivedRequests': receivedRequests ?? [],
    });
  }

  Future<void> updateTamagotchi(String newTamagotchi) async {
    print('Updating tamagotchi to $newTamagotchi');
    await userCollection.doc(uid).update({'tamagotchi': newTamagotchi});
  }

  Future<void> updateName(String newName) async {
    print('Updating name to $newName');
    await userCollection.doc(uid).update({'name': newName});
  }

  Future<void> updatePoints(int delta) async {
    await userCollection.doc(uid).update({
      'points': FieldValue.increment(delta),
    });
  }

  User _userFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    return User.fromData({
      'uid': snapshot.id, // Ensure UID is captured
      ...?data, // Safely spread Firestore data
    });
  }

  Stream<User> get user {
    return userCollection
        .doc(uid)
        .snapshots()
        .map((snapshot) => _userFromSnapshot(snapshot));
  }

  // Helper Functions

  Future<void> incrementBadge(String badgeName, int incrementBy) async {
    await userCollection.doc(uid).update({
      badgeName: FieldValue.increment(incrementBy),
    });
  }

  Future<String> getUsernameFromFriendCode(String friendCode) async {
    try {
      // Query the user collection for a document with the specified friend code
      QuerySnapshot snapshot = await userCollection
          .where('friendId', isEqualTo: friendCode)
          .limit(1)
          .get();

      // Check if a matching document exists
      if (snapshot.docs.isNotEmpty) {
        // Extract the username from the first document
        Map<String, dynamic> data =
            snapshot.docs.first.data() as Map<String, dynamic>;
        return data['name'] ?? 'Unknown User';
      } else {
        throw Exception('No user found with this friend code.');
      }
    } catch (e) {
      // Handle errors (e.g., network issues, permission errors)
      print('Error fetching username: $e');
      throw Exception('Failed to get username from friend code.');
    }
  }

  Future<void> toggleIsCompany() async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    bool currentStatus = snapshot['isCompany'] ?? false;

    await userCollection.doc(uid).update({
      'isCompany': !currentStatus,
    });
  }

  List<DateTime> getDayRange(DateTime date) {
    DateTime today = DateTime(date.year, date.month, date.day);
    DateTime tomorrow = DateTime(date.year, date.month, date.day + 1);

    return [today, tomorrow];
  }

  // Posts

  Future<void> createPost(
    String name,
    String title,
    String description,
    String category,
    String image,
    int likes,
    int flagged,
    DateTime date,
    String uid,
  ) async {
    await postsCollection.add({
      "name": name,
      "title": title,
      "description": description,
      "category": category,
      "image": image,
      "likes": likes,
      "flagged": flagged,
      "date": date,
      "uid": uid,
    });
  }

  Future<void> updatePostsData(
      {bool addLike = false, bool addFlagged = false}) async {
    List<dynamic> postInfo = await getPost();
    Post post = postInfo[0];
    String docId = postInfo[1];

    return await postsCollection.doc(docId).set({
      'date': post.date,
      'name': post.name,
      'title': post.title,
      'description': post.description,
      'category': post.category,
      'image': post.image,
      'likes': addLike ? post.likes + 1 : post.likes,
      'flagged': addFlagged ? post.flagged + 1 : post.flagged,
      'uid': post.uid,
    });
  }

  Post _postFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    return Post.fromData(data ?? {});
  }

  Stream<List<Post>> get post {
    Stream<QuerySnapshot> snapShots;
    if (filter != '') {
      snapShots = postsCollection
          .where('category', isEqualTo: filter)
          .where('flagged', isLessThan: 3)
          .orderBy('date', descending: false)
          .snapshots();
    } else {
      snapShots = postsCollection.where('flagged', isLessThan: 3).snapshots();
    }

    return snapShots.map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

          return _postFromSnapshot(doc);
        }).toList();
      } else {
        return [];
      }
    });
  }

  Future<List<dynamic>> getPost() async {
    QuerySnapshot querySnapshot;
    if (filter != '') {
      querySnapshot = await postsCollection
          .where('category', isEqualTo: filter)
          .where('flagged', isLessThan: 3)
          .orderBy('date', descending: false)
          .get();
    } else {
      querySnapshot =
          await postsCollection.where('flagged', isLessThan: 3).get();
    }

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      return [Post.fromData(data), documentSnapshot.id];
    } else {
      throw Exception('No posts found');
    }
  }

  // Posts filter

  setFilter(String filter) async {
    this.filter = filter;
  }

  Stream<List<User>> get leaderboard {
    return userCollection
        .orderBy('points', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return User.fromData({
          'uid': doc.id, // Ensure UID is included
          ...data, // Merge Firestore data
        });
      }).toList();
    });
  }

  // Friend helper functions
  Future<void> sendFriendRequest(String friendId) async {
    // Check if friendId exists
    QuerySnapshot snapshot = await userCollection
        .where('friendId', isEqualTo: friendId)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) {
      throw Exception('Friend ID does not exist.');
    }

    // Get the receiver's UID
    String receiverUid = snapshot.docs.first.id;

    // Update sender's sentRequests
    await userCollection.doc(uid).update({
      'sentRequests': FieldValue.arrayUnion([receiverUid]),
    });

    // Update receiver's receivedRequests
    await userCollection.doc(receiverUid).update({
      'receivedRequests': FieldValue.arrayUnion([uid]),
    });
  }

  Future<void> acceptFriendRequest(String senderUid) async {
    DocumentSnapshot receiverSnapshot = await userCollection.doc(uid).get();
    DocumentSnapshot senderSnapshot = await userCollection.doc(senderUid).get();

    List<dynamic> receiverPending = receiverSnapshot['receivedRequests'] ?? [];
    List<dynamic> senderSent = senderSnapshot['sentRequests'] ?? [];

    // Validate that the request exists
    if (!receiverPending.contains(senderUid) || !senderSent.contains(uid)) {
      throw Exception('Friend request is invalid or does not exist.');
    }

    // Update both users' friends lists
    await userCollection.doc(uid).update({
      'friends': FieldValue.arrayUnion([senderUid]),
      'receivedRequests': FieldValue.arrayRemove([senderUid]),
    });

    await userCollection.doc(senderUid).update({
      'friends': FieldValue.arrayUnion([uid]),
      'sentRequests': FieldValue.arrayRemove([uid]),
    });
  }

  Future<void> declineFriendRequest(String senderUid) async {
    await userCollection.doc(uid).update({
      'receivedRequests': FieldValue.arrayRemove([senderUid]),
    });

    await userCollection.doc(senderUid).update({
      'sentRequests': FieldValue.arrayRemove([uid]),
    });
  }

  Future<void> removeFriend(String friendUid) async {
    await userCollection.doc(uid).update({
      'friends': FieldValue.arrayRemove([friendUid]),
    });

    await userCollection.doc(friendUid).update({
      'friends': FieldValue.arrayRemove([uid]),
    });
  }

  Future<void> cancelFriendRequest(String friendUid) async {
    await userCollection.doc(uid).update({
      'sentRequests': FieldValue.arrayRemove([friendUid]),
    });

    await userCollection.doc(friendUid).update({
      'receivedRequests': FieldValue.arrayRemove([uid]),
    });
  }
}
