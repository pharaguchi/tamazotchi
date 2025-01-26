import 'package:tamazotchi/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid = ''});

  // collection references

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // Users

  Future<void> updateUserData(
      {required String name,
      required String email,
      required int points,
      required String tamagotchi}) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'points': points,
      'tamagotchi': tamagotchi,
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

    return User(
        uid: uid,
        name: data?['name'],
        email: data?['email'],
        points: data?['points'],
        tamagotchi: data?['tamagotchi']);
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
