import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'query_builder.dart';

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
            ),
            if (debug) FittedBox(child: debugInfo(docId, context)),
          ],
        );
      },
    );
  }

  Widget debugInfo(String docId, BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        child: Text(
          'ID: $docId',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
