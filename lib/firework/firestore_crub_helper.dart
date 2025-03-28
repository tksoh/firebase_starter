import 'package:cloud_firestore/cloud_firestore.dart';

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
