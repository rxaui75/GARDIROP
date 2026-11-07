import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/wardrobe_item.dart';

class WardrobeRepository {
  WardrobeRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Stream<List<WardrobeItem>> watchWardrobeItems() {
    final user = _auth.currentUser;

    if (user == null) {
      return Stream.value(const []);
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('wardrobe_items')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(WardrobeItem.fromFirestore)
          .toList(),
    );
  }

  Stream<WardrobeItem?> watchWardrobeItem(String itemId) {
    final user = _auth.currentUser;

    if (user == null) {
      return Stream.value(null);
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('wardrobe_items')
        .doc(itemId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }

      return WardrobeItem.fromFirestore(snapshot);
    });
  }
}