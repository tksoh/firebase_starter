import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDocumentTime {
  Timestamp? createTime;
  Timestamp? updateTime;

  fromJson(Map<String, Object?> json) {
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

  copyFrom(FirestoreDocumentTime from) {
    updateTime = from.updateTime;
    createTime = from.createTime;
  }
}
