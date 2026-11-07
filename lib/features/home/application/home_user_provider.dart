import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeUserNameProvider = FutureProvider<String>((ref) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return 'there';
  }

  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();

  final data = doc.data();

  final displayName = data?['displayName'] as String?;

  if (displayName != null && displayName.trim().isNotEmpty) {
    return displayName.trim().split(RegExp(r'\s+')).first;
  }

  final authName = user.displayName?.trim();

  if (authName != null && authName.isNotEmpty) {
    return authName.split(RegExp(r'\s+')).first;
  }

  return 'there';
});