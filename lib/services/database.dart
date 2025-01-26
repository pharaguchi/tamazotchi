import 'package:tamazotchi/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid = ''});

  // collection references

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

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
    await userCollection.doc(uid).update({'tamagotchi': newTamagotchi});
  }

  Future<void> updateName(String newName) async {
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

  List<DateTime> getDayRange(DateTime date) {
    DateTime today = DateTime(date.year, date.month, date.day);
    DateTime tomorrow = DateTime(date.year, date.month, date.day + 1);

    return [today, tomorrow];
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
}
