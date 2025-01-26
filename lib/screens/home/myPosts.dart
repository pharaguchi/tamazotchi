import 'package:flutter/material.dart';
import 'package:tamazotchi/components/rounded_rectangle.dart';
import 'package:tamazotchi/models/user.dart';
import 'package:tamazotchi/services/database.dart';
import 'package:tamazotchi/components/text_bubble.dart';
import 'package:tamazotchi/models/post.dart';
import 'package:image_picker/image_picker.dart';

class UserPostsScreen extends StatefulWidget {
  final User user;

  const UserPostsScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<UserPostsScreen> createState() => _UserPostsScreenState();
}

class _UserPostsScreenState extends State<UserPostsScreen> {
  late DatabaseService _databaseService;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String _filter = '';
  String _formTitle = '';
  String _formDescription = '';
  String _formCategory = '';
  XFile? _image;

  @override
  void initState() {
    super.initState();
    _databaseService = DatabaseService(uid: widget.user.uid);
  }

  void _setFilter(String filter) {
    setState(() {
      _filter = filter;
    });
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  void _showCreatePostDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create a Post"),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(hintText: 'Title'),
                  onChanged: (value) => setState(() {
                    _formTitle = value;
                  }),
                ),
                SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Description'),
                  maxLines: 4,
                  onChanged: (value) => setState(() {
                    _formDescription = value;
                  }),
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(hintText: 'Category'),
                  items: const [
                    DropdownMenuItem(value: '', child: Text('All')),
                    DropdownMenuItem(
                        value: 'Sustainable Transportation',
                        child: Text('Sustainable Transportation')),
                    DropdownMenuItem(
                        value: 'Reusable Waterbottle',
                        child: Text('Reusable Waterbottle')),
                    DropdownMenuItem(
                        value: 'Energy Conservation',
                        child: Text('Energy Conservation')),
                    DropdownMenuItem(
                        value: 'Waste Reduction',
                        child: Text('Waste Reduction')),
                    DropdownMenuItem(
                        value: 'Conscious Conservation',
                        child: Text('Conscious Conservation')),
                    DropdownMenuItem(
                        value: 'Community Engagement',
                        child: Text('Community Engagement')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _formCategory = value ?? '';
                    });
                  },
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: _pickImage,
                  child: Text('Upload Image'),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _databaseService.postsCollection.add({
                        'name': widget.user.name,
                        'title': _formTitle,
                        'description': _formDescription,
                        'category': _formCategory,
                        'image': _image?.path ?? 'default_image_path',
                        'likes': 0,
                        'flagged': 0,
                        'date': DateTime.now(),
                        'uid': widget.user.uid,
                      });
                      // Clear form fields after submission
                      setState(() {
                        _formTitle = '';
                        _formDescription = '';
                        _formCategory = '';
                        _image = null;
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOptions() {
    const categories = [
      'All',
      'Sustainable Transportation',
      'Reusable Waterbottle',
      'Energy Conservation',
      'Waste Reduction',
      'Conscious Conservation',
      'Community Engagement',
    ];

    return Wrap(
      spacing: 4.0,
      runSpacing: 8.0,
      children: categories.map((category) {
        return TextBubble(
          childWidget: TextButton(
            onPressed: () => _setFilter(category == 'All' ? '' : category),
            child: Text(category, style: TextStyle(fontSize: 12)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPostTemplate(Post post) {
    return RoundedRectangle(
      childWidget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(post.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          if (post.image.isNotEmpty) Center(child: Image.network(post.image)),
          SizedBox(height: 8),
          Text(post.description),
          SizedBox(height: 8),
          Text('#${post.category}', style: TextStyle(fontSize: 12)),
        ]),
      ),
      containerColor: const Color(0xFFD2C3B3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Post>>(
      stream: _databaseService.post,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final userPosts = snapshot.data!
            .where((post) =>
                post.uid == widget.user.uid &&
                (_filter.isEmpty || post.category == _filter))
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));

        return Scaffold(
          appBar: AppBar(
            title: Text('${widget.user.name}\'s Posts'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildFilterOptions(),
                SizedBox(height: 16),
                Expanded(
                  child: userPosts.isEmpty
                      ? Center(child: Text('No posts to display.'))
                      : ListView.builder(
                          itemCount: userPosts.length,
                          itemBuilder: (context, index) {
                            return _buildPostTemplate(userPosts[index]);
                          },
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showCreatePostDialog,
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
