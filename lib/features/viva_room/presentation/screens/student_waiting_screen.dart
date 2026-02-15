import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/providers.dart';
import '../../domain/entities/viva_session.dart';

class StudentWaitingScreen extends ConsumerWidget {
  final int studentId;

  const StudentWaitingScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<VivaSession?> sessionAsyncValue = ref.watch(
      vivaSessionStreamProvider,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Waiting Room')),
      body: sessionAsyncValue.when(
        data: (session) {
          if (session == null) {
            return const Center(child: Text('Session not found or ended.'));
          }

          // Check if it's the student's turn
          bool isMyTurn = session.isIdInCurrentBatch(studentId);
          bool isPast = studentId < session.currentId;
          int waitTime = session.getEstimatedWaitTime(studentId);

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Your ID: $studentId',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                if (isMyTurn)
                  _buildStatusCard(
                    context,
                    'IT IS YOUR TURN!',
                    Colors.green,
                    Icons.check_circle,
                    'Please proceed to the viva room.',
                  )
                else if (isPast)
                  _buildStatusCard(
                    context,
                    'Completed / Missed',
                    Colors.grey,
                    Icons.history,
                    'Your turn has passed.',
                  )
                else
                  _buildWaitingStatus(context, session, waitTime),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildStatusCard(
    BuildContext context,
    String title,
    Color color,
    IconData icon,
    String message,
  ) {
    return Card(
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(icon, size: 64, color: color),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: GoogleFonts.outfit(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaitingStatus(
    BuildContext context,
    dynamic session,
    int waitTime,
  ) {
    return Column(
      children: [
        Text(
          'Current ID',
          style: GoogleFonts.outfit(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        Text(
          '${session.currentId}',
          style: GoogleFonts.outfit(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Estimated Wait Time',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '~ $waitTime mins',
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF03DAC6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
