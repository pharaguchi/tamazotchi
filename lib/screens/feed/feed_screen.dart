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
  String filter = '';

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final AuthService _auth = AuthService();
  late User _user;
  late Function setNavBarIdx;
  String filter = '';
  late final DatabaseService databaseService;

  setFilter(filterName) {
    setState(() {
      filter = filterName;
    });
  }

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
      spacing: 4.0,
      runSpacing: 8.0,
      children: [
        TextBubble(
          childWidget: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              minimumSize: MaterialStateProperty.all(Size.zero),
            ),
            onPressed: () async => {
              setFilter(''),
            },
            child: Text(
              'All',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
        TextBubble(
            childWidget: TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                minimumSize: MaterialStateProperty.all(Size.zero),
              ),
              onPressed: () async => {
                setFilter('Sustainable Transportation'),
              },
              child: Text(
                'Sustainable Transportation',
                style: TextStyle(fontSize: 12),
              ),
            ),
            containerColor: const Color.fromARGB(255, 165, 222, 170)),
        TextBubble(
          childWidget: TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                minimumSize: MaterialStateProperty.all(Size.zero),
              ),
              onPressed: () async => {
                    setFilter('Reusable Waterbottle'),
                  },
              child: Text(
                'Reusable Waterbottle',
                style: TextStyle(fontSize: 12),
              )),
        ),
        TextBubble(
          childWidget: TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                minimumSize: MaterialStateProperty.all(Size.zero),
              ),
              onPressed: () async => {
                    setFilter('Energy Conservation'),
                  },
              child: Text(
                'Energy Conservation',
                style: TextStyle(fontSize: 12),
              )),
        ),
        TextBubble(
          childWidget: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              minimumSize: MaterialStateProperty.all(Size.zero),
            ),
            onPressed: () async => {
              setFilter('Waste Reduction'),
            },
            child: Text('Waste Reduction', style: TextStyle(fontSize: 12)),
          ),
        ),
        TextBubble(
          childWidget: TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                minimumSize: MaterialStateProperty.all(Size.zero),
              ),
              onPressed: () async => {
                    setFilter('Conscious Conservation'),
                  },
              child: Text(
                'Conscious Conservation',
                style: TextStyle(fontSize: 12),
              )),
        ),
        TextBubble(
          childWidget: TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                minimumSize: MaterialStateProperty.all(Size.zero),
              ),
              onPressed: () async => {
                    setFilter('Community Engagement'),
                  },
              child: Text(
                'Community Engagement',
                style: TextStyle(fontSize: 12),
              )),
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
              IconButton(
                onPressed: () async => {
                  await DatabaseService()
                      .updatePostsData(addLike: false, flagged: true),
                },
                icon: Icon(
                  size: 30,
                  Icons.flag_outlined,
                  color: Colors.black,
                ),
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
            style: TextStyle(fontSize: 16),
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
              childWidget: SizedBox(
                  height: 200,
                  child: Image.asset(image != '' ? image : 'trail.jpg')),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Row(children: [
            IconButton(
              onPressed: () async => {
                await DatabaseService()
                    .updatePostsData(addLike: true, flagged: false),
              },
              icon: Icon(Icons.favorite_border, size: 20, color: Colors.black),
            ),
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
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
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
                              child: IconButton(
                                onPressed: () async => {
                                  await DatabaseService().createPost(
                                      _user.name,
                                      'Title',
                                      'Description',
                                      'Reusable Waterbottle', //'Category',
                                      '',
                                      0,
                                      false,
                                      DateTime.now()),
                                },
                                icon: Icon(
                                  size: 30,
                                  Icons.note_add_outlined,
                                  color: Colors.black,
                                ),
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
                        Wrap(
                          runSpacing: 16.0,
                          children: postInfos
                              .where((post) =>
                                  filter == '' || post.category == filter)
                              .map((post) {
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
            return SizedBox(height: 0);
          }
        });
  }
}
