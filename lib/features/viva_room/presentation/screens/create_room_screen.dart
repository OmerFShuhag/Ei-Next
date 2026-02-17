import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/providers.dart';
import 'teacher_dashboard_screen.dart';

class CreateRoomScreen extends ConsumerStatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  ConsumerState<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends ConsumerState<CreateRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _startIdController = TextEditingController();
  final _batchSizeController = TextEditingController(text: '1');
  final _timePerStudentController = TextEditingController(text: '5');
  bool _isLoading = false;

  @override
  void dispose() {
    _startIdController.dispose();
    _batchSizeController.dispose();
    _timePerStudentController.dispose();
    super.dispose();
  }

  Future<void> _createRoom() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final startId = int.parse(_startIdController.text);
        final batchSize = int.parse(_batchSizeController.text);
        final timePerStudent = int.parse(_timePerStudentController.text);

        final sessionId = await ref
            .read(vivaRepositoryProvider)
            .createSession(
              startId: startId,
              batchSize: batchSize,
              timePerStudent: timePerStudent,
            );

        // Update current session provider
        ref.read(currentSessionIdProvider.notifier).state = sessionId;

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const TeacherDashboardScreen(),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error creating room: \$e')));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Viva Room'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Configure Session',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _startIdController,
                decoration: const InputDecoration(
                  labelText: 'Start Student ID',
                  hintText: 'e.g. 20101001',
                  prefixIcon: Icon(Icons.confirmation_number),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter start ID';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _batchSizeController,
                      decoration: const InputDecoration(
                        labelText: 'Batch Size',
                        hintText: '1',
                        prefixIcon: Icon(Icons.group),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (int.tryParse(value) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _timePerStudentController,
                      decoration: const InputDecoration(
                        labelText: 'Time (min)/Student',
                        hintText: '5',
                        prefixIcon: Icon(Icons.timer),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (int.tryParse(value) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: _isLoading ? null : _createRoom,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Launch Room'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
