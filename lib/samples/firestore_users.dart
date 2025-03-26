import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreDocumentTime {
  Timestamp? updatedTime;
  Timestamp? createdTime;

  fromJson(Map<String, Object?> json) {
    updatedTime =
        json['_updateTime_'] == null ? null : json['_updateTime_'] as Timestamp;
    createdTime =
        json['_createTime_'] == null ? null : json['_createTime_'] as Timestamp;
  }

  Map<String, Object?> toJson() {
    return {
      '_updateTime_': FieldValue.serverTimestamp(),
      if (createdTime == null) '_createTime_': FieldValue.serverTimestamp(),
    };
  }
}

class User {
  User({required this.name, required this.age});

  final String name;
  final int age;
  final metaTime = FirestoreDocumentTime();

  User.fromJson(Map<String, Object?> json)
      : name = json['name']! as String,
        age = json['age']! as int {
    metaTime.fromJson(json);
  }

  Map<String, Object?> toJson() {
    return {
      ...{'name': name, 'age': age},
      ...metaTime.toJson(),
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

  updateData(String id, {String? newName, int? newAge}) {
    final newdata = User(name: newName ?? name, age: newAge ?? age);
    newdata.metaTime.createdTime = metaTime.createdTime;
    newdata.metaTime.updatedTime = metaTime.updatedTime;
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
        final created = user.metaTime.createdTime?.toDate();
        final updated = user.metaTime.updatedTime?.toDate();

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
                  user.updateData(docId, newAge: user.age + 1);
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
