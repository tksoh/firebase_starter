import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthStateChangesBuilder extends StatelessWidget {
  const AuthStateChangesBuilder({
    super.key,
    required this.signedInBuilder,
    this.signedOutBuilder,
  });

  final Widget Function(BuildContext) signedInBuilder;
  final Widget Function(BuildContext)? signedOutBuilder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data!.email;
          debugPrint('Logged in as $user');
          return signedInBuilder(context);
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'ERROR: ${snapshot.hasError}',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        } else {
          return signedOutBuilder?.call(context) ??
              Center(
                child: Text(
                  'Signed Out!',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              );
        }
      },
    );
  }
}
