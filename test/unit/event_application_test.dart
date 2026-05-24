import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evangelical_gospel_partner/features/events/data/repositories/event_application_repository.dart';
import 'package:evangelical_gospel_partner/features/events/domain/entities/event_application.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockTransaction extends Mock implements Transaction {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}

// Fakes for fallback values
class FakeDocumentReferenceMap extends Fake implements DocumentReference<Map<String, dynamic>> {}
class FakeDocumentReferenceObject extends Fake implements DocumentReference<Object?> {}

void main() {
  late EventApplicationRepository repository;
  late MockFirestore mockFirestore;
  late MockCollectionReference mockEventsCollection;
  late MockCollectionReference mockAppsCollection;
  late MockDocumentReference mockEventDocRef;
  late MockDocumentReference mockAppDocRef;
  late MockTransaction mockTransaction;
  late MockDocumentSnapshot mockEventSnapshot;
  late MockDocumentSnapshot mockAppSnapshot;

  setUpAll(() {
    registerFallbackValue(FakeDocumentReferenceMap());
    registerFallbackValue(FakeDocumentReferenceObject());
  });

  setUp(() {
    mockFirestore = MockFirestore();
    mockEventsCollection = MockCollectionReference();
    mockAppsCollection = MockCollectionReference();
    mockEventDocRef = MockDocumentReference();
    mockAppDocRef = MockDocumentReference();
    mockTransaction = MockTransaction();
    mockEventSnapshot = MockDocumentSnapshot();
    mockAppSnapshot = MockDocumentSnapshot();

    // Stub Firestore collections and documents
    when(() => mockFirestore.collection('events')).thenReturn(mockEventsCollection);
    when(() => mockFirestore.collection('applications')).thenReturn(mockAppsCollection);
    
    when(() => mockEventsCollection.doc(any())).thenReturn(mockEventDocRef);
    when(() => mockAppsCollection.doc(any())).thenReturn(mockAppDocRef);

    // Setup repository
    repository = EventApplicationRepository(firestore: mockFirestore);
  });

  group('EventApplicationRepository - Join Event', () {
    test('Successful Join increments currentApplicants and sets application doc', () async {
      const eventId = 'event1';
      const userId = 'user1';
      const tenantId = 'anguk';

      // Setup document paths
      when(() => mockAppDocRef.id).thenReturn('event1_user1');

      // Stub transaction execution
      when(() => mockFirestore.runTransaction<void>(any())).thenAnswer((invocation) async {
        final transactionHandler = invocation.positionalArguments[0] as Future<void> Function(Transaction);
        return await transactionHandler(mockTransaction);
      });

      // Stub transaction get calls with explicit generic types Map<String, dynamic> and Object?
      when(() => mockTransaction.get<Map<String, dynamic>>(any())).thenAnswer((invocation) async {
        final ref = invocation.positionalArguments[0];
        if (ref == mockEventDocRef) {
          return mockEventSnapshot;
        } else {
          return mockAppSnapshot;
        }
      });
      when(() => mockTransaction.get<Object?>(any())).thenAnswer((invocation) async {
        final ref = invocation.positionalArguments[0];
        if (ref == mockEventDocRef) {
          return mockEventSnapshot;
        } else {
          return mockAppSnapshot;
        }
      });

      // Stub snapshots
      when(() => mockEventSnapshot.exists).thenReturn(true);
      when(() => mockEventSnapshot.data()).thenReturn({
        'maxApplicants': 10,
        'currentApplicants': 5,
      });

      when(() => mockAppSnapshot.exists).thenReturn(false);

      // Stub transaction write operations (set and update) with explicit generic parameters
      when(() => mockTransaction.update(any(), any())).thenReturn(mockTransaction);
      when(() => mockTransaction.set<Map<String, dynamic>>(any(), any())).thenReturn(mockTransaction);
      when(() => mockTransaction.set<Object?>(any(), any())).thenReturn(mockTransaction);

      // Run code
      await repository.joinEvent(tenantId, eventId, userId);

      // Verify transaction actions
      verify(() => mockTransaction.update(mockEventDocRef, {'currentApplicants': 6})).called(1);
      verify(() => mockTransaction.set<Object?>(mockAppDocRef, any())).called(1);
    });

    test('Join Event throws exception when max applicants is reached', () async {
      const eventId = 'event1';
      const userId = 'user1';
      const tenantId = 'anguk';

      when(() => mockFirestore.runTransaction<void>(any())).thenAnswer((invocation) async {
        final transactionHandler = invocation.positionalArguments[0] as Future<void> Function(Transaction);
        return await transactionHandler(mockTransaction);
      });

      when(() => mockTransaction.get<Map<String, dynamic>>(any())).thenAnswer((invocation) async {
        final ref = invocation.positionalArguments[0];
        if (ref == mockEventDocRef) {
          return mockEventSnapshot;
        } else {
          return mockAppSnapshot;
        }
      });
      when(() => mockTransaction.get<Object?>(any())).thenAnswer((invocation) async {
        final ref = invocation.positionalArguments[0];
        if (ref == mockEventDocRef) {
          return mockEventSnapshot;
        } else {
          return mockAppSnapshot;
        }
      });

      when(() => mockEventSnapshot.exists).thenReturn(true);
      when(() => mockEventSnapshot.data()).thenReturn({
        'maxApplicants': 5,
        'currentApplicants': 5,
      });

      expect(
        () => repository.joinEvent(tenantId, eventId, userId),
        throwsException,
      );
    });
  });
}
