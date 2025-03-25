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
    return FirestoreListView<User>(
      query: usersQuery,
      itemBuilder: (context, snapshot) {
        // Data is now typed!
        User user = snapshot.data();

        return ListTile(title: Text(user.name), subtitle: Text('${user.age}'));
      },
    );
  }
}
