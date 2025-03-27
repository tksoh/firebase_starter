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

class FirestoreMyListView extends StatelessWidget {
  const FirestoreMyListView({super.key});

  @override
  Widget build(BuildContext context) {
    return FirestoreListView<MyUser>.separated(
      query: myQuery,
      itemBuilder: (context, snapshot) {
        // Data is now typed!
        MyUser user = snapshot.data();
        final created = user.docTime.createTime?.toDate();
        final updated = user.docTime.updateTime?.toDate();

        return ListTile(
          title: Text('${user.name} @ ${user.age}'),
          subtitle: Text(
            'Added: $created\nUpdated: $updated',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit_outlined),
                onPressed: () {
                  final docId = snapshot.id;
                  debugPrint('updating user: id=$docId');
                  final newuser = user.copyWith(age: user.age + 1);
                  newuser.updateData(docId);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete_outlined),
                onPressed: () {
                  final docId = snapshot.id;
                  debugPrint('deleting user: id=$docId');
                  user.deleteData(docId);
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
