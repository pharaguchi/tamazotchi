import 'package:flutter/material.dart';
import 'package:tamazotchi/screens/home/badgesDetail.dart';

class BadgePage extends StatefulWidget {
  @override
  _BadgePageState createState() => _BadgePageState();
}

class _BadgePageState extends State<BadgePage> {
  // List of badges with milestone info and image paths
  final List<Map<String, dynamic>> badges = [
    {
      'title': 'Sustainable Transportation',
      'questionImage': 'assets/Badges/question.jpg',  // Shared question mark image
      'sketchImage': 'assets/Badges/athlete_sketch.jpg',  // Specific sketch image
      'fullImage': 'assets/Badges/athlete.jpeg',  // Specific full badge image
      'description': 'Progress Check:',
      'milestones': [
        {'description': 'Walk 5 miles', 'goal': 5, 'progress': 5},
        {'description': 'Walk 10 miles', 'goal': 10, 'progress': 10},
        {'description': 'Walk 50 miles', 'goal': 50, 'progress': 50},
      ]
    },
    {
      'title': 'Community Engagement',
      'questionImage': 'assets/Badges/question.jpg',  // Shared question mark image
      'sketchImage': 'assets/Badges/flower_sketch.jpg',  // Specific sketch image
      'fullImage': 'assets/Badges/flower.jpeg',  // Specific full badge image
      'description': 'Progress Check:',
      'milestones': [
        {'description': 'Walk 5 miles', 'goal': 5, 'progress': 5},
        {'description': 'Walk 10 miles', 'goal': 10, 'progress': 10},
        {'description': 'Walk 50 miles', 'goal': 50, 'progress': 50},
      ]
    },
    {
      'title': 'Conscious Conservation',
      'questionImage': 'assets/Badges/question.jpg',  // Shared question mark image
      'sketchImage': 'assets/Badges/sun_sketch.jpg',  // Specific sketch image
      'fullImage': 'assets/Badges/sun.jpeg',  // Specific full badge image
      'description': 'Progress Check:',
      'milestones': [
        {'description': 'Walk 5 miles', 'goal': 5, 'progress': 5},
        {'description': 'Walk 10 miles', 'goal': 10, 'progress': 10},
        {'description': 'Walk 50 miles', 'goal': 50, 'progress': 50},
      ]
    },
    {
      'title': 'Reusable Waterbottle',
      'questionImage': 'assets/Badges/question.jpg',  // Shared question mark image
      'sketchImage': 'assets/Badges/water_sketch.jpg',  // Specific sketch image
      'fullImage': 'assets/Badges/water.jpeg',  // Specific full badge image
      'description': 'Progress Check:',
      'milestones': [
        {'description': 'Walk 5 miles', 'goal': 5, 'progress': 5},
        {'description': 'Walk 10 miles', 'goal': 10, 'progress': 10},
        {'description': 'Walk 50 miles', 'goal': 50, 'progress': 50},
      ]
    },
    {
      'title': 'Waste Reduction',
      'questionImage': 'assets/Badges/question.jpg',
      'sketchImage': 'assets/Badges/trashcan_sketch.jpg',
      'fullImage': 'assets/Badges/trashcan.jpeg',
      'description': 'Progress Check:',
      'milestones': [
        {'description': 'Run 5 miles', 'goal': 5, 'progress': 5},
        {'description': 'Run 10 miles', 'goal': 10, 'progress': 10},
        {'description': 'Run 50 miles', 'goal': 50, 'progress': 50},
      ]
    },
    // Add other badges with specific images...
  ];

  // Helper function to determine the correct image based on milestone progress
  String _getBadgeImage(int index) {
    List<dynamic> milestones = badges[index]['milestones'];
    int completedMilestones = milestones.where((milestone) => milestone['progress'] >= milestone['goal']).length;

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
            crossAxisCount: 2,  // 2 columns
            crossAxisSpacing: 16,  // Space between columns
            mainAxisSpacing: 16,   // Space between rows
          ),
          itemCount: badges.length,
          itemBuilder: (context, index) {
            // Get the appropriate image for the badge
            String badgeImage = _getBadgeImage(index);

            return GestureDetector(
              onTap: () => _navigateToBadgeDetails(context, index),
              child: Column(
                mainAxisSize: MainAxisSize.min,  // Let the column take the minimum space it needs
                children: [
                  // Use the dynamically chosen image
                  Image.asset(badgeImage, height: 200, width: 200),
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
