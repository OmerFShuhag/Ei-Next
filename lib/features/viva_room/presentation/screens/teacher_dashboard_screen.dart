import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/providers.dart';

import '../../domain/entities/viva_session.dart';

class TeacherDashboardScreen extends ConsumerWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<VivaSession?> sessionAsyncValue = ref.watch(
      vivaSessionStreamProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              // Confirm exit?
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: sessionAsyncValue.when(
        data: (session) {
          if (session == null) {
            return const Center(child: Text('Session not found'));
          }
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInfoCard(
                  context,
                  'Room Code',
                  session.id,
                  Colors.deepPurpleAccent,
                ),
                const SizedBox(height: 24),
                _buildStatusSection(context, session),
                const SizedBox(height: 48),
                ElevatedButton.icon(
                  onPressed: () {
                    ref
                        .read(vivaRepositoryProvider)
                        .updateCurrentId(
                          session.id,
                          session.currentId + session.batchSize,
                        );
                  },
                  icon: const Icon(Icons.navigate_next, size: 32),
                  label: const Text('CALL NEXT BATCH'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Upcoming Batch:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5, // Show next 5 batches
                    itemBuilder: (context, index) {
                      final nextId =
                          session.currentId + session.batchSize * (index + 1);
                      return ListTile(
                        leading: CircleAvatar(child: Text('${index + 1}')),
                        title: Text('Start ID: $nextId'),
                        subtitle: Text('Batch Size: ${session.batchSize}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          SelectableText(
            value,
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context, dynamic session) {
    return Column(
      children: [
        Text(
          'Current Batch',
          style: GoogleFonts.outfit(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${session.currentId}',
              style: GoogleFonts.outfit(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (session.batchSize > 1) ...[
              Text(
                ' - ',
                style: GoogleFonts.outfit(
                  fontSize: 48,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                '${session.currentId + session.batchSize - 1}',
                style: GoogleFonts.outfit(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
