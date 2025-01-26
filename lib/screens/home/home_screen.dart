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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BadgePage()),
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
