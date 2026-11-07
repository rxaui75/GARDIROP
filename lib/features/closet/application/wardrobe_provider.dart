import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/wardrobe_repository.dart';
import '../domain/wardrobe_item.dart';

final wardrobeRepositoryProvider = Provider<WardrobeRepository>((ref) {
  return WardrobeRepository();
});

final wardrobeItemsProvider =
StreamProvider<List<WardrobeItem>>((ref) {
  final repository = ref.watch(wardrobeRepositoryProvider);

  return repository.watchWardrobeItems();
});

final wardrobeItemProvider =
StreamProvider.family<WardrobeItem?, String>((ref, itemId) {
  final repository = ref.watch(wardrobeRepositoryProvider);

  return repository.watchWardrobeItem(itemId);
});