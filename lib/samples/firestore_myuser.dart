import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../firework/action_listview.dart';
import '../firework/firestore_crub_helper.dart';
import '../models/doc_time.dart';

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
        final created = user.docTime.createTime?.toDate();
        final updated = user.docTime.updateTime?.toDate();
        final name = user.name;
        final age = user.age;
        return ListTile(
          title: Text('$name => $age'),
          subtitle: Text(
            'Added: $created\nUpdated: $updated',
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
      debug: true,
    );
  }
}
