import 'package:flutter/material.dart';
import 'package:tamazotchi/screens/home/badgesDetail.dart';
import 'package:tamazotchi/models/user.dart';
import 'package:tamazotchi/services/database.dart';

class BadgePage extends StatefulWidget {
  late User _user;
  late final badges;

  BadgePage({Key? key, required User user})
      : _user = user,
        super(key: key);

  @override
  _BadgePageState createState() => _BadgePageState();
}

class _BadgePageState extends State<BadgePage> {
  late User _user;
  late final DatabaseService databaseService;
  late List<Map<String, dynamic>> badges;

  @override
  void initState() {
    _user = widget._user;
    databaseService = DatabaseService(
      uid: _user.uid,
    );

    // List of badges with milestone info and image paths
    badges = [
      {
        'title': 'Sustainable Transportation',
        'questionImage':
            'assets/Badges/question.jpg', // Shared question mark image
        'sketchImage':
            'assets/Badges/athlete_sketch.jpg', // Specific sketch image
        'fullImage': 'assets/Badges/athlete.jpeg', // Specific full badge image
        'description': 'Progress Check:',
        'milestones': [
          {
            'description': '5-mile distance',
            'goal': 5,
            'progress': _user.miles > 5 ? 5 : _user.miles
          },
          {
            'description': '10-mile distance',
            'goal': 10,
            'progress': _user.miles > 10 ? 10 : _user.miles
          },
          {
            'description': '50-mile distance',
            'goal': 50,
            'progress': _user.miles > 50 ? 50 : _user.miles
          },
        ]
      },
      {
        'title': 'Community Engagement',
        'questionImage':
            'assets/Badges/question.jpg', // Shared question mark image
        'sketchImage':
            'assets/Badges/flower_sketch.jpg', // Specific sketch image
        'fullImage': 'assets/Badges/flower.jpeg', // Specific full badge image
        'description': 'Progress Check:',
        'milestones': [
          {
            'description': '5 hours',
            'goal': 5,
            'progress': _user.hoursVolunteered > 5 ? 5 : _user.hoursVolunteered
          },
          {
            'description': '10 hours',
            'goal': 10,
            'progress':
                _user.hoursVolunteered > 10 ? 10 : _user.hoursVolunteered
          },
          {
            'description': '50 hours',
            'goal': 50,
            'progress':
                _user.hoursVolunteered > 50 ? 50 : _user.hoursVolunteered
          },
        ]
      },
      {
        'title': 'Conscious Conservation',
        'questionImage':
            'assets/Badges/question.jpg', // Shared question mark image
        'sketchImage': 'assets/Badges/sun_sketch.jpg', // Specific sketch image
        'fullImage': 'assets/Badges/sun.jpeg', // Specific full badge image
        'description': 'Progress Check:',
        'milestones': [
          {
            'description': '5 eco-friendly items',
            'goal': 5,
            'progress':
                _user.energyCostSavings > 5 ? 5 : _user.energyCostSavings
          },
          {
            'description': '10 eco-friendly items',
            'goal': 10,
            'progress':
                _user.energyCostSavings > 10 ? 10 : _user.energyCostSavings
          },
          {
            'description': '50 eco-friendly items',
            'goal': 50,
            'progress':
                _user.energyCostSavings > 50 ? 50 : _user.energyCostSavings
          },
        ]
      },
      {
        'title': 'Reusable Waterbottle',
        'questionImage':
            'assets/Badges/question.jpg', // Shared question mark image
        'sketchImage':
            'assets/Badges/water_sketch.jpg', // Specific sketch image
        'fullImage': 'assets/Badges/water.jpeg', // Specific full badge image
        'description': 'Progress Check:',
        'milestones': [
          {
            'description': '64 ounces',
            'goal': 64,
            'progress': _user.ounces > 64 ? 64 : _user.ounces
          },
          {
            'description': '128 ounces',
            'goal': 128,
            'progress': _user.ounces > 128 ? 128 : _user.ounces
          },
          {
            'description': '265 ounces',
            'goal': 256,
            'progress': _user.ounces > 128 ? 128 : _user.ounces
          },
        ]
      },
      {
        'title': 'Waste Reduction',
        'questionImage': 'assets/Badges/question.jpg',
        'sketchImage': 'assets/Badges/trashcan_sketch.jpg',
        'fullImage': 'assets/Badges/trashcan.jpeg',
        'description': 'Progress Check:',
        'milestones': [
          {
            'description': '5 items recycled or composed',
            'goal': 5,
            'progress': _user.itemsRecycledOrComposted > 5
                ? 5
                : _user.itemsRecycledOrComposted
          },
          {
            'description': '10 items recycled or compose',
            'goal': 10,
            'progress': _user.itemsRecycledOrComposted > 10
                ? 10
                : _user.itemsRecycledOrComposted
          },
          {
            'description': '50 items recycled or compose',
            'goal': 50,
            'progress': _user.itemsRecycledOrComposted > 50
                ? 50
                : _user.itemsRecycledOrComposted
          },
        ]
      },
      // Add other badges with specific images...
    ];

    super.initState();
  }

  // Helper function to determine the correct image based on milestone progress
  String _getBadgeImage(int index) {
    List<dynamic> milestones = badges[index]['milestones'];
    int completedMilestones = milestones
        .where((milestone) => milestone['progress'] >= milestone['goal'])
        .length;

    if (completedMilestones == 0) {
      // No milestones completed: Question mark image (shared image)
      return badges[index]['questionImage'];
    } else if (completedMilestones < milestones.length) {
      // Some milestones completed, but not all: Sketch image
      return badges[index]['sketchImage'];
    } else {
      // All milestones completed: Full badge image
      return badges[index]['fullImage'];
    }
  }

  // Navigate to detailed page for a specific badge
  void _navigateToBadgeDetails(BuildContext context, int badgeIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BadgeDetailsPage(badgeIndex: badgeIndex, badges: badges),
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
            // Get the appropriate image for the badge
            String badgeImage = _getBadgeImage(index);

            return GestureDetector(
              onTap: () => _navigateToBadgeDetails(context, index),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Let the column take the minimum space
                children: [
                  // Use the dynamically chosen image
                  Flexible(
                    child: Image.asset(badgeImage, fit: BoxFit.cover),
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
