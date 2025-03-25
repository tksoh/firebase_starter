import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class User {
  User({required this.name, required this.age});

  User.fromJson(Map<String, Object?> json)
    : this(name: json['name']! as String, age: json['age']! as int);

  final String name;
  final int age;

  Map<String, Object?> toJson() {
    return {'name': name, 'age': age};
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

        return ListTile(
          title: Text(user.name),
          subtitle: Text('${user.age}'),
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
