import 'package:flutter/material.dart';

import '../../data/services/firebase_auth.dart';
import '../core/ui/auth_builder.dart';
import '../drawer/drawer.dart';
import 'myuser/myuser_views.dart';
import 'myuser/myuser_input_form_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int userCount = 0;
  bool toggleView = false;
  final showFab = ValueNotifier<bool>(true);

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
                showFab.value = true;
                toggleView = !toggleView;
              });
            },
            icon: Icon(toggleView ? Icons.list : Icons.grid_4x4_outlined),
          )
        ],
      ),
      drawer: const MyDrawer(),
      body: buildDataView(),
      floatingActionButton: buildFab(),
    );
  }

  Widget buildFab() {
    final fab = ValueListenableBuilder(
      valueListenable: showFab,
      builder: (context, value, child) => AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: showFab.value ? Offset.zero : const Offset(0, 2),
        child: FloatingActionButton(
          onPressed: () {
            if (AuthService.signedOut) return;

            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const MyUserUserFormPage(),
            ));
          },
          tooltip: 'Add user',
          child: const Icon(Icons.add),
        ),
      ),
    );

    return AuthStateChangesBuilder(
      signedInBuilder: (p0) => fab,
      signedOutBuilder: (p0) => Container(),
    );
  }

  Widget buildDataView() {
    // ignore: prefer_const_constructors
    Widget view = toggleView ? MyUserGridView() : MyUserListView();

    // listen to scroll position in order to hide/show FAB button
    view = NotificationListener<ScrollEndNotification>(
      onNotification: (scrollEnd) {
        final metrics = scrollEnd.metrics;
        if (metrics.atEdge) {
          bool isTop = metrics.pixels == 0;
          if (isTop) {
            debugPrint('At the top');
            showFab.value = true;
          } else {
            debugPrint('At the bottom');
            showFab.value = false;
          }
        } else if (showFab.value == false) {
          showFab.value = true;
        }
        return true;
      },
      child: view,
    );

    return AuthStateChangesBuilder(
      signedInBuilder: (_) => view,
      signedOutBuilder: (_) => Text(
        'Please log in to view data',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}
