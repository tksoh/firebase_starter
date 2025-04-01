import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class SignInDrawerTile extends StatefulWidget {
  const SignInDrawerTile({super.key});

  @override
  State<SignInDrawerTile> createState() => _SignInDrawerTileState();
}

class _SignInDrawerTileState extends State<SignInDrawerTile> {
  @override
  Widget build(BuildContext context) {
    final name = FirebaseAuth.instance.currentUser == null
        ? 'Logged out'
        : FirebaseAuth.instance.currentUser!.displayName;

    final providers = [EmailAuthProvider()];

    final signInPage = SignInScreen(
      providers: providers,
      actions: [
        AuthStateChangeAction<UserCreated>((context, state) {
          // Put any new user logic here
          Navigator.pop(context);
        }),
        AuthStateChangeAction<SignedIn>((context, state) {
          Navigator.pop(context);
        }),
      ],
    );

    final profilePage = ProfileScreen(
      providers: providers,
      actions: [
        SignedOutAction((context) {
          Navigator.pop(context);
        }),
      ],
      showDeleteConfirmationDialog: true,
      showUnlinkConfirmationDialog: true,
    );

    return ListTile(
      leading: Icon(Icons.person),
      title: Text(name!),
      subtitle: Text(
        FirebaseAuth.instance.currentUser == null ? 'Log in' : 'View profile',
        style: TextStyle(decoration: TextDecoration.underline),
      ),
      onTap: () {
        Navigator.pop(context); // close drawer
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FirebaseAuth.instance.currentUser == null
                ? signInPage
                : profilePage,
          ),
        );
      },
    );
  }
}
