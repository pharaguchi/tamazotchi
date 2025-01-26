import 'package:flutter/material.dart';
import 'package:tamazotchi/screens/home/badgesDetail.dart';
import 'package:tamazotchi/models/user.dart';
import 'package:tamazotchi/services/database.dart';

class BadgePage extends StatefulWidget {
  final User _user;

  BadgePage({Key? key, required User user}) : _user = user, super(key: key);

  @override
  _BadgePageState createState() => _BadgePageState();
}

class _BadgePageState extends State<BadgePage> {
  late User _user;
  late List<Map<String, dynamic>> badges;

  @override
  void initState() {
    super.initState();
    _user = widget._user;

    // Check if the user is a company or individual and load the appropriate badges
    if (_user.isCompany) {
      badges = _getCompanyBadges(); // Load company-specific badges
    } else {
      badges = _getUserBadges(); // Load user-specific badges
    }
  }

  // Company-specific badges
  List<Map<String, dynamic>> _getCompanyBadges() {
    return [
      {
        'title': 'Carbon Emissions',
        'questionImage': 'assets/Badges/question.jpg',
        'sketchImage': 'assets/Badges/athlete_sketch.jpg',
        'fullImage': 'assets/Badges/athlete.jpeg',
        'milestones': [
          {'description': '5-mile distance', 'goal': 5, 'progress': _user.miles > 5 ? 5 : _user.miles},
          {'description': '10-mile distance', 'goal': 10, 'progress': _user.miles > 10 ? 10 : _user.miles},
          {'description': '50-mile distance', 'goal': 50, 'progress': _user.miles > 50 ? 50 : _user.miles},
        ]
      },
      {
        'title': 'Employee Community Engagement',
        'questionImage': 'assets/Badges/question.jpg',
        'sketchImage': 'assets/Badges/flower_sketch.jpg',
        'fullImage': 'assets/Badges/flower.jpeg',
        'milestones': [
          {'description': '5 hours', 'goal': 5, 'progress': _user.hoursVolunteered > 5 ? 5 : _user.hoursVolunteered},
          {'description': '10 hours', 'goal': 10, 'progress': _user.hoursVolunteered > 10 ? 10 : _user.hoursVolunteered},
          {'description': '50 hours', 'goal': 50, 'progress': _user.hoursVolunteered > 50 ? 50 : _user.hoursVolunteered},
        ]
      },
      {
        'title': 'Sustainable Materials/Packaging',
        'questionImage': 'assets/Badges/question.jpg',
        'sketchImage': 'assets/Badges/sun_sketch.jpg',
        'fullImage': 'assets/Badges/sun.jpeg',
        'milestones': [
          {'description': '5 eco-friendly items', 'goal': 5, 'progress': _user.energyCostSavings > 5 ? 5 : _user.energyCostSavings},
          {'description': '10 eco-friendly items', 'goal': 10, 'progress': _user.energyCostSavings > 10 ? 10 : _user.energyCostSavings},
          {'description': '50 eco-friendly items', 'goal': 50, 'progress': _user.energyCostSavings > 50 ? 50 : _user.energyCostSavings},
        ]
      },
      {
        'title': 'Green Partnerships',
        'questionImage': 'assets/Badges/question.jpg',
        'sketchImage': 'assets/Badges/water_sketch.jpg',
        'fullImage': 'assets/Badges/water.jpeg',
        'milestones': [
          {'description': '64 ounces', 'goal': 64, 'progress': _user.ounces > 64 ? 64 : _user.ounces},
          {'description': '128 ounces', 'goal': 128, 'progress': _user.ounces > 128 ? 128 : _user.ounces},
          {'description': '265 ounces', 'goal': 256, 'progress': _user.ounces > 128 ? 128 : _user.ounces},
        ]
      },
      {
        'title': 'Energy Efficient Buildings/Systems',
        'questionImage': 'assets/Badges/question.jpg',
        'sketchImage': 'assets/Badges/trashcan_sketch.jpg',
        'fullImage': 'assets/Badges/trashcan.jpeg',
        'milestones': [
          {'description': '5 items recycled or composed', 'goal': 5, 'progress': _user.itemsRecycledOrComposted > 5 ? 5 : _user.itemsRecycledOrComposted},
          {'description': '10 items recycled or compose', 'goal': 10, 'progress': _user.itemsRecycledOrComposted > 10 ? 10 : _user.itemsRecycledOrComposted},
          {'description': '50 items recycled or compose', 'goal': 50, 'progress': _user.itemsRecycledOrComposted > 50 ? 50 : _user.itemsRecycledOrComposted},
        ]
      },
    ];
  }

  // User-specific badges
  List<Map<String, dynamic>> _getUserBadges() {
    return [
      {
        'title': 'Sustainable Transportation',
        'questionImage': 'assets/Badges/question.jpg',
        'sketchImage': 'assets/Badges/athlete_sketch.jpg',
        'fullImage': 'assets/Badges/athlete.jpeg',
        'milestones': [
          {'description': '5-mile distance', 'goal': 5, 'progress': _user.miles > 5 ? 5 : _user.miles},
          {'description': '10-mile distance', 'goal': 10, 'progress': _user.miles > 10 ? 10 : _user.miles},
          {'description': '50-mile distance', 'goal': 50, 'progress': _user.miles > 50 ? 50 : _user.miles},
        ]
      },
      {
        'title': 'Community Engagement',
        'questionImage': 'assets/Badges/question.jpg',
        'sketchImage': 'assets/Badges/flower_sketch.jpg',
        'fullImage': 'assets/Badges/flower.jpeg',
        'milestones': [
          {'description': '5 hours', 'goal': 5, 'progress': _user.hoursVolunteered > 5 ? 5 : _user.hoursVolunteered},
          {'description': '10 hours', 'goal': 10, 'progress': _user.hoursVolunteered > 10 ? 10 : _user.hoursVolunteered},
          {'description': '50 hours', 'goal': 50, 'progress': _user.hoursVolunteered > 50 ? 50 : _user.hoursVolunteered},
        ]
      },
      {
        'title': 'Conscious Conservation',
        'questionImage': 'assets/Badges/question.jpg',
        'sketchImage': 'assets/Badges/sun_sketch.jpg',
        'fullImage': 'assets/Badges/sun.jpeg',
        'milestones': [
          {'description': '5 eco-friendly items', 'goal': 5, 'progress': _user.energyCostSavings > 5 ? 5 : _user.energyCostSavings},
          {'description': '10 eco-friendly items', 'goal': 10, 'progress': _user.energyCostSavings > 10 ? 10 : _user.energyCostSavings},
          {'description': '50 eco-friendly items', 'goal': 50, 'progress': _user.energyCostSavings > 50 ? 50 : _user.energyCostSavings},
        ]
      },
      {
        'title': 'Reusable Waterbottle',
        'questionImage': 'assets/Badges/question.jpg',
        'sketchImage': 'assets/Badges/water_sketch.jpg',
        'fullImage': 'assets/Badges/water.jpeg',
        'milestones': [
          {'description': '64 ounces', 'goal': 64, 'progress': _user.ounces > 64 ? 64 : _user.ounces},
          {'description': '128 ounces', 'goal': 128, 'progress': _user.ounces > 128 ? 128 : _user.ounces},
          {'description': '265 ounces', 'goal': 256, 'progress': _user.ounces > 128 ? 128 : _user.ounces},
        ]
      },
      {
        'title': 'Waste Reduction',
        'questionImage': 'assets/Badges/question.jpg',
        'sketchImage': 'assets/Badges/trashcan_sketch.jpg',
        'fullImage': 'assets/Badges/trashcan.jpeg',
        'milestones': [
          {'description': '5 items recycled or composed', 'goal': 5, 'progress': _user.itemsRecycledOrComposted > 5 ? 5 : _user.itemsRecycledOrComposted},
          {'description': '10 items recycled or compose', 'goal': 10, 'progress': _user.itemsRecycledOrComposted > 10 ? 10 : _user.itemsRecycledOrComposted},
          {'description': '50 items recycled or compose', 'goal': 50, 'progress': _user.itemsRecycledOrComposted > 50 ? 50 : _user.itemsRecycledOrComposted},
        ]
      },
    ];
  }

  // Helper function to get the correct badge image based on progress
  String _getBadgeImage(int index) {
    List<dynamic> milestones = badges[index]['milestones'];
    int completedMilestones = milestones.where((milestone) => milestone['progress'] >= milestone['goal']).length;

    if (completedMilestones == 0) {
      return badges[index]['questionImage']; // No milestones completed
    } else if (completedMilestones < milestones.length) {
      return badges[index]['sketchImage']; // Some milestones completed
    } else {
      return badges[index]['fullImage']; // All milestones completed
    }
  }

  // Navigate to badge details page
  void _navigateToBadgeDetails(BuildContext context, int badgeIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BadgeDetailsPage(badgeIndex: badgeIndex, badges: badges),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Badges")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            crossAxisSpacing: 16, // Space between columns
            mainAxisSpacing: 16, // Space between rows
          ),
          itemCount: badges.length,
          itemBuilder: (context, index) {
            // Get the correct image for each badge
            String badgeImage = _getBadgeImage(index);

            return GestureDetector(
              onTap: () => _navigateToBadgeDetails(context, index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Container with rounded corners and shadow effect
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(0, 4), // Shadow position
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0), // Apply rounded corners
                      child: Image.asset(
                        badgeImage,
                        fit: BoxFit.cover,
                        height: 200, // Fixed height to keep images consistent
                        width: 200, // Full width for the image
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    badges[index]['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}



