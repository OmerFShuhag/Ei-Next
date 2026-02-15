import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/datasources/firestore_data_source.dart';
import '../../data/repositories/viva_repository_impl.dart';
import '../../domain/repositories/viva_repository.dart';
import '../../domain/entities/viva_session.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firestoreDataSourceProvider = Provider<FirestoreDataSource>((ref) {
  return FirestoreDataSource(ref.read(firestoreProvider));
});

final vivaRepositoryProvider = Provider<VivaRepository>((ref) {
  return VivaRepositoryImpl(ref.read(firestoreDataSourceProvider));
});

final currentSessionIdProvider = StateProvider<String?>((ref) => null);

final vivaSessionStreamProvider = StreamProvider.autoDispose<VivaSession?>((
  ref,
) {
  final sessionId = ref.watch(currentSessionIdProvider);
  if (sessionId == null) return const Stream.empty();
  return ref.read(vivaRepositoryProvider).getSessionStream(sessionId);
});

final appVersionProvider = FutureProvider<String>((ref) async {
  return ref.read(vivaRepositoryProvider).getLatestAppVersion();
});
