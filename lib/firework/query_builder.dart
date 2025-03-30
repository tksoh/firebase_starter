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
            return itemBuilder(context, index, list![index]);
          },
        );
      },
    );
  }
}

class FirestoreSimpleListView<T> extends StatelessWidget {
  const FirestoreSimpleListView({
    super.key,
    required this.query,
    required this.itemBuilder,
    this.separatorBuilder,
  });

  final Query<T> query;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final Widget Function(BuildContext, int, QueryDocumentSnapshot<T>)
      itemBuilder;

  @override
  Widget build(BuildContext context) {
    return FirestoreSimpleQueryBuilder(
      query: query,
      itemBuilder: (context, snapshot) {
        final list = snapshot.data;
        return ListView.separated(
          itemCount: list?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return itemBuilder(context, index, list![index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return separatorBuilder?.call(context, index) ?? Container();
          },
        );
      },
    );
  }
}
