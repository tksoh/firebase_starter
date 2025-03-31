import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class DocumentBase {
  String get collectionPath;

  Map<String, Object?> toJson();
}

mixin FirestoreCRUD on DocumentBase {
  void createDocument() {
    if (FirebaseAuth.instance.currentUser == null) return;

    final ref = FirebaseFirestore.instance.collection(collectionPath).doc();
    ref.set(toJson());
  }

  void deleteDocument(String id) {
    if (FirebaseAuth.instance.currentUser == null) return;

    final ref = FirebaseFirestore.instance.collection(collectionPath).doc(id);
    ref.delete();
  }

  void updateDocument(String id) {
    if (FirebaseAuth.instance.currentUser == null) return;

    final ref = FirebaseFirestore.instance.collection(collectionPath).doc(id);
    ref.update(toJson());
  }
}
