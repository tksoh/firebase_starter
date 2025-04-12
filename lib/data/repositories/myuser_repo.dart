// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/myuser_model.dart';
import '../services/firestore_crud.dart';

final myUserRepo = MyUserRepo();

class MyUserRepo {
  static String collection = "my-collection";
  final crud = FirestoreCRUD(collectionPath: collection);

  static final query = FirebaseFirestore.instance
      .collection(collection)
      .orderBy('name')
      .withConverter<MyUser>(
        fromFirestore: (snapshot, _) => MyUser.fromFirestore(snapshot),
        toFirestore: (user, _) => user.toJson(),
      );
}
