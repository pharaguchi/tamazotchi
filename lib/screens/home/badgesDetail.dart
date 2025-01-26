// badgesDetail.dart
import 'package:flutter/material.dart';

class BadgeDetailsPage extends StatelessWidget {
  final int badgeIndex;  // Index of the selected badge
  final List<Map<String, dynamic>> badges;  // List of all badges

  // Constructor to receive badgeIndex and badges list
  BadgeDetailsPage({required this.badgeIndex, required this.badges});

  @override
  Widget build(BuildContext context) {
    // Get the badge info based on the index
    final badge = badges[badgeIndex];  // Access the badge using the index
    final milestones = badge['milestones']; 

    // Calculate total miles completed by the user
    int totalMiles = milestones.last['progress'] as int;
    // for (var milestone in milestones) {
    //   totalMiles += milestone['progress'] as int;
    // }
    int completedMilestones = 0;
    for (var milestone in milestones) {
      if (milestone['progress'] >= milestone['goal']) {
        completedMilestones++;
      }
    }

    // Determine which badge image to show
    String badgeImage;
    if (completedMilestones == 0) {
      badgeImage = badge['questionImage'];  // Show question mark if no milestones completed
    } else if (completedMilestones < milestones.length) {
      badgeImage = badge['sketchImage'];  // Show sketch if some milestones are completed
    } else {
      badgeImage = badge['fullImage'];  // Show full badge if all milestones are completed
    }

    // Find the next milestone that hasn't been reached yet
    int nextMilestoneGoal = 0;
    int remainingMilesToNextMilestone = 0;
    String milestoneStatus = 'Completed';

    for (var milestone in milestones) {
      if (milestone['progress'] < milestone['goal']) {
        nextMilestoneGoal = milestone['goal'];
        remainingMilesToNextMilestone = nextMilestoneGoal - totalMiles;
        milestoneStatus = 'In Progress';
        break;  // Stop as soon as we find the next milestone
      }
    }

    // If the user has completed all milestones
    if (nextMilestoneGoal == 0) {
      remainingMilesToNextMilestone = 0;
      milestoneStatus = 'Completed';
    }

    // Calculate the progress in percentage for the progress bar
    final totalGoal = milestones.last['goal'];  // The final milestone goal
    final progressPercentage = totalMiles / totalGoal;

    return Scaffold(
      appBar: AppBar(title: Text(badge['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display the appropriate badge icon based on progress with rounded corners
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),  // Rounded corners for the image
              child: Image.asset(
                badgeImage,
                height: 400,
                width: 400,
                fit: BoxFit.cover,  // Ensure the image fills the container while keeping the aspect ratio
              ),
            ),
            SizedBox(height: 20),

            // Remaining miles until next milestone
            Text(
              remainingMilesToNextMilestone > 0
                  ? '$remainingMilesToNextMilestone more until next milestone'
                  : 'You have completed all milestones!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Linear Progress Indicator (shows progress until next milestone)
            LinearProgressIndicator(
              value: progressPercentage,
              minHeight: 10,
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
            ),
            SizedBox(height: 10),

            // Miles completed vs total goal
            Text(
              '$totalMiles / $totalGoal completed',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Milestone Progress
            Text(
              'Milestones:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            for (var milestone in milestones)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(milestone['description']),
                    Text(
                      milestone['progress'] >= milestone['goal']
                          ? 'Completed'
                          : milestoneStatus == 'In Progress'
                              ? 'In Progress'
                              : '',
                      style: TextStyle(
                          color: milestone['progress'] >= milestone['goal']
                              ? Colors.green
                              : milestoneStatus == 'In Progress'
                                  ? Colors.orange
                                  : Colors.grey),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20),

            // Instructions on how to achieve the badge
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("How to Achieve the Badge"),
                    content: Text(
                      "Complete milestones like walking 5 miles, 10 miles, etc.",
                    ),
                    actions: [
                      TextButton(
                        child: Text('Close'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                'Click to Learn How to Achieve This Badge',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}