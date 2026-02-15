class VivaSession {
  final String id;
  final String teacherId;
  final int startId;
  final int currentId;
  final int batchSize;
  final int estimatedTimePerStudent; // in minutes
  final DateTime createdAt;

  VivaSession({
    required this.id,
    required this.teacherId,
    required this.startId,
    required this.currentId,
    required this.batchSize,
    required this.estimatedTimePerStudent,
    required this.createdAt,
  });

  // Helper to check if a student ID is in the current batch
  bool isIdInCurrentBatch(int studentId) {
    if (studentId < currentId) return false;
    return studentId < currentId + batchSize;
  }

  // Calculate estimated wait time for a specific student ID
  int getEstimatedWaitTime(int studentId) {
    if (studentId <= currentId) return 0;
    int studentsAhead = studentId - currentId;
    // We can assume parallel processing if batch size > 1, but for safety/simplicity
    // usually valid is sequential even in batches or we just multiply.
    // Let's assume sequential for the estimate to be conservative.
    return studentsAhead * estimatedTimePerStudent;
  }
}
