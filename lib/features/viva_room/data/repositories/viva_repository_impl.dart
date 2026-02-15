import '../../domain/repositories/viva_repository.dart';
import '../../domain/entities/viva_session.dart';
import '../datasources/firestore_data_source.dart';

class VivaRepositoryImpl implements VivaRepository {
  final FirestoreDataSource _dataSource;

  VivaRepositoryImpl(this._dataSource);

  @override
  Future<String> createSession({
    required int startId,
    required int batchSize,
    required int timePerStudent,
  }) {
    return _dataSource.createSession(
      startId: startId,
      batchSize: batchSize,
      timePerStudent: timePerStudent,
    );
  }

  @override
  Stream<VivaSession?> getSessionStream(String sessionId) {
    return _dataSource.getSessionStream(sessionId);
  }

  @override
  Future<void> joinSession(String sessionId, int studentId) async {
    // For now, joining is just valid if the session exists.
    // We could add the student to a subcollection 'students' if we wanted to track them explicitly.
    // For this MVP, we just rely on the session stream.
  }

  @override
  Future<void> updateCurrentId(String sessionId, int newId) {
    return _dataSource.updateCurrentId(sessionId, newId);
  }

  @override
  Future<void> endSession(String sessionId) async {
    // Implementation to close/delete session if needed
  }

  @override
  Future<String> getLatestAppVersion() {
    return _dataSource.getLatestAppVersion();
  }
}
