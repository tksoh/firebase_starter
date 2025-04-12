// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/myuser_model.dart';
import '../services/firestore_crud.dart';

final myUserRepo = MyUserRepo();

class MyUserRepo {
  static String collection = "my-collection";

  final _crudService = FirestoreCRUD(collectionPath: collection);

  Query<MyUser> get query => FirebaseFirestore.instance
      .collection(collection)
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
    _crudService.updateDocument(user);
  }

  void addUserData({required String name, required int age}) {
    final user = MyUser(
      name: name,
      age: age,
    );
    _crudService.createDocument(user);
  }

  void deleteUserData(MyUser user) {
    _crudService.deleteDocument(user);
  }
}
