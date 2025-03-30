import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'drawer.dart';
import 'firework/auth_builder.dart';
import 'samples/firestore_myuser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Starter',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Firebase Starter'),
    );
  }
}

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
          user.createData();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget dataView() {
    return AuthStateChangesBuilder(
      itemBuilder: (p0) => toggleView ? MyUserGridView() : MyUserListView(),
    );
  }
}
