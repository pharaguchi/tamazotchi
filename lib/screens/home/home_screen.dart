import 'package:flutter/material.dart';
import 'package:tamazotchi/models/user.dart';
import 'package:tamazotchi/services/auth.dart';
import 'package:tamazotchi/screens/home/badges.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required User user, required Function setNavBarIdx})
      : _user = user,
        setNavBarIdx = setNavBarIdx,
        super(key: key);

  final User _user;
  final Function setNavBarIdx;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  late User _user;
  late Function setNavBarIdx;

  @override
  void initState() {
    _user = widget._user;
    setNavBarIdx = widget.setNavBarIdx;

    super.initState();
  }

  // Method to navigate to the BadgePage
  void _navigateToBadges() {
    // Optionally update the navigation bar index (if needed)
    setNavBarIdx(1); // You can adjust the index to the BadgePage index in your navigation bar

    // Navigate to the BadgePage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BadgePage()), // Ensure BadgePage exists or is imported
    );
  }

  @override
Widget build(BuildContext context) {
  return Column(
    children: [
      // The rest of the content in the column, centered
      SizedBox(height: 60), // Add some space to push the rest of the content down
      Center(
        child: Text(
          'Welcome back ${_user.name}! I missed you <3',  // Main text/content
          style: TextStyle(fontSize: 24),
        ),
      ),

      // Align the entire widget (icon + text) to the top-right corner
      Align(
        alignment: Alignment.topRight,  // Align the widget to top-right
        child: GestureDetector(
          onTap: _navigateToBadges,  // Navigate to BadgePage on tap
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),  // Padding from top and right
            child: Column(
              mainAxisSize: MainAxisSize.min,  // The column only takes as much space as needed
              crossAxisAlignment: CrossAxisAlignment.center,  // Center icon and text horizontally
              children: [
                Icon(
                  Icons.badge,
                  size: 70,  // Size of the badge icon
                  color: Colors.blue,  // Icon color
                ),
                SizedBox(height: 8),  // Space between the icon and the text
                Text(
                  'My Badges',  // Text displayed under the icon
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
      
    ],
  );
}

}

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // Badge Icon that when tapped will navigate to BadgePage
//         GestureDetector(
//           onTap: _navigateToBadges,  // Navigate to BadgePage on tap
//           child: Icon(
//             Icons.badge,
//             size: 50,  // Size of the badge icon
//             color: Colors.blue,  // Icon color
//           ),
//         ),
//         SizedBox(height: 20),  // Add some space
//         Text(
//           'My Badges',  // Display user name
//           style: TextStyle(fontSize: 16),
//         ),
//         SizedBox(height: 10),  // Add some space
//         // You can add more widgets if needed, but this is minimal
//       ],
//     );
//   }
// }
