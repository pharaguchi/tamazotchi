class User {
  final String uid;
  String name;
  String email;
  int points;
  String tamagotchi;

  User({
    required this.uid,
    this.name = '',
    this.email = '',
    this.points = 0,
    this.tamagotchi = '',
  });

  User.fromData(Map<String, dynamic> data)
      : uid = data['uid'],
        name = data['name'] ?? '',
        email = data['email'] ?? '',
        points = data['points'] ?? 0,
        tamagotchi = data['tamagotchi'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'points': points,
      'tamagotchi': tamagotchi,
    };
  }
}
