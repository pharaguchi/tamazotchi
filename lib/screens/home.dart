import 'package:flutter/material.dart';
import 'package:tamazotchi/screens/home/home_screen.dart';
import 'package:tamazotchi/screens/leaderboard/leaderboard_screen.dart';
import 'package:tamazotchi/screens/settings/settings_screen.dart';
import 'package:tamazotchi/services/auth.dart';
import 'package:tamazotchi/models/user.dart';
import 'package:tamazotchi/services/database.dart';
import 'package:tamazotchi/screens/feed/feed_screen.dart';

class Home extends StatefulWidget {
  Home({super.key, required this.user, required this.databaseService});
  final User user;
  final DatabaseService databaseService;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int navBarIdx = 0;

  setNavBarIdx(idx) {
    setState(() {
      navBarIdx = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: widget.databaseService.user,
        builder: (context, userSnapshot) {
          if (userSnapshot.hasData) {
            User userInfo = userSnapshot.data!;
            List<Widget> pages = [
              HomeScreen(user: userInfo, setNavBarIdx: setNavBarIdx),
              FeedScreen(user: userInfo, setNavBarIdx: setNavBarIdx),
              SettingsScreen(user: userInfo, setNavBarIdx: setNavBarIdx),
              LeaderboardScreen(user: userInfo, setNavBarIdx: setNavBarIdx),
            ];

            return Scaffold(
                bottomNavigationBar: SafeArea(
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Colors.black,
                    selectedItemColor: Colors.brown,
                    unselectedItemColor: Colors.blue,
                    currentIndex: navBarIdx,
                    onTap: (int idx) {
                      setNavBarIdx(idx);
                    },
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home), label: 'Home'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.chat_bubble), label: 'Feed'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.settings), label: 'Settings'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.leaderboard), label: 'Leaderboard'),
                    ],
                  ),
                ),
                body: SingleChildScrollView(child: pages[navBarIdx]));
          } else {
            return Scaffold(
              body: SizedBox(height: 20.0),
            );
          }
        });
  }
}
