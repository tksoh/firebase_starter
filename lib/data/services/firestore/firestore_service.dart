// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_starter/data/services/firebase_auth.dart';

import 'firestore_document.dart';

class FirestoreCRUD {
  final String collection;
  final bool byUser;
  final String userCollection;

  FirestoreCRUD({
    required this.collection,
    this.byUser = false,
    this.userCollection = "user-repository",
  });

  bool get signedIn => AuthService.signedIn;

  String get collectionPath {
    if (byUser) {
      assert(signedIn);
      final userid = FirebaseAuth.instance.currentUser!.uid;
      return '$userCollection/$userid/$collection';
    } else {
      return collection;
    }
  }

  void createDocument(FirestoreDocument doc) {
    assert((byUser && signedIn) || !byUser);

    final ref = FirebaseFirestore.instance.collection(collectionPath).doc();
    ref.set(doc.toJsonWithMetadata());
  }

  void deleteDocument(FirestoreDocument doc) {
    assert(doc.metadata.documentId != null);
    assert((byUser && signedIn) || !byUser);

    final ref = FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(doc.metadata.documentId);
    ref.delete();
  }

  void updateDocument(FirestoreDocument doc) {
    assert(doc.metadata.documentId != null);
    assert((byUser && signedIn) || !byUser);

    final ref = FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(doc.metadata.documentId);
    ref.update(doc.toJsonWithMetadata());
  }
}
