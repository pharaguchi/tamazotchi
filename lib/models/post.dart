import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String name;
  String title;
  String description;
  String category;
  String image;
  int likes;
  bool flagged;
  final DateTime date;

  Post({
    this.name = '',
    this.title = '',
    this.description = '',
    this.category = '',
    this.image = '',
    this.likes = 0,
    this.flagged = false,
    required this.date,
  });

  Post.fromData(Map<String, dynamic> data)
      : name = data['name'] ?? '',
        title = data['title'] ?? '',
        description = data['description'] ?? '',
        category = data['category'] ?? '',
        image = data['image'] ?? '',
        likes = data['likes'] ?? 0,
        flagged = data['flagged'] ?? false,
        date = (data['date'] as Timestamp).toDate();

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'image': image,
      'likes': likes,
      'flagged': flagged,
      'date': date,
    };
  }
}
