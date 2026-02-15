import '../entities/viva_session.dart';

abstract class VivaRepository {
  Future<String> createSession({
    required int startId,
    required int batchSize,
    required int timePerStudent,
  });

  Stream<VivaSession?> getSessionStream(String sessionId);

  Future<void> joinSession(String sessionId, int studentId);

  Future<void> updateCurrentId(String sessionId, int newId);

  Future<void> endSession(String sessionId);

  // For Update Checker
  Future<String> getLatestAppVersion();
}
