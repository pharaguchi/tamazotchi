import 'package:flutter/material.dart';
import 'package:tamazotchi/models/user.dart';
import 'package:tamazotchi/services/auth.dart';
import 'package:tamazotchi/screens/home/badges.dart';
import 'package:tamazotchi/screens/home/friends.dart';
import 'package:tamazotchi/util.dart';

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
    // Navigate to the BadgePage
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              BadgePage()), // Ensure BadgePage exists or is imported
    );
  }

  // Method to navigate to the Friends Page
  void _navigateToFriends() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FriendsPage(user: _user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // The rest of the content in the column, centered
        SizedBox(
            height: 60), // Add some space to push the rest of the content down
        Center(
          child: Text(
            'Hi ${_user.name}!', // Main text/content
            style: TextStyle(fontSize: 24),
          ),
        ),
        // Align the entire widget (icon + text) to the top-right corner
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: _navigateToFriends,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 16, left: 16), // Padding from top and right
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // The column only takes as much space as needed
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Center icon and text horizontally
                  children: [
                    Icon(
                      Icons.chat_outlined,
                      size: 70, // Size of the badge icon
                      color: Colors.blue, // Icon color
                    ),
                    SizedBox(height: 8), // Space between the icon and the text
                    Text(
                      'My Posts', // Text displayed under the icon
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: _navigateToFriends, // Navigate to FriendsPage on tap
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 16, right: 16), // Padding from top and right
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // The column only takes as much space as needed
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Center icon and text horizontally
                  children: [
                    Icon(
                      Icons.perm_contact_calendar_rounded,
                      size: 70, // Size of the badge icon
                      color: Colors.blue, // Icon color
                    ),
                    SizedBox(height: 8), // Space between the icon and the text
                    Text(
                      'Friends', // Text displayed under the icon
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: _navigateToBadges, // Navigate to BadgePage on tap
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 16, right: 16), // Padding from top and right
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // The column only takes as much space as needed
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Center icon and text horizontally
                  children: [
                    Icon(
                      Icons.badge_outlined,
                      size: 70, // Size of the badge icon
                      color: Colors.blue, // Icon color
                    ),
                    SizedBox(height: 8), // Space between the icon and the text
                    Text(
                      'My Badges', // Text displayed under the icon
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.1,
        ),
        Image(
          image:
              AssetImage('assets/${getTamagotchiImageLink(_user.tamagotchi)}'),
          fit: BoxFit.contain,
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.width * 0.7,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.1,
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
