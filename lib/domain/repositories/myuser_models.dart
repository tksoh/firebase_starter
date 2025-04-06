import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_crub_helper.dart';
import '../services/doc_time.dart';

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

  static final query = FirebaseFirestore.instance
      .collection(collection)
      .orderBy('name')
      .withConverter<MyUser>(
        fromFirestore: (snapshot, _) =>
            MyUser.fromJson(snapshot.data()!, id: snapshot.id),
        toFirestore: (user, _) => user.toJson(),
      );
}
