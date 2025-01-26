import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String name;
  String title;
  String description;
  String category;
  String image;
  int likes;
  int flagged;
  final DateTime date;
  String uid;

  Post({
    this.name = '',
    this.title = '',
    this.description = '',
    this.category = '',
    this.image = '',
    this.likes = 0,
    this.flagged = 0,
    required this.date,
    this.uid = '',
  });

  Post.fromData(Map<String, dynamic> data)
      : name = data['name'] ?? '',
        title = data['title'] ?? '',
        description = data['description'] ?? '',
        category = data['category'] ?? '',
        image = data['image'] ?? '',
        likes = data['likes'] ?? 0,
        flagged = data['flagged'] ?? 0,
        date = (data['date'] as Timestamp).toDate(),
        uid = data['uid'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'image': image,
      'likes': likes,
      'flagged': flagged,
      'date': date,
      'uid': uid
    };
  }
}
