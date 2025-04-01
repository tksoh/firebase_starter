import 'package:flutter/material.dart';

import '/firework/ui/auth_builder.dart';
import '/drawer/drawer.dart';
import 'myuser/myuser_models.dart';
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
      drawer: MyDrawer(),
      body: dataView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          userCount++;
          final user = MyUser(name: 'user $userCount', age: 10 + userCount);
          user.createDocument();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget dataView() {
    return AuthStateChangesBuilder(
      signedInBuilder: (_) => toggleView ? MyUserGridView() : MyUserListView(),
      signedOutBuilder: (_) => Text(
        'Please log in to view data',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}
