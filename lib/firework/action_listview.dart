import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'query_builder.dart';

class ActionListView<T> extends StatefulWidget {
  final Query<T> query;
  final Widget Function(BuildContext, QueryDocumentSnapshot<T>) itemBuilder;
  final void Function(String id, T data)? deleteAction;
  final void Function(String id, T data)? editAction;
  final bool debug;

  const ActionListView({
    super.key,
    required this.query,
    required this.itemBuilder,
    this.deleteAction,
    this.editAction,
    this.debug = false,
  });

  @override
  State<ActionListView<T>> createState() => _ActionListViewState<T>();
}

class _ActionListViewState<T> extends State<ActionListView<T>> {
  @override
  Widget build(BuildContext context) {
    return FirestoreSimpleListView<T>(
      query: widget.query,
      itemBuilder: (context, index, snapshot) {
        T data = snapshot.data();
        final docId = snapshot.id;

        var actionButtons = Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.delete_outlined),
              onPressed: () => widget.deleteAction?.call(docId, data),
            ),
            IconButton(
              icon: Icon(Icons.edit_outlined),
              onPressed: () => widget.editAction?.call(docId, data),
            ),
          ],
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.itemBuilder(context, snapshot),
            actionButtons,
            if (widget.debug) debugInfo(docId, context),
          ],
        );
      },
      separatorBuilder: (_, index) => Divider(),
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
