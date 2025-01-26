import 'package:flutter/material.dart';
import 'package:tamazotchi/components/rounded_rectangle.dart';
import 'package:tamazotchi/models/user.dart';
import 'package:tamazotchi/services/auth.dart';
import 'package:tamazotchi/services/database.dart';
import 'package:tamazotchi/components/text_bubble.dart';
import 'package:tamazotchi/models/post.dart';

class FeedScreen extends StatefulWidget {
  FeedScreen({Key? key, required User user, required Function setNavBarIdx})
      : _user = user,
        setNavBarIdx = setNavBarIdx,
        super(key: key);

  final User _user;
  final Function setNavBarIdx;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final AuthService _auth = AuthService();
  late User _user;
  late Function setNavBarIdx;
  late final DatabaseService databaseService;

  @override
  void initState() {
    _user = widget._user;
    setNavBarIdx = widget.setNavBarIdx;
    databaseService = DatabaseService(
      uid: _user.uid,
    );

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

  Widget PostTemplate(
      {required DateTime date,
      required String name,
      required String title,
      required String description,
      required String category,
      required String image,
      required int likes,
      required bool flagged}) {
    return RoundedRectangle(
      childWidget: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
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
          Text(
            'by ' + name,
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            description,
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '#' + category,
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(
            height: 5,
          ),
          Center(
            child: RoundedRectangle(
              childWidget: SizedBox(height: 200, child: Image.asset(image)),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Row(children: [
            Icon(Icons.favorite_border, size: 20, color: Colors.black),
            SizedBox(
              width: 4,
            ),
            Text(likes.toString() + ' likes',
                style: TextStyle(fontSize: 15, color: Colors.black)),
          ])
        ]),
      ),
      containerColor: const Color(0xFFD2C3B3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Post>>(
        stream: databaseService.post,
        builder: (context, postSnapshot) {
          if (postSnapshot.hasData) {
            List<Post> postInfos = postSnapshot.data!;

            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                        Column(
                          children: postInfos.map((post) {
                            return PostTemplate(
                              date: post.date,
                              name: post.name,
                              title: post.title,
                              description: post.description,
                              category: post.category,
                              image: post.image,
                              likes: post.likes,
                              flagged: post.flagged,
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ]))
                ]);
          } else {
            // return SizedBox(height: 0);
            return Text('NONE FOUND');
          }
        });
  }
}
