import 'package:flutter/material.dart';
import 'package:tamazotchi/components/rounded_rectangle.dart';
import 'package:tamazotchi/models/user.dart';
import 'package:tamazotchi/services/auth.dart';
import 'package:tamazotchi/services/database.dart';
import 'package:tamazotchi/components/text_bubble.dart';
import 'package:tamazotchi/models/post.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

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
  String form_title = '';
  String form_description = '';
  String form_category = '';
  late final DatabaseService databaseService;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

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
      required int flagged}) {
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
                      .updatePostsData(addLike: false, addFlagged: true),
                },
                icon: Icon(
                  size: 30,
                  Icons.flag_outlined,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Center(
            child: RoundedRectangle(
              childWidget: SizedBox(child: Image.asset('trail.jpg')),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Row(children: [
            IconButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                minimumSize: MaterialStateProperty.all(Size.zero),
              ),
              onPressed: () async => {
                await DatabaseService()
                    .updatePostsData(addLike: true, addFlagged: false),
              },
              icon: Icon(Icons.favorite_border, size: 20, color: Colors.black),
            ),
            SizedBox(
              width: 4,
            ),
            Text(likes.toString() + ' likes',
                style: TextStyle(fontSize: 15, color: Colors.black)),
          ]),
          SizedBox(
            height: 4,
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: name, // Bold the name
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' ' + description, // Keep description in normal weight
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
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
        ]),
      ),
      containerColor: const Color(0xFFD2C3B3),
    );
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
    print(_image?.path);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Post>>(
        stream: databaseService.post,
        builder: (context, postSnapshot) {
          List<Post> postInfos = postSnapshot.data ?? [];

          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                            onPressed: () async {
                              await showDialog<void>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        content: Stack(
                                          clipBehavior: Clip.none,
                                          children: <Widget>[
                                            Positioned(
                                              right: -40,
                                              top: -40,
                                              child: InkResponse(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const CircleAvatar(
                                                  child: Icon(Icons.close),
                                                ),
                                              ),
                                            ),
                                            Form(
                                              key: _formKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text("Create a post!",
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: TextFormField(
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'Title',
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          form_title = value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: TextFormField(
                                                      maxLines: 5,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      scrollPhysics:
                                                          BouncingScrollPhysics(),
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'Description',
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          form_description =
                                                              value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'Category',
                                                      ),
                                                      items: [
                                                        DropdownMenuItem(
                                                          value: '',
                                                          child: Text('All'),
                                                        ),
                                                        DropdownMenuItem(
                                                          value:
                                                              'Sustainable Transportation',
                                                          child: Text(
                                                              'Sustainable Transportation'),
                                                        ),
                                                        DropdownMenuItem(
                                                          value:
                                                              'Reusable Waterbottle',
                                                          child: Text(
                                                              'Reusable Waterbottle'),
                                                        ),
                                                        DropdownMenuItem(
                                                          value:
                                                              'Energy Conservation',
                                                          child: Text(
                                                              'Energy Conservation'),
                                                        ),
                                                        DropdownMenuItem(
                                                          value:
                                                              'Waste Reduction',
                                                          child: Text(
                                                              'Waste Reduction'),
                                                        ),
                                                        DropdownMenuItem(
                                                          value:
                                                              'Conscious Conservation',
                                                          child: Text(
                                                              'Conscious Conservation'),
                                                        ),
                                                        DropdownMenuItem(
                                                          value:
                                                              'Community Engagement',
                                                          child: Text(
                                                              'Community Engagement'),
                                                        ),
                                                      ],
                                                      onChanged: (value) {
                                                        setState(() {
                                                          form_category =
                                                              value!;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        TextButton(
                                                            onPressed:
                                                                _pickImage,
                                                            child: Text(
                                                                'Upload Image'))
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: ElevatedButton(
                                                      child:
                                                          const Text('Submit'),
                                                      onPressed: () async {
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          await DatabaseService()
                                                              .postsCollection
                                                              .add({
                                                            'name': _user.name,
                                                            'title': form_title,
                                                            'description':
                                                                form_description,
                                                            'category':
                                                                form_category,
                                                            'image':
                                                                'trail.jpg',
                                                            'likes': 0,
                                                            'flagged': 0,
                                                            'date':
                                                                DateTime.now(),
                                                            'uid': _user.uid,
                                                          });
                                                          _formKey.currentState!
                                                              .save();
                                                        }
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ));
                            },
                            icon: Icon(
                              size: 30,
                              Icons.note_add_outlined,
                              color: Colors.black,
                            ),
                          )),
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
                        .where(
                            (post) => filter == '' || post.category == filter)
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
        });
  }
}
