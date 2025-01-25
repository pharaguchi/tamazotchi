import 'package:tamazotchi/components/loading.dart';
import 'package:tamazotchi/models/user.dart';
import 'package:tamazotchi/screens/authenticate/authenticate.dart';
import 'package:tamazotchi/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tamazotchi/services/database.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      return Loading();
    } else {
      if (user.uid.isEmpty) {
        return Authenticate();
      } else {
        final databaseService = DatabaseService(uid: user.uid);
        return Home(
          user: user,
          databaseService: databaseService,
        );
      }
    }
  }
}
