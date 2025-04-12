// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/models/core/doc_base.dart';

class FirestoreCRUD {
  final String collectionPath;

  FirestoreCRUD({
    required this.collectionPath,
  });

  void createDocument(DocumentBase doc) {
    if (FirebaseAuth.instance.currentUser == null) return;

    final ref = FirebaseFirestore.instance.collection(collectionPath).doc();
    ref.set(doc.toJson());
  }

  void deleteDocument(DocumentBase doc) {
    assert(doc.documentId != null);

    if (FirebaseAuth.instance.currentUser == null) return;

    final ref = FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(doc.documentId);
    ref.delete();
  }

  void updateDocument(DocumentBase doc) {
    assert(doc.documentId != null);

    if (FirebaseAuth.instance.currentUser == null) return;

    final ref = FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(doc.documentId);
    ref.update(doc.toJson());
  }
}
