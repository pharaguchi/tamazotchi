  import 'package:flutter/material.dart';

class BadgePage extends StatelessWidget {
  // Sample data for badges
  final List<Map<String, dynamic>> badges = [
    {'title': 'Sustainable Transportation', 'icon': Icons.directions_walk, 'description': 'Complete 10 walks with your pet.'},
    {'title': 'Energy Conservation', 'icon': Icons.fastfood, 'description': 'Feed your pet 5 times a day.'},
    {'title': 'Waste Reduction', 'icon': Icons.videogame_asset, 'description': 'Play games with your pet.'},
    {'title': 'Conscious Conservation', 'icon': Icons.explore, 'description': 'Explore new places together.'},
    {'title': 'Reusable Waterbottle', 'icon': Icons.group, 'description': 'Connect with other pet owners.'},
    {'title': 'Community Engagment', 'icon': Icons.sentiment_very_satisfied, 'description': 'Complete happy tasks with your pet.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Badge Page'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 badges per row
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: badges.length,
        itemBuilder: (context, index) {
          var badge = badges[index];
          return GestureDetector(
            onTap: () {
              // Navigate to the badge detail page (You can create a new page for badge details)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BadgeDetailPage(
                    title: badge['title'],
                    description: badge['description'],
                  ),
                ),
              );
            },
            child: Card(
              color: Colors.pink[50],
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    badge['icon'],
                    size: 50,
                    color: Colors.pinkAccent,
                  ),
                  SizedBox(height: 8),
                  Text(
                    badge['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.pinkAccent,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BadgeDetailPage extends StatelessWidget {
  final String title;
  final String description;

  BadgeDetailPage({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.star,
              size: 100,
              color: Colors.pinkAccent,
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
            ),
            SizedBox(height: 16),
            Text(
              description,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
