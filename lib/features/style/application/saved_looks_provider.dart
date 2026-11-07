import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/saved_looks_repository.dart';
import '../domain/saved_look.dart';

final savedLooksRepositoryProvider =
Provider<SavedLooksRepository>((ref) {
  return SavedLooksRepository();
});

final savedLooksProvider =
StreamProvider<List<SavedLook>>((ref) {
  final repository = ref.watch(
    savedLooksRepositoryProvider,
  );

  return repository.watchSavedLooks();
});