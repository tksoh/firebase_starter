import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class DocumentBase {
  String get collectionPath;
  String? documentId;

  Map<String, Object?> toJson();
}

mixin FirestoreCRUD on DocumentBase {
  void createDocument() {
    if (FirebaseAuth.instance.currentUser == null) return;

    final ref = FirebaseFirestore.instance.collection(collectionPath).doc();
    ref.set(toJson());
  }

  void deleteDocument() {
    assert(documentId != null);

    if (FirebaseAuth.instance.currentUser == null) return;

    final ref =
        FirebaseFirestore.instance.collection(collectionPath).doc(documentId);
    ref.delete();
  }

  void updateDocument() {
    assert(documentId != null);

    if (FirebaseAuth.instance.currentUser == null) return;

    final ref =
        FirebaseFirestore.instance.collection(collectionPath).doc(documentId);
    ref.update(toJson());
  }
}
