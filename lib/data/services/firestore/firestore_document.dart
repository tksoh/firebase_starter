import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreDocument {
  final metadata = FirestoreDocumentTime();

  Map<String, Object?> toJson();

  Map<String, Object?> toJsonWithMetadata() {
    return {
      ...toJson(),
      ...metadata.toJson(),
    };
  }
}

class FirestoreDocumentTime {
  Timestamp? createTime;
  Timestamp? updateTime;
  String? documentId;

  fromJson(Map<String, Object?> json, {String? id}) {
    documentId = id;
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

  void copyFrom(FirestoreDocumentTime? from) {
    if (from == null) return;

    updateTime = from.updateTime;
    createTime = from.createTime;
    documentId = from.documentId;
  }
}
