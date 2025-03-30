import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthStateChangesBuilder extends StatelessWidget {
  const AuthStateChangesBuilder({super.key, required this.itemBuilder});

  final Widget Function(BuildContext) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data!.email;
          debugPrint('Logged in as $user');
          return itemBuilder(context);
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'ERROR: ${snapshot.hasError}',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        } else {
          return Center(
            child: Text(
              'Please log in to view data',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        }
      },
    );
  }
}
