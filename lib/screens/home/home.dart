import 'package:flutter/material.dart';
import 'package:tamazotchi/screens/home/home_screen.dart';
import 'package:tamazotchi/services/auth.dart';
import 'package:tamazotchi/models/user.dart';
import 'package:tamazotchi/services/database.dart';

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
              HomeScreen(user: userInfo, setNavBarIdx: setNavBarIdx),
            ];
            List<String> titles = ["Home", "Setting"];

            return Scaffold(
                appBar: AppBar(
                  title: Text(titles[navBarIdx]),
                  backgroundColor: Colors.brown,
                  elevation: 0.0,
                  actions: <Widget>[
                    TextButton(
                      child: Icon(Icons.home),
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.white),
                      onPressed: () {
                        setState(() {
                          navBarIdx = 0;
                        });
                      },
                    ),
                    TextButton(
                      child: Icon(Icons.exit_to_app),
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.white),
                      onPressed: () async {
                        await _auth.signOut();
                      },
                    ),
                  ],
                ),
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
                          icon: Icon(Icons.settings), label: 'Setting'),
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
