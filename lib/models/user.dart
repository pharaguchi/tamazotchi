class User {
  final String uid;
  String name;
  String email;
  int points;

  User({
    required this.uid,
    this.name = '',
    this.email = '',
    this.points = 0,
  });

  User.fromData(Map<String, dynamic> data)
      : uid = data['uid'],
        name = data['name'] ?? '',
        email = data['email'] ?? '',
        points = data['points'] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'points': points,
    };
  }
}
