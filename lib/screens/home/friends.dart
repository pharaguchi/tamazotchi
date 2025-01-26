import 'package:flutter/material.dart';
import 'package:tamazotchi/models/user.dart'; // Import User model

class FriendsPage extends StatefulWidget {
  final User user;

  FriendsPage({Key? key, required this.user}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {

  // Function to send a friend request
  void _sendFriendRequest(String friendId) {
    setState(() {
      widget.user.sentRequests.add(friendId); // Add to sent requests
    });
    // Call to backend here to update the sentRequests field
  }

  // Function to accept a friend request
  void _acceptFriendRequest(String friendId) {
    setState(() {
      widget.user.receivedRequests.remove(friendId); // Remove from received
      widget.user.friends.add(friendId); // Add to friends
    });
    // Call to backend here to update receivedRequests and friends fields
  }

  // Function to reject a friend request
  void _rejectFriendRequest(String friendId) {
    setState(() {
      widget.user.receivedRequests.remove(friendId); // Remove from received
    });
    // Call to backend here to update receivedRequests
  }

  // Function to remove a friend
  void _removeFriend(String friendId) {
    setState(() {
      widget.user.friends.remove(friendId); // Remove from friends
    });
    // Call to backend here to update friends field
  }

  @override
  Widget build(BuildContext context) {
    List<String> friends = widget.user.friends;
    List<String> sentRequests = widget.user.sentRequests;
    List<String> receivedRequests = widget.user.receivedRequests;

    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    String friendId = receivedRequests[index];
                    return ListTile(
                      title: Text(friendId), // Display friendId (you may want to show the name instead)
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.check, color: Colors.green),
                            onPressed: () => _acceptFriendRequest(friendId),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.red),
                            onPressed: () => _rejectFriendRequest(friendId),
                          ),
                        ],
                      ),
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
                    return ListTile(
                      title: Text(friendId),
                      trailing: IconButton(
                        icon: Icon(Icons.cancel, color: Colors.orange),
                        onPressed: () {
                          // Cancel sent friend request (for example)
                          setState(() {
                            widget.user.sentRequests.remove(friendId);
                          });
                          // Call backend to remove sent request
                        },
                      ),
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
                    String friendId = friends[index];
                    return ListTile(
                      title: Text(friendId), // Display friendId (you may want to show the name instead)
                      trailing: IconButton(
                        icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                        onPressed: () => _removeFriend(friendId),
                      ),
                    );
                  },
                ),
              ),
            ],
            // If no friends, requests, or sent requests
            if (friends.isEmpty && sentRequests.isEmpty && receivedRequests.isEmpty)
              Center(
                child: Text("No friends or requests."),
              ),
          ],
        ),
      ),
    );
  }
}
