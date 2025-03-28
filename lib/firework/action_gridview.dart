import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreGridView<T> extends StatefulWidget {
  final Query<T> query;
  final Widget Function(BuildContext, int, QueryDocumentSnapshot<T>)
      itemBuilder;
  final void Function(String id, T data)? deleteAction;
  final void Function(String id, T data)? editAction;
  final bool debug;
  final SliverGridDelegate gridDelegate;

  const FirestoreGridView({
    super.key,
    required this.query,
    required this.itemBuilder,
    required this.gridDelegate,
    this.deleteAction,
    this.editAction,
    required this.debug,
  });

  @override
  State<FirestoreGridView<T>> createState() => _FirestoreGridViewState<T>();
}

class _FirestoreGridViewState<T> extends State<FirestoreGridView<T>> {
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
