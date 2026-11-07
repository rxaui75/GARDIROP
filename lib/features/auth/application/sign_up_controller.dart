import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_providers.dart';

class SignUpController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<UserCredential?> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    final repository = ref.read(authRepositoryProvider);

    final result = await AsyncValue.guard(() async {
      final credential = await repository.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await credential.user?.updateDisplayName(fullName.trim());

      return credential;
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

final signUpControllerProvider =
AsyncNotifierProvider<SignUpController, void>(
  SignUpController.new,
);