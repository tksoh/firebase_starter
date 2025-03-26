import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import '../models/doc_time.dart';

class User {
  User({required this.name, required this.age});

  final String name;
  final int age;
  final docTime = FirestoreDocumentTime();

  User copyWith({String? name, int? age}) {
    final newdata = User(name: name ?? this.name, age: age ?? this.age)
      ..docTime.copyFrom(docTime);
    return newdata;
  }

  User.fromJson(Map<String, Object?> json)
      : name = json['name']! as String,
        age = json['age']! as int {
    docTime.fromJson(json);
  }

  Map<String, Object?> toJson() {
    return {
      ...{'name': name, 'age': age},
      ...docTime.toJson(),
    };
  }

  static createData(User data) {
    final ref = FirebaseFirestore.instance.collection('users').doc();
    ref.set(data.toJson());
  }

  static deleteData(String id) {
    final ref = FirebaseFirestore.instance.collection('users').doc(id);
    ref.delete();
  }

  static updateData(String id, User newdata) {
    final ref = FirebaseFirestore.instance.collection('users').doc(id);
    ref.update(newdata.toJson());
  }
}

final usersQuery = FirebaseFirestore.instance
    .collection('users')
    .orderBy('name')
    .withConverter<User>(
      fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
      toFirestore: (user, _) => user.toJson(),
    );

class FirestoreUserListView extends StatelessWidget {
  const FirestoreUserListView({super.key});

  @override
  Widget build(BuildContext context) {
    return FirestoreListView<User>.separated(
      query: usersQuery,
      itemBuilder: (context, snapshot) {
        // Data is now typed!
        User user = snapshot.data();
        final created = user.docTime.createTime?.toDate();
        final updated = user.docTime.updateTime?.toDate();

        return ListTile(
          title: Text('${user.name} @ ${user.age}'),
          subtitle: Text('Added: $created\nUpdated:$updated'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit_outlined),
                onPressed: () {
                  final docId = snapshot.id;
                  debugPrint('updating user: id=$docId');
                  User.updateData(docId, user.copyWith(age: user.age + 1));
                },
              ),
              IconButton(
                icon: Icon(Icons.delete_outlined),
                onPressed: () {
                  final docId = snapshot.id;
                  debugPrint('deleting user: id=$docId');
                  User.deleteData(docId);
                },
              ),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }
}
