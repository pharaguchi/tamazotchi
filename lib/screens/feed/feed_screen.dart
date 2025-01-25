import 'package:flutter/material.dart';
import 'package:tamazotchi/components/rounded_rectangle.dart';
import 'package:tamazotchi/models/user.dart';
import 'package:tamazotchi/services/auth.dart';
import 'package:tamazotchi/components/text_bubble.dart';

class FeedScreen extends StatefulWidget {
  FeedScreen({Key? key, required User user, required Function setNavBarIdx})
      : _user = user,
        setNavBarIdx = setNavBarIdx,
        super(key: key);

  final User _user;
  final Function setNavBarIdx;

  @override
  State<FeedScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<FeedScreen> {
  final AuthService _auth = AuthService();
  late User _user;
  late Function setNavBarIdx;

  @override
  void initState() {
    _user = widget._user;
    setNavBarIdx = widget.setNavBarIdx;

    super.initState();
  }

  Widget get FilterOptions {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        TextBubble(
            childWidget: Text(
              'Sustainable Transportation',
              style: TextStyle(fontSize: 12),
            ),
            containerColor: const Color.fromARGB(255, 165, 222, 170)),
        TextBubble(
          childWidget: Text(
            'Reusable Waterbottle',
            style: TextStyle(fontSize: 12),
          ),
        ),
        TextBubble(
          childWidget: Text(
            'Energy Conservation',
            style: TextStyle(fontSize: 12),
          ),
        ),
        TextBubble(
          childWidget: Text(
            'Waste Reduction',
            style: TextStyle(fontSize: 12),
          ),
        ),
        TextBubble(
          childWidget: Text(
            'Conscious Conservation',
            style: TextStyle(fontSize: 12),
          ),
        ),
        TextBubble(
          childWidget: Text(
            'Community Engagement',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget get Post {
    return RoundedRectangle(
      childWidget: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('User',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  )),
              Icon(
                size: 30,
                Icons.flag_outlined,
                color: Colors.black,
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec efficitur, enim ut fringilla fringilla, enim ligula finibus enim, in finibus enim enim ut enim.',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            '#Sustainable Transportation.',
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(
            height: 4,
          ),
          Center(
            child: RoundedRectangle(
                childWidget: SizedBox(
                    height: 200, child: Image.asset('assets/images/earth.png')),
                containerColor: const Color.fromARGB(255, 195, 228, 235)),
          ),
          SizedBox(
            height: 8,
          ),
          Row(children: [
            Icon(Icons.favorite_border, size: 20, color: Colors.black),
            SizedBox(
              width: 4,
            ),
            Text('25 likes',
                style: TextStyle(fontSize: 15, color: Colors.black)),
          ])
        ]),
      ),
      containerColor: const Color(0xFFD2C3B3),
    );
  }

  Widget get Posts {
    return Wrap(
      spacing: 8.0,
      runSpacing: 16.0,
      children: [Post, Post, Post],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
        height: 16,
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text('Feed',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                      )),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    size: 30,
                    Icons.note_add_outlined,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            FilterOptions,
            SizedBox(
              height: 16,
            ),
            Posts,
            SizedBox(
              height: 16,
            ),
          ]))
    ]);
  }
}
