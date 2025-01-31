import 'package:tamazotchi/models/user.dart';
import 'package:tamazotchi/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:tamazotchi/config/constants.dart';
import 'dart:math';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  // create user obj based on firebase user
  User? _userFromFirebaseUser(firebase_auth.User? user,
      {String name = '', String email = '', String friendId = ''}) {
    return User(
      uid: user?.uid ?? '',
      name: name,
      email: email,
      friendId: friendId,
    );
  }

  // auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      firebase_auth.UserCredential result = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      firebase_auth.User? user = result.user;
      if (user != null &&
          user!.metadata != null &&
          user!.metadata!.lastSignInTime != null) {
        DateTime lastLoginTime = user!.metadata!.lastSignInTime!;
        DateTime lastLoginDay = DateTime(
            lastLoginTime.year, lastLoginTime.month, lastLoginTime.day);
        DateTime currLoginDay = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);

        if (lastLoginDay.isBefore(currLoginDay)) {}
      }
      return user;
    } catch (error) {
      print(error.toString());
      return error;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      firebase_auth.UserCredential result = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      firebase_auth.User? user = result.user;

      // Assign a random tamagotchi
      final random = Random();
      String randomTamagotchi =
          tamagotchiNames[random.nextInt(tamagotchiNames.length)];

      // Generate a unique friendId
      String friendId = user!.uid.substring(0, 6);

      // Save the user data, including the tamagotchi
      await DatabaseService(uid: user!.uid).updateUserData(
        name: name,
        email: email,
        points: 0,
        tamagotchi: randomTamagotchi,
        isCompany: false,
        friendId: friendId,
        percentCarbonEmissionsReduced: 0,
        percentSustainableMaterials: 0,
        numGreenPartnerships: 0,
        energyCostSavings: 0,
        employeeVolunteerHours: 0,
        miles: 0,
        itemsRecycledOrComposted: 0,
        numEcoFriendlyItems: 0,
        ounces: 0,
        hoursVolunteered: 0,
        posts: [],
        likedPosts: [],
        reportedPosts: [],
        friends: [],
        sentRequests: [],
        receivedRequests: [],
      );

      // Return user object
      return _userFromFirebaseUser(user,
          name: name, email: email, friendId: friendId);
    } catch (error) {
      print(error.toString());
      return error;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
