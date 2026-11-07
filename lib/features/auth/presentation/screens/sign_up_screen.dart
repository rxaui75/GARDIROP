import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gardirop/l10n/app_localizations.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../application/sign_up_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;

    final credential = await ref
        .read(signUpControllerProvider.notifier)
        .signUp(
      fullName: _fullNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (credential != null) {
      if (!mounted) return;

      context.go('/onboarding/who-are-we-styling');
      return;
    }

    final state = ref.read(signUpControllerProvider);

    if (state.hasError) {
      final error = state.error;

      String message = l10n.genericError;

      if (error is FirebaseAuthException) {
        switch (error.code) {
          case 'email-already-in-use':
            message = l10n.emailAlreadyRegistered;
            break;

          case 'invalid-email':
            message = l10n.invalidEmail;
            break;

          case 'weak-password':
            message = l10n.passwordTooShort;
            break;

          case 'network-request-failed':
            message = l10n.networkError;
            break;

          default:
            message = error.message ?? message;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final signUpState = ref.watch(signUpControllerProvider);
    final isLoading = signUpState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.light,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  padding: EdgeInsets.zero,
                  alignment: AlignmentDirectional.centerStart,
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.dark,
                    size: 20,
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  l10n.createAccount,
                  style: AppTextStyles.h1.copyWith(
                    color: AppColors.dark,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  l10n.signupSubtitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.secondary,
                  ),
                ),

                const SizedBox(height: 38),

                TextFormField(
                  controller: _fullNameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: l10n.fullName,
                    prefixIcon: const Icon(
                      Icons.person_outline_rounded,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.fullNameRequired;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: l10n.email,
                    prefixIcon: const Icon(
                      Icons.mail_outline_rounded,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.emailRequired;
                    }

                    if (!value.contains('@')) {
                      return l10n.invalidEmail;
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    if (!isLoading) _signUp();
                  },
                  decoration: InputDecoration(
                    hintText: l10n.password,
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.passwordRequired;
                    }

                    if (value.length < 6) {
                      return l10n.passwordTooShort;
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 26),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dark,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      l10n.continueButton,
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        l10n.orContinueWith,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 22),

                _SocialButton(
                  label: l10n.continueWithApple,
                  icon: Icons.apple,
                  onPressed: () {
                    // Apple Sign-In later.
                  },
                ),

                const SizedBox(height: 12),

                _SocialButton(
                  label: l10n.continueWithGoogle,
                  icon: Icons.g_mobiledata_rounded,
                  onPressed: () {
                    // Google Sign-In later.
                  },
                ),

                const SizedBox(height: 30),

                Center(
                  child: Text(
                    l10n.termsAgreement,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.secondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: AppColors.dark,
          size: 24,
        ),
        label: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: AppColors.dark,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.55),
          side: BorderSide(
            color: AppColors.taupe.withValues(alpha: 0.8),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
        ),
      ),
    );
  }
}