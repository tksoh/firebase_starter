import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreSimpleQueryBuilder<T> extends StatefulWidget {
  const FirestoreSimpleQueryBuilder({
    super.key,
    required this.query,
    required this.itemBuilder,
  });

  final Query<T> query;
  final Widget Function(
      BuildContext, AsyncSnapshot<List<QueryDocumentSnapshot<T>>>) itemBuilder;

  @override
  State<FirestoreSimpleQueryBuilder<T>> createState() =>
      _FirestoreSimpleQueryBuilderState<T>();
}

class _FirestoreSimpleQueryBuilderState<T>
    extends State<FirestoreSimpleQueryBuilder<T>> {
  late Stream<List<QueryDocumentSnapshot<T>>> stream;

  @override
  void initState() {
    stream = widget.query
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc).toList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return widget.itemBuilder(context, snapshot);
        } else {
          return Container();
        }
      },
    );
  }
}

class FirestoreSimpleGridView<T> extends StatelessWidget {
  const FirestoreSimpleGridView({
    super.key,
    required this.query,
    required this.itemBuilder,
    required this.gridDelegate,
  });

  final Query<T> query;
  final Widget Function(BuildContext, int, QueryDocumentSnapshot<T>)
      itemBuilder;
  final SliverGridDelegate gridDelegate;

  @override
  Widget build(BuildContext context) {
    return FirestoreSimpleQueryBuilder(
      query: query,
      itemBuilder: (context, snapshot) {
        final list = snapshot.data;
        return GridView.builder(
          gridDelegate: gridDelegate,
          itemCount: list?.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: itemBuilder(context, index, list![index]),
            );
          },
        );
      },
    );
  }
}

class FirestoreActionGridView<T> extends StatelessWidget {
  final Query<T> query;
  final Widget Function(BuildContext, int, T) itemBuilder;
  final void Function(String id, T data)? deleteAction;
  final void Function(String id, T data)? editAction;
  final bool debug;
  final SliverGridDelegate gridDelegate;

  const FirestoreActionGridView({
    super.key,
    required this.query,
    required this.itemBuilder,
    required this.gridDelegate,
    this.deleteAction,
    this.editAction,
    required this.debug,
  });

  @override
  Widget build(BuildContext context) {
    return FirestoreSimpleGridView(
      query: query,
      gridDelegate: gridDelegate,
      itemBuilder: (context, index, snapshot) {
        final docId = snapshot.id;
        final data = snapshot.data();

        return Column(
          children: [
            Expanded(
              child: itemBuilder(context, index, data),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (deleteAction != null)
                  IconButton(
                    onPressed: () => deleteAction?.call(docId, data),
                    icon: Icon(Icons.delete_outlined),
                  ),
                if (editAction != null)
                  IconButton(
                    onPressed: () => editAction?.call(docId, data),
                    icon: Icon(Icons.edit_outlined),
                  ),
              ],
            )
          ],
        );
      },
    );
  }
}

class FirestoreActionGridViewX0<T> extends StatefulWidget {
  final Query<T> query;
  final Widget Function(BuildContext, int, QueryDocumentSnapshot<T>)
      itemBuilder;
  final void Function(String id, T data)? deleteAction;
  final void Function(String id, T data)? editAction;
  final bool debug;
  final SliverGridDelegate gridDelegate;

  const FirestoreActionGridViewX0({
    super.key,
    required this.query,
    required this.itemBuilder,
    required this.gridDelegate,
    this.deleteAction,
    this.editAction,
    required this.debug,
  });

  @override
  State<FirestoreActionGridViewX0<T>> createState() =>
      _FirestoreActionGridViewX0State<T>();
}

class _FirestoreActionGridViewX0State<T>
    extends State<FirestoreActionGridViewX0<T>> {
  late Stream<List<QueryDocumentSnapshot<T>>> stream;

  @override
  void initState() {
    stream = widget.query.snapshots().map((queryShot) {
      return queryShot.docs.map((doc) {
        // final data = doc.data();
        // return data;
        return doc;
      }).toList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          final list = snapshot.data;

          return GridView.builder(
            gridDelegate: widget.gridDelegate,
            itemCount: list?.length,
            itemBuilder: (context, index) {
              final snap = list![index];
              final docId = snap.id;
              final data = snap.data();
              return Container(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Column(
                  children: [
                    Expanded(
                      child: widget.itemBuilder(context, index, list[index]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (widget.deleteAction != null)
                          IconButton(
                            onPressed: () =>
                                widget.deleteAction?.call(docId, data),
                            icon: Icon(Icons.delete_outlined),
                          ),
                        if (widget.editAction != null)
                          IconButton(
                            onPressed: () =>
                                widget.editAction?.call(docId, data),
                            icon: Icon(Icons.edit_outlined),
                          ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
