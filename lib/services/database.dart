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

  Future<void> updateUserData(
    String name,
    String email,
  ) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
    });
  }

  User _userFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    return User(uid: uid, name: data?['name'], email: data?['email']);
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

  // Posts

  Future<void> createPost(
    String name,
    String title,
    String description,
    String category,
    String image,
    int likes,
    bool flagged,
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
      {bool addLike = false, bool flagged = false}) async {
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
      'flagged': flagged,
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
          .where('flagged', isEqualTo: false)
          .orderBy('date', descending: false)
          .snapshots();
    } else {
      snapShots =
          postsCollection.where('flagged', isEqualTo: false).snapshots();
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
          .where('flagged', isEqualTo: false)
          .orderBy('date', descending: false)
          .get();
    } else {
      querySnapshot =
          await postsCollection.where('flagged', isEqualTo: false).get();
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
}
