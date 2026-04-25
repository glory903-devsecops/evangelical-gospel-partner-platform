import 'package:cloud_firestore/cloud_firestore.dart';

/// 모든 Firestore 저장소의 기반이 되는 클래스입니다.
/// 테넌트 격리(Tenant Isolation) 기능을 기본적으로 포함합니다.
abstract class BaseFirestoreRepository<T> {
  final FirebaseFirestore firestore;
  final String collectionPath;

  BaseFirestoreRepository({
    required this.firestore,
    required this.collectionPath,
  });

  CollectionReference get collection => firestore.collection(collectionPath);

  /// 특정 테넌트의 데이터만 조회하는 쿼리를 반환합니다.
  Query tenantQuery(String tenantId) {
    return collection.where('tenantId', isEqualTo: tenantId);
  }

  /// Firestore 문서를 엔터티로 변환하는 추상 메서드입니다.
  T fromFirestore(DocumentSnapshot doc);

  /// 엔터티를 Firestore 데이터 맵으로 변환하는 추상 메서드입니다.
  Map<String, dynamic> toFirestore(T entity);

  /// 테넌트 내의 모든 문서를 스트림으로 가져옵니다.
  Stream<List<T>> watchAll(String tenantId) {
    return tenantQuery(tenantId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => fromFirestore(doc)).toList();
    });
  }

  /// 특정 ID의 문서를 가져옵니다.
  Future<T?> getById(String id) async {
    final doc = await collection.doc(id).get();
    if (!doc.exists) return null;
    return fromFirestore(doc);
  }

  /// 새로운 문서를 추가하거나 업데이트합니다.
  Future<void> upsert(String id, T entity) async {
    await collection.doc(id).set(toFirestore(entity), SetOptions(merge: true));
  }

  /// 새로운 문서를 추가하고 생성된 ID를 반환합니다.
  Future<String> add(T entity) async {
    final docRef = await collection.add(toFirestore(entity));
    return docRef.id;
  }


  /// 문서를 삭제합니다.
  Future<void> delete(String id) async {
    await collection.doc(id).delete();
  }
}
