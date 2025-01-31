import 'package:flutter/material.dart';
import 'package:tamazotchi/models/user.dart'; // User model
import 'package:tamazotchi/services/database.dart'; // Import DatabaseService

class FriendsPage extends StatefulWidget {
  final User user;

  FriendsPage({Key? key, required this.user}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  late DatabaseService _databaseService;
  final TextEditingController _friendCodeController =
      TextEditingController(); // Controller for the input field
  final Map<String, String> _usernameCache = {}; // Cache for usernames

  @override
  void initState() {
    super.initState();
    _databaseService = DatabaseService(uid: widget.user.uid);
  }

  // Fetch username based on friendId
  Future<String> _fetchUsernameFromFriendId(String friendId) async {
    if (_usernameCache.containsKey(friendId)) {
      return _usernameCache[friendId]!;
    }
    try {
      final username =
          await _databaseService.getUsernameFromFriendCode(friendId);
      setState(() {
        _usernameCache[friendId] = username;
      });
      return username;
    } catch (e) {
      return 'Unknown User';
    }
  }

  // Fetch username based on UUID
  Future<String> _fetchUsernameFromUUID(String uuid) async {
    if (_usernameCache.containsKey(uuid)) {
      return _usernameCache[uuid]!;
    }
    try {
      final snapshot = await _databaseService.userCollection.doc(uuid).get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final username = data['name'] ?? data['friendId'] ?? 'Unknown User';
        setState(() {
          _usernameCache[uuid] = username;
        });
        return username;
      } else {
        return 'Unknown User';
      }
    } catch (e) {
      return 'Unknown User';
    }
  }

  // Function to send a friend request
  void _sendFriendRequest() async {
    final friendCode = _friendCodeController.text.trim();

    if (friendCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter a valid friend code.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    try {
      await _databaseService.sendFriendRequest(friendCode);
      setState(() {
        widget.user.sentRequests.add(friendCode);
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Friend request sent to $friendCode'),
        backgroundColor: Colors.green,
      ));

      _friendCodeController
          .clear(); // Clear the input field after sending the request
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.toString()}'),
        backgroundColor: Colors.red,
      ));
    }
  }

  // Function to accept a friend request
  void _acceptFriendRequest(String senderUid) async {
    try {
      await _databaseService.acceptFriendRequest(senderUid);
      setState(() {
        widget.user.friends.add(senderUid);
        widget.user.receivedRequests.remove(senderUid);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Friend request accepted from $senderUid'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.toString()}'),
      ));
    }
  }

  // Function to decline a friend request
  void _declineFriendRequest(String senderUid) async {
    try {
      await _databaseService.declineFriendRequest(senderUid);
      setState(() {
        widget.user.receivedRequests.remove(senderUid);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Friend request declined from $senderUid'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.toString()}'),
      ));
    }
  }

  // Function to remove a friend
  void _removeFriend(String friendUid) async {
    try {
      await _databaseService.removeFriend(friendUid);
      setState(() {
        widget.user.friends.remove(friendUid);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Unfriended $friendUid'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.toString()}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> friends = widget.user.friends; // List of UUIDs
    List<String> sentRequests = widget.user.sentRequests; // List of friendIds
    List<String> receivedRequests =
        widget.user.receivedRequests; // List of UUIDs

    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the user's personal code (UID)
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.account_circle, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your Friend ID: ${widget.user.friendId}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Friend request input field
            TextField(
              controller: _friendCodeController,
              decoration: InputDecoration(
                labelText: 'Enter Friend\'s Friend ID',
                hintText: 'Friend\'s Friend ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            // Send friend request button
            ElevatedButton(
              onPressed: _sendFriendRequest,
              child: Text('Send Friend Request'),
            ),
            SizedBox(height: 20),

            // Display Pending Friend Requests
            if (receivedRequests.isNotEmpty) ...[
              Text(
                "Received Friend Requests",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: receivedRequests.length,
                  itemBuilder: (context, index) {
                    String uuid = receivedRequests[index];
                    return FutureBuilder<String>(
                      future: _fetchUsernameFromUUID(uuid),
                      builder: (context, snapshot) {
                        final username = snapshot.data ?? 'Loading...';
                        return ListTile(
                          title: Text(username), // Display username or fallback
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check, color: Colors.green),
                                onPressed: () => _acceptFriendRequest(uuid),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: () => _declineFriendRequest(uuid),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],

            // Display Sent Friend Requests
            if (sentRequests.isNotEmpty) ...[
              Text(
                "Sent Friend Requests",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: sentRequests.length,
                  itemBuilder: (context, index) {
                    String friendId = sentRequests[index];
                    return FutureBuilder<String>(
                      future: _fetchUsernameFromFriendId(friendId),
                      builder: (context, snapshot) {
                        final username = snapshot.data ?? 'Loading...';
                        return ListTile(
                          title: Text(username), // Display username or friendId
                          trailing: IconButton(
                            icon: Icon(Icons.cancel, color: Colors.orange),
                            onPressed: () async {
                              await _databaseService
                                  .cancelFriendRequest(friendId);
                              setState(() {
                                widget.user.sentRequests.remove(friendId);
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    'Canceled friend request to $username'),
                              ));
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],

            // Display Friends List
            if (friends.isNotEmpty) ...[
              Text(
                "Friends",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    String uuid = friends[index];
                    return FutureBuilder<String>(
                      future: _fetchUsernameFromUUID(uuid),
                      builder: (context, snapshot) {
                        final username = snapshot.data ?? 'Loading...';
                        return ListTile(
                          title: Text(username), // Display username or fallback
                          trailing: IconButton(
                            icon: Icon(Icons.remove_circle_outline,
                                color: Colors.red),
                            onPressed: () async {
                              await _databaseService.removeFriend(uuid);
                              setState(() {
                                widget.user.friends.remove(uuid);
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    Text('Removed $username from friends.'),
                              ));
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],

            // If no friends, requests, or sent requests
            if (friends.isEmpty &&
                sentRequests.isEmpty &&
                receivedRequests.isEmpty)
              Center(
                child: Text("No friends or requests."),
              ),
          ],
        ),
      ),
    );
  }
}
