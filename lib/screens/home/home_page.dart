import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_starter/screens/myuser_add_user/myuser_add_user_view.dart';
import 'package:flutter/material.dart';

import '/firework/views/auth_builder.dart';
import '/drawer/drawer.dart';
import 'myuser/myuser_views.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int userCount = 0;
  bool toggleView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                toggleView = !toggleView;
              });
            },
            icon: Icon(toggleView ? Icons.list : Icons.grid_4x4_outlined),
          )
        ],
      ),
      drawer: const MyDrawer(),
      body: dataView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (FirebaseAuth.instance.currentUser == null) return;

          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const MyUserUserFormPage(),
          ));
        },
        tooltip: 'Add user',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget dataView() {
    return AuthStateChangesBuilder(
      // ignore: prefer_const_constructors
      signedInBuilder: (_) => toggleView ? MyUserGridView() : MyUserListView(),
      signedOutBuilder: (_) => Text(
        'Please log in to view data',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}
