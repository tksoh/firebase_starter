import 'package:cloud_firestore/cloud_firestore.dart';

import 'doc_base.dart';
import 'doc_time.dart';

class MyUser extends DocumentBase {
  // user data
  final String name;
  final int age;

  // document meta data
  final docTime = FirestoreDocumentTime();

  MyUser({required this.name, required this.age});

  @override
  Map<String, Object?> toJson() {
    return {
      ...{'name': name, 'age': age},
      ...docTime.toJson(),
    };
  }

  factory MyUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final user = MyUser.fromJson(snapshot.data()!);
    user.documentId = snapshot.id;
    return user;
  }

  MyUser.fromJson(Map<String, Object?> json)
      : name = json['name']! as String,
        age = json['age']! as int {
    docTime.fromJson(json);
  }

  MyUser copyWith({String? name, int? age}) {
    return MyUser(
      name: name ?? this.name,
      age: age ?? this.age,
    )
      ..documentId = documentId
      ..docTime.copyFrom(docTime);
  }
}
