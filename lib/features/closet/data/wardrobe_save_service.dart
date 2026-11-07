import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/item_draft.dart';

class WardrobeSaveService {
  WardrobeSaveService._();

  static Future<String> addItem({
    required ItemDraft draft,
    String? colorName,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Please sign in before saving an item.');
    }

    final seasons = (draft.season ?? '')
        .split(',')
        .map((season) => season.trim())
        .where((season) => season.isNotEmpty)
        .toList();

    final itemData = <String, dynamic>{
      'name': draft.name,
      'category': draft.category,
      'colorHex': draft.colorHex,
      'colorName': colorName,
      'brand': draft.brand,
      'material': draft.material,
      'fit': draft.fit,
      'seasons': seasons,
      'occasions': draft.occasion,
      'styles': draft.style,
      'tags': draft.tags,
      'notes': draft.notes,
      'quantity': draft.quantity,
      'imagePath': draft.imagePath,
      'source': draft.source.name,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    final document = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('wardrobe_items')
        .add(itemData);

    return document.id;
  }
}