class User {
  final String uid;
  String name;
  String email;
  int points;
  String tamagotchi;
  bool isCompany;
  String friendId;

  // posts
  List<String> posts;
  List<String> likedPosts;
  List<String> reportedPosts;

  // company badges
  int percentCarbonEmissionsReduced;
  int percentSustainableMaterials;
  int numGreenPartnerships;
  int energyCostSavings;
  int employeeVolunteerHours;

  // user badges
  int miles;
  int itemsRecycledOrComposted;
  int numEcoFriendlyItems;
  int ounces;
  int hoursVolunteered;

  // friends
  List<String> friends;
  List<String> sentRequests;
  List<String> receivedRequests;

  User({
    required this.uid,
    this.name = '',
    this.email = '',
    this.points = 0,
    this.tamagotchi = '',
    this.isCompany = false,
    this.friendId = '',

    // posts
    List<String>? posts,
    List<String>? likedPosts,
    List<String>? reportedPosts,

    // company badges
    this.percentCarbonEmissionsReduced = 0,
    this.percentSustainableMaterials = 0,
    this.numGreenPartnerships = 0,
    this.energyCostSavings = 0,
    this.employeeVolunteerHours = 0,

    // user badges
    this.miles = 0,
    this.itemsRecycledOrComposted = 0,
    this.numEcoFriendlyItems = 0,
    this.ounces = 0,
    this.hoursVolunteered = 0,

    // friends
    List<String>? friends,
    List<String>? sentRequests,
    List<String>? receivedRequests,
  })  : posts = posts ?? [],
        likedPosts = likedPosts ?? [],
        reportedPosts = reportedPosts ?? [],
        friends = friends ?? [],
        sentRequests = sentRequests ?? [],
        receivedRequests = receivedRequests ?? [];

  /// Create a User from a data map
  User.fromData(Map<String, dynamic> data)
      : uid = data['uid'],
        name = data['name'] ?? '',
        email = data['email'] ?? '',
        points = data['points'] ?? 0,
        tamagotchi = data['tamagotchi'] ?? '',
        isCompany = data['isCompany'] ?? false,
        friendId = data['friendId'] ?? '',

        // posts
        posts = List<String>.from(data['posts'] ?? []),
        likedPosts = List<String>.from(data['likedPosts'] ?? []),
        reportedPosts = List<String>.from(data['reportedPosts'] ?? []),

        // company badges
        percentCarbonEmissionsReduced =
            data['percentCarbonEmissionsReduced'] ?? 0,
        percentSustainableMaterials = data['percentSustainableMaterials'] ?? 0,
        numGreenPartnerships = data['numGreenPartnerships'] ?? 0,
        energyCostSavings = data['energyCostSavings'] ?? 0,
        employeeVolunteerHours = data['employeeVolunteerHours'] ?? 0,

        // user badges
        miles = data['miles'] ?? 0,
        itemsRecycledOrComposted = data['itemsRecycledOrComposted'] ?? 0,
        numEcoFriendlyItems = data['numEcoFriendlyItems'] ?? 0,
        ounces = data['ounces'] ?? 0,
        hoursVolunteered = data['hoursVolunteered'] ?? 0,

        // friends
        friends = List<String>.from(data['friends'] ?? []),
        sentRequests = List<String>.from(data['sentRequests'] ?? []),
        receivedRequests = List<String>.from(data['receivedRequests'] ?? []);

  /// Convert a User to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'points': points,
      'tamagotchi': tamagotchi,
      'isCompany': isCompany,
      'friendId': friendId,

      // posts
      'posts': posts,
      'likedPosts': likedPosts,
      'reportedPosts': reportedPosts,

      // company badges
      'percentCarbonEmissionsReduced': percentCarbonEmissionsReduced,
      'percentSustainableMaterials': percentSustainableMaterials,
      'numGreenPartnerships': numGreenPartnerships,
      'energyCostSavings': energyCostSavings,
      'employeeVolunteerHours': employeeVolunteerHours,

      // user badges
      'miles': miles,
      'itemsRecycledOrComposted': itemsRecycledOrComposted,
      'numEcoFriendlyItems': numEcoFriendlyItems,
      'ounces': ounces,
      'hoursVolunteered': hoursVolunteered,

      // friends
      'friends': friends,
      'sentRequests': sentRequests,
      'receivedRequests': receivedRequests,
    };
  }
}
