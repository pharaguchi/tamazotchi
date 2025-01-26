import 'package:flutter/material.dart';
import 'package:tamazotchi/models/user.dart';
import 'package:tamazotchi/services/auth.dart';
import 'package:tamazotchi/screens/home/badges.dart';
import 'package:tamazotchi/screens/home/friends.dart';
import 'package:tamazotchi/screens/home/myPosts.dart';
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
    // Optionally update the navigation bar index (if needed)
    setNavBarIdx(
        1); // You can adjust the index to the BadgePage index in your navigation bar
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BadgePage(user: _user)),
    );
  }

  // Method to navigate to the Friends Page
  void _navigateToFriends() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FriendsPage(user: _user)),
    );
  }

  // Method to navigate to the MyPostsScreen
  void _navigateToMyPosts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserPostsScreen(user: _user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 60),
        Center(
          child: Text(
            'Hi ${_user.name}!', // Main greeting
            style: TextStyle(fontSize: 24),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: _navigateToMyPosts, // Navigate to My Posts
              child: Padding(
                padding: const EdgeInsets.only(top: 16, left: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_outlined,
                      size: 70,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'My Posts',
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
                      'My Friends', // Text displayed under the icon
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: _navigateToBadges, // Navigate to Badges
              child: Padding(
                padding: const EdgeInsets.only(top: 16, right: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.badge_outlined,
                      size: 70,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'My Badges',
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
