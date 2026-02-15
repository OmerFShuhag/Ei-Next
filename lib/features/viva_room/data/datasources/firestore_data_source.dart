import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/viva_session.dart';

class FirestoreDataSource {
  final FirebaseFirestore _firestore;

  FirestoreDataSource(this._firestore);

  Future<String> createSession({
    required int startId,
    required int batchSize,
    required int timePerStudent,
  }) async {
    final String sessionId = const Uuid()
        .v4()
        .substring(0, 6)
        .toUpperCase(); // Short code

    final sessionData = {
      'id': sessionId,
      'teacherId': 'teacher_1', // detailed auth not required
      'startId': startId,
      'currentId': startId,
      'batchSize': batchSize,
      'estimatedTimePerStudent': timePerStudent,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('viva_sessions')
        .doc(sessionId)
        .set(sessionData);
    return sessionId;
  }

  Stream<VivaSession?> getSessionStream(String sessionId) {
    return _firestore
        .collection('viva_sessions')
        .doc(sessionId)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists) return null;
          final data = snapshot.data()!;
          return VivaSession(
            id: data['id'],
            teacherId: data['teacherId'],
            startId: data['startId'],
            currentId: data['currentId'],
            batchSize: data['batchSize'],
            estimatedTimePerStudent: data['estimatedTimePerStudent'],
            createdAt: (data['createdAt'] as Timestamp).toDate(),
          );
        });
  }

  Future<void> updateCurrentId(String sessionId, int newId) async {
    await _firestore.collection('viva_sessions').doc(sessionId).update({
      'currentId': newId,
    });
  }

  Future<String> getLatestAppVersion() async {
    final doc = await _firestore.collection('config').doc('app_version').get();
    if (doc.exists && doc.data() != null) {
      return doc.data()!['version'] as String;
    }
    return '1.0.0'; // Default if not found
  }
}
