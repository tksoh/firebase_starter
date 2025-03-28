// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import '../models/doc_time.dart';

abstract class DocumentBase {
  String get collectionPath;

  Map<String, Object?> toJson();
}

mixin FirestoreCRUD on DocumentBase {
  void createData() {
    final ref = FirebaseFirestore.instance.collection(collectionPath).doc();
    ref.set(toJson());
  }

  void deleteData(String id) {
    final ref = FirebaseFirestore.instance.collection(collectionPath).doc(id);
    ref.delete();
  }

  void updateData(String id) {
    final ref = FirebaseFirestore.instance.collection(collectionPath).doc(id);
    ref.update(toJson());
  }
}

class MyUser extends DocumentBase with FirestoreCRUD {
  static String collection = "my-collection";

  // user data
  final String name;
  final int age;

  final docTime = FirestoreDocumentTime();

  MyUser({required this.name, required this.age});

  @override
  String get collectionPath => collection;

  @override
  Map<String, Object?> toJson() {
    return {
      ...{'name': name, 'age': age},
      ...docTime.toJson(),
    };
  }

  MyUser.fromJson(Map<String, Object?> json, {String? id})
      : name = json['name']! as String,
        age = json['age']! as int {
    docTime.fromJson(json);
  }

  MyUser copyWith({String? name, int? age}) {
    return MyUser(
      name: name ?? this.name,
      age: age ?? this.age,
    )..docTime.copyFrom(docTime);
  }
}

final myQuery = FirebaseFirestore.instance
    .collection(MyUser.collection)
    .orderBy('name')
    .withConverter<MyUser>(
      fromFirestore: (snapshot, _) =>
          MyUser.fromJson(snapshot.data()!, id: snapshot.id),
      toFirestore: (user, _) => user.toJson(),
    );

class MyUserListView extends StatelessWidget {
  const MyUserListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ActionListView<MyUser>(
      query: myQuery,
      itemBuilder: (context, snapshot) {
        final user = snapshot.data();
        final docId = snapshot.id;
        final created = user.docTime.createTime?.toDate();
        final updated = user.docTime.updateTime?.toDate();
        final name = user.name;
        final age = user.age;
        return ListTile(
          title: Text('$name => $age'),
          subtitle: Text(
            'Added: $created\nUpdated: $updated\nID: $docId',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      },
      deleteAction: (id, data) {
        debugPrint('deleting user: id=$id');
        data.deleteData(id);
      },
      editAction: (id, data) {
        debugPrint('updating user: id=$id');
        final newuser = data.copyWith(age: data.age + 1);
        newuser.updateData(id);
      },
    );
  }
}

class ActionListView<T> extends StatefulWidget {
  final Query<T> query;
  final Widget Function(BuildContext, QueryDocumentSnapshot<T>) itemBuilder;
  final void Function(String id, T data)? deleteAction;
  final void Function(String id, T data)? editAction;

  const ActionListView({
    super.key,
    required this.query,
    required this.itemBuilder,
    this.deleteAction,
    this.editAction,
  });

  @override
  State<ActionListView<T>> createState() => _ActionListViewState<T>();
}

class _ActionListViewState<T> extends State<ActionListView<T>> {
  @override
  Widget build(BuildContext context) {
    return FirestoreListView<T>.separated(
      query: widget.query,
      itemBuilder: (context, snapshot) {
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
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }
}
