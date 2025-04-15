// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreDocument {
  final metadata = FirestoreDocumentMetadata();

  Map<String, Object?> toJson();

  Map<String, Object?> toJsonWithMetadata() {
    return {
      ...toJson(),
      ...metadata.toJson(),
    };
  }
}

class FirestoreDocumentMetadata {
  Timestamp? createTime;
  Timestamp? updateTime;
  String? documentId;

  FirestoreDocumentMetadata({
    this.createTime,
    this.updateTime,
    this.documentId,
  });

  void loadFromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    documentId = snapshot.id;

    final json = snapshot.data()!;
    updateTime =
        json['_updateTime_'] == null ? null : json['_updateTime_'] as Timestamp;
    createTime =
        json['_createTime_'] == null ? null : json['_createTime_'] as Timestamp;
  }

  Map<String, Object?> toJson({Timestamp? toCreate, Timestamp? toUpdate}) {
    return {
      '_updateTime_': toUpdate ?? FieldValue.serverTimestamp(),
      if (createTime == null)
        '_createTime_': toCreate ?? FieldValue.serverTimestamp(),
    };
  }

  void copyFrom(FirestoreDocumentMetadata from) {
    updateTime = from.updateTime;
    createTime = from.createTime;
    documentId = from.documentId;
  }
}
