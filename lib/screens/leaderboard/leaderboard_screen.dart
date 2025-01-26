import 'package:flutter/material.dart';
import 'package:tamazotchi/models/user.dart';
import 'package:tamazotchi/services/database.dart';
import 'package:tamazotchi/util.dart';

class LeaderboardScreen extends StatefulWidget {
  LeaderboardScreen(
      {Key? key, required User user, required Function setNavBarIdx})
      : _user = user,
        setNavBarIdx = setNavBarIdx,
        super(key: key);

  final User _user;
  final Function setNavBarIdx;

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late User _user;
  late Function setNavBarIdx;
  late Stream<List<User>> leaderboardStream;

  @override
  void initState() {
    _user = widget._user;
    setNavBarIdx = widget.setNavBarIdx;

    // Fetch leaderboard data from the DatabaseService
    leaderboardStream = DatabaseService().leaderboard;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Leaderboard';
    Size size = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SizedBox(
        height: size.height,
        width: size.width,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(title),
          ),
          body: StreamBuilder<List<User>>(
            stream: leaderboardStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data available'));
              }

              final leaderboard = snapshot.data!;
              return ListView.builder(
                itemCount: leaderboard.length,
                itemBuilder: (context, index) {
                  final user = leaderboard[index];
                  final tamagotchiImage = getTamagotchiImageLink(
                    user.tamagotchi.isNotEmpty ? user.tamagotchi : 'bubbletchi',
                  );
                  final rank = index + 1;

                  return ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '#$rank',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          tamagotchiImage,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Provide a fallback if the image doesn't exist
                            return const Icon(Icons.error);
                          },
                        ),
                      ],
                    ),
                    title: Text(user.name),
                    trailing: Text(
                      '${user.points} pts',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
