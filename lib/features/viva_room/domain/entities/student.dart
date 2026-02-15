class Student {
  final String id; // This is the unique document ID or user ID
  final String name; // Optional name
  final int studentId; // The numeric ID (e.g., Roll Number)
  final String status; // 'waiting', 'in_viva', 'done'

  Student({
    required this.id,
    this.name = '',
    required this.studentId,
    required this.status,
  });
}
