import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_providers.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class SignInController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    final repository = ref.read(authRepositoryProvider);

    final result = await AsyncValue.guard(() async {
      return repository.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    });

    if (result.hasError) {
      state = AsyncError(
        result.error!,
        result.stackTrace!,
      );
      return null;
    }

    state = const AsyncData(null);

    return result.value;
  }
}

final signInControllerProvider =
AsyncNotifierProvider<SignInController, void>(
  SignInController.new,
);


final onboardingStatusProvider =
Provider<OnboardingStatusRepository>((ref) {
  return OnboardingStatusRepository(
    FirebaseFirestore.instance,
  );
});

class OnboardingStatusRepository {
  OnboardingStatusRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Future<bool> isOnboardingCompleted(String uid) async {
    final document =
    await _firestore.collection('users').doc(uid).get();

    if (!document.exists) {
      return false;
    }

    final data = document.data();

    return data?['onboardingCompleted'] == true;
  }
}