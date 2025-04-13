// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/myuser_model.dart';
import '../services/firestore/firestore_service.dart';

final myUserRepo = MyUserRepo();

class MyUserRepo {
  static String collection = "users";

  FirestoreCRUD get crudService =>
      FirestoreCRUD(collection: collection, byUser: true);

  Query<MyUser> get query => FirebaseFirestore.instance
      .collection(crudService.collectionPath)
      .orderBy('name')
      .withConverter<MyUser>(
        fromFirestore: (snapshot, _) => MyUser.fromFirestore(snapshot),
        toFirestore: (user, _) => user.toJson(),
      );

  void updateUserData(
      {required MyUser from, required String name, required int age}) {
    final user = from.copyWith(
      name: name,
      age: age,
    );

    crudService.updateDocument(user);
  }

  void addUserData({required String name, required int age}) {
    final user = MyUser(
      name: name,
      age: age,
    );

    crudService.createDocument(user);
  }

  void deleteUserData(MyUser user) {
    crudService.deleteDocument(user);
  }
}
