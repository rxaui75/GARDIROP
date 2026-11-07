import 'package:flutter/material.dart';
import 'package:gardirop/l10n/app_localizations.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/onboarding_controller.dart';
import 'package:go_router/go_router.dart';

class WhoAreWeStylingScreen extends ConsumerStatefulWidget {
  const WhoAreWeStylingScreen({super.key});

  @override
  ConsumerState<WhoAreWeStylingScreen> createState() =>
      _WhoAreWeStylingScreenState();
}

class _WhoAreWeStylingScreenState
    extends ConsumerState<WhoAreWeStylingScreen> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.light,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                padding: EdgeInsets.zero,
                alignment: AlignmentDirectional.centerStart,
                icon: Icon(
                  isArabic
                      ? Icons.arrow_forward_ios_rounded
                      : Icons.arrow_back_ios_new_rounded,
                  color: AppColors.dark,
                  size: 20,
                ),
              ),

              const SizedBox(height: 18),

              // Progress lines
              Row(
                children: [
                  Expanded(
                    child: _ProgressLine(
                      active: true,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: _ProgressLine(),
                  ),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: _ProgressLine(),
                  ),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: _ProgressLine(),
                  ),
                ],
              ),

              const SizedBox(height: 34),

              // Title
              Center(
                child: Text(
                  l10n.whoAreWeStylingTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h1.copyWith(
                    color: AppColors.dark,
                    fontSize: 32,
                    height: 1.15,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Subtitle
              Center(
                child: Text(
                  l10n.whoAreWeStylingSubtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.secondary,
                    height: 1.45,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Woman card
              _StylingImageCard(
                title: l10n.stylingWomen,
                imagePath: 'assets/images/styling-woman.png',
                isSelected: _selectedOption == 'woman',
                onTap: () {
                  setState(() {
                    _selectedOption = 'woman';
                  });
                },
              ),

              const SizedBox(height: 14),

              // Man card
              _StylingImageCard(
                title: l10n.stylingMen,
                imagePath: 'assets/images/styling-man.png',
                isSelected: _selectedOption == 'man',
                onTap: () {
                  setState(() {
                    _selectedOption = 'man';
                  });
                },
              ),

              const Spacer(),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: _selectedOption == null
                      ? null
                      : () {
                    ref
                        .read(onboardingControllerProvider.notifier)
                        .setStylingFor(_selectedOption!);

                    context.push('/onboarding/style-swipe');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dark,
                    disabledBackgroundColor:
                    AppColors.taupe.withValues(alpha: 0.55),
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    l10n.continueButton,
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _StylingImageCard extends StatelessWidget {
  const _StylingImageCard({
    required this.title,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: double.infinity,
          height: 168,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : Colors.transparent,
              width: 1.6,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isSelected ? 0.10 : 0.05,
                ),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(21),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image
                Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),

                // Subtle dark overlay near bottom
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color(0x11000000),
                        Color(0x66000000),
                      ],
                      stops: [
                        0.45,
                        0.68,
                        1.0,
                      ],
                    ),
                  ),
                ),

                // Selection circle
                PositionedDirectional(
                  top: 14,
                  end: 14,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.88)
                          : Colors.white.withValues(alpha: 0.22),
                      border: Border.all(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.7)
                            : Colors.white.withValues(alpha: 0.8),
                        width: 1.4,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 21,
                    )
                        : null,
                  ),
                ),

                // Title
                PositionedDirectional(
                  start: 0,
                  end: 0,
                  bottom: 16,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      shadows: const [
                        Shadow(
                          blurRadius: 6,
                          color: Colors.black45,
                          offset: Offset(0, 2),
                        ),
                      ],
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

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({
    this.active = false,
  });

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: active
            ? AppColors.primary
            : AppColors.taupe.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}