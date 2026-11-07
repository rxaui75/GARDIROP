import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gardirop/l10n/app_localizations.dart';

import '../../../../app/localization/locale_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final isArabic = locale.languageCode == 'ar';

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/welcome-background.png',
            fit: BoxFit.cover,
          ),

          Container(
            color: Colors.white.withOpacity(0.08),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 20,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: () {
                        ref
                            .read(localeProvider.notifier)
                            .toggleLanguage();
                      },
                      child: Text(
                        isArabic ? 'English' : 'العربية',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  Image.asset(
                    'assets/logos/gardirop-logo.png',
                    width: 135,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    l10n.appName,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.primary,
                      fontSize: 36,
                      letterSpacing: 6,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    l10n.tagline.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.primary.withOpacity(0.75),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.2,
                    ),
                  ),

                  const Spacer(flex: 3),

                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      l10n.heroLine,
                      textAlign:
                      isArabic ? TextAlign.right : TextAlign.left,
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.dark,
                        fontSize: 29,
                        height: 1.12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push('/sign-up');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.dark,
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shadowColor: Colors.black.withOpacity(0.25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.getStarted,
                            style: AppTextStyles.body.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Icon(
                            isArabic
                                ? Icons.arrow_back
                                : Icons.arrow_forward,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    l10n.styleBrighterYou,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.dark.withOpacity(0.8),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () {
                      context.push('/sign-in');
                    },
                    child: Text(
                      l10n.alreadyHaveAccount,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}