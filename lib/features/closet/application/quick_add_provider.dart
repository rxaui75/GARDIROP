import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/quick_add_repository.dart';
import '../domain/quick_add_item.dart';

final quickAddRepositoryProvider = Provider<QuickAddRepository>((ref) {
  return QuickAddRepository();
});

final quickAddItemsProvider =
FutureProvider<List<QuickAddItem>>((ref) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return [];
  }

  final userDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();

  final stylingFor =
      userDoc.data()?['stylingFor'] as String? ?? 'both';

  final repository = ref.read(quickAddRepositoryProvider);
  final allItems = await repository.loadItems();

  return allItems.where((item) {
    switch (stylingFor) {
      case 'woman':
        return item.audience == 'women' ||
            item.audience == 'unisex';

      case 'man':
        return item.audience == 'men' ||
            item.audience == 'unisex';

      case 'both':
      default:
        return true;
    }
  }).toList();
});