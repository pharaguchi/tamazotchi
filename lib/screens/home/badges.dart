import 'package:flutter/material.dart';
import 'package:tamazotchi/screens/home/badgesDetail.dart';

class BadgePage extends StatefulWidget {
  @override
  _BadgePageState createState() => _BadgePageState();
}

class _BadgePageState extends State<BadgePage> {
  // List of badges with milestone info
  final List<Map<String, dynamic>> badges = [
    {
      'title': 'Walking Badge',
      'icon': Icons.directions_walk, // Icon for the badge
      'description': 'Progress Check:',
      'milestones': [
        {'description': 'Walk 5 miles', 'goal': 5, 'progress': 5},
        {'description': 'Walk 10 miles', 'goal': 10, 'progress': 10},
        {'description': 'Walk 50 miles', 'goal': 50, 'progress': 13},
      ]
    },
    {
      'title': 'Running Badge',
      'icon': Icons.directions_run, // Icon for running
      'description': 'Progress Check:',
      'milestones': [
        {'description': 'Run 5 mile', 'goal': 5, 'progress': 5},
        {'description': 'Run 10 miles', 'goal': 10, 'progress': 6},
        {'description': 'Run 50 miles', 'goal': 50, 'progress': 6},
      ]
    },
    // Add more badges as needed
  ];

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
            return GestureDetector(
              onTap: () => _navigateToBadgeDetails(context, index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    badges[index]['icon'],
                    size: 80,  // Icon size
                    color: Colors.blue,
                  ),
                  SizedBox(height: 8),
                  Text(
                    badges[index]['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
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
