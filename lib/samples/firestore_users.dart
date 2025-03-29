import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/doc_time.dart';

class User {
  User({required this.name, required this.age, this.docId});

  // user data
  final String name;
  final int age;

  // meta data
  final String? docId;
  final docTime = FirestoreDocumentTime();

  User copyWith({String? name, int? age}) {
    return User(
      name: name ?? this.name,
      age: age ?? this.age,
      docId: docId,
    )..docTime.copyFrom(docTime);
  }

  User.fromJson(Map<String, Object?> json, {String? id})
      : name = json['name']! as String,
        age = json['age']! as int,
        docId = id {
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

  void deleteData() {
    assert(docId != null);
    final ref = FirebaseFirestore.instance.collection('users').doc(docId);
    ref.delete();
  }

  void updateData({String? name, int? age}) {
    assert(docId != null);
    final newdata = copyWith(name: name, age: age);
    final ref = FirebaseFirestore.instance.collection('users').doc(docId);
    ref.update(newdata.toJson());
  }
}

final usersQuery = FirebaseFirestore.instance
    .collection('users')
    .orderBy('name')
    .withConverter<User>(
      fromFirestore: (snapshot, _) =>
          User.fromJson(snapshot.data()!, id: snapshot.id),
      toFirestore: (user, _) => user.toJson(),
    );
