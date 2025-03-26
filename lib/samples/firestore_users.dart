import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

mixin FirestoreDocument {
  late Timestamp? updatedTime;
  late Timestamp? createdTime;

  loadTime(Map<String, Object?> json) {
    updatedTime =
        json['_updated_time_'] == null
            ? null
            : json['_updated_time_'] as Timestamp;
    createdTime =
        json['_created_time_'] == null
            ? null
            : json['_created_time_'] as Timestamp;
  }

  Map<String, Object?> saveTime() {
    return {
      '_updated_time_': FieldValue.serverTimestamp(),
      '_created_time_': FieldValue.serverTimestamp(),
    };
  }
}

class User with FirestoreDocument {
  User({required this.name, required this.age});

  final String name;
  final int age;

  User.fromJson(Map<String, Object?> json)
    : name = json['name']! as String,
      age = json['age']! as int {
    loadTime(json);
  }

  Map<String, Object?> toJson() {
    return {
      ...{'name': name, 'age': age},
      ...saveTime(),
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
        final created = user.createdTime?.toDate();
        final updated = user.updatedTime?.toDate();

        return ListTile(
          title: Text('${user.name} @ ${user.age}'),
          subtitle: Text('Added: $created\nUpdated:$updated'),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              final docId = snapshot.id;
              debugPrint('deleting user: id=$docId');
              User.deleteData(docId);
            },
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }
}
