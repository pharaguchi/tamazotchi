import 'package:flutter/material.dart';
import 'package:tamazotchi/services/auth.dart';
import 'package:tamazotchi/config/constants.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:tamazotchi/models/user.dart';
import 'package:tamazotchi/services/database.dart';
import 'package:tamazotchi/config/color_constants.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key, required User user, required Function setNavBarIdx})
      : _user = user,
        setNavBarIdx = setNavBarIdx,
        super(key: key);

  final User _user;
  final Function setNavBarIdx;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late User _user;
  late Function setNavBarIdx;

  final AuthService _auth = AuthService();
  late final DatabaseService _databaseService;

  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentIndex = 0;

  final TextEditingController _nameController = TextEditingController();

  bool _isCompany = false;

  @override
  void initState() {
    _user = widget._user;
    _databaseService = DatabaseService(uid: _user.uid);
    setNavBarIdx = widget.setNavBarIdx;
    _isCompany = _user.isCompany;

    super.initState();
  }

  void _updateProfileNotif(String displayText) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(displayText)),
    );

    // After updating, you can close the dialog or show a success message.
    // Navigator.pop(context); // Close the dialog
    if (Navigator.canPop(context)) {
      Navigator.pop(context); // Close the current screen (dialog, etc.)
    }
  }

  void _showChangeNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Change Name"),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: "Enter new name"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog without updating
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Get the new name from the controller and update
                String newName = _nameController.text;
                if (newName.isNotEmpty) {
                  await _databaseService.updateName(newName);
                  _updateProfileNotif('Name updated successfully!');
                } else {
                  // Show a message if the input is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid name')),
                  );
                }
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }

  void _toggleIsCompany() async {
    setState(() {
      _isCompany = !_isCompany;
    });
    await _databaseService.toggleIsCompany();
    _updateProfileNotif(
        _isCompany ? 'Account marked as Company' : 'Account marked as User');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Text(
            'Settings',
            style: TextStyle(fontSize: 24),
          ),
          Text(
            'Change your tamagotchi',
            style: TextStyle(fontSize: 16),
          ),
          CarouselSlider(
            items: List.generate(tamagotchiNames.length, (index) {
              return 'assets/Tamagotchi/${tamagotchiNames[index]}.webp';
            }).map((path) {
              return Image.asset(
                path,
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width,
              );
            }).toList(),
            carouselController: _carouselController,
            options: CarouselOptions(
                height: 175.0,
                autoPlay: false,
                enlargeCenterPage: false,
                aspectRatio: 1 / 1,
                initialPage: tamagotchiNames.indexOf(_user.tamagotchi),
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  _carouselController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear); // Move to the next page
                },
                icon: Icon(Icons.arrow_back),
                label: Text("Previous"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
              SizedBox(width: 15),
              ElevatedButton.icon(
                onPressed: () async {
                  // Set the user's tamagotchi to the selected one
                  await _databaseService
                      .updateTamagotchi(tamagotchiNames[_currentIndex]);
                  _updateProfileNotif('Tamagotchi updated successfully!');
                },
                label: Text("Select"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
              SizedBox(width: 15),
              ElevatedButton.icon(
                onPressed: () {
                  _carouselController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear); // Move to the next page
                },
                icon: Icon(Icons.arrow_forward),
                label: Text("Next"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      vertical: 12.0), // Adjust padding for button height
                ),
                onPressed: () async {
                  _showChangeNameDialog();
                },
                child: Text(
                  'Change Name',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0), // Add horizontal padding
            child: SizedBox(
              width:
                  double.infinity, // Make the button stretch across the screen
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      vertical: 12.0), // Adjust padding for button height
                ),
                onPressed: () async {
                  _toggleIsCompany(); // Toggle between company and user account
                },
                child: Text(
                  _isCompany
                      ? 'Switch to User Account'
                      : 'Switch to Company Account',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      vertical: 12.0), // Adjust padding for button height
                  backgroundColor: Colors.grey[800], // Subtle emphasis color
                ),
                onPressed: () async {
                  await _auth.signOut();
                },
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white), // Match text color to button
                ),
              ),
            ),
          ),
        ]);
  }
}
