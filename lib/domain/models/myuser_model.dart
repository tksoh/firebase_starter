import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/services/firestore/firestore_document.dart';

class MyUser extends FirestoreDocument {
  // user data
  final String name;
  final int age;

  MyUser({required this.name, required this.age});

  @override
  Map<String, Object?> toJson() {
    return {'name': name, 'age': age};
  }

  factory MyUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return MyUser.fromJson(snapshot.data()!)
      ..metadata.loadFromFirestore(snapshot);
  }

  MyUser.fromJson(Map<String, Object?> json)
      : name = json['name']! as String,
        age = json['age']! as int;

  MyUser copyWith({String? name, int? age}) {
    return MyUser(
      name: name ?? this.name,
      age: age ?? this.age,
    )..metadata.copyFrom(metadata);
  }
}
