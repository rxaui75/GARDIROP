import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gardirop/l10n/app_localizations.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../application/onboarding_controller.dart';
import 'package:go_router/go_router.dart';

class PreferencesScreen extends ConsumerWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final onboarding = ref.watch(onboardingControllerProvider);
    final controller =
    ref.read(onboardingControllerProvider.notifier);

    final isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

    final vibes = [
      _VibeOption('minimal', l10n.vibeMinimal),
      _VibeOption('chic', l10n.vibeChic),
      _VibeOption('casual', l10n.vibeCasual),
      _VibeOption('trendy', l10n.vibeTrendy),
      _VibeOption('classic', l10n.vibeClassic),
      _VibeOption('edgy', l10n.vibeEdgy),
    ];

    final occasions = [
      _OccasionOption(
        id: 'everyday',
        label: l10n.occasionEveryday,
        icon: Icons.work_outline_rounded,
      ),
      _OccasionOption(
        id: 'work',
        label: l10n.occasionWork,
        icon: Icons.laptop_mac_rounded,
      ),
      _OccasionOption(
        id: 'going_out',
        label: l10n.occasionGoingOut,
        icon: Icons.wine_bar_outlined,
      ),
      _OccasionOption(
        id: 'travel',
        label: l10n.occasionTravel,
        icon: Icons.flight_rounded,
      ),
      _OccasionOption(
        id: 'special_event',
        label: l10n.occasionSpecialEvent,
        icon: Icons.auto_awesome_rounded,
      ),
      _OccasionOption(
        id: 'at_home',
        label: l10n.occasionAtHome,
        icon: Icons.home_outlined,
      ),
    ];

    final canContinue =
        onboarding.styleVibes.isNotEmpty ||
            onboarding.occasions.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.light,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            28,
            18,
            28,
            20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back
              IconButton(
                onPressed: () =>
                    Navigator.of(context).maybePop(),
                padding: EdgeInsets.zero,
                alignment: AlignmentDirectional.centerStart,
                icon: Icon(
                  isArabic
                      ? Icons.arrow_forward_ios_rounded
                      : Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: AppColors.dark,
                ),
              ),

              const SizedBox(height: 10),

              // Progress - Step 3
              const Row(
                children: [
                  Expanded(
                    child: _ProgressLine(active: true),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: _ProgressLine(active: true),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: _ProgressLine(active: true),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: _ProgressLine(),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Center(
                child: Text(
                  l10n.preferencesScreenTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.dark,
                    fontSize: 27,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              Center(
                child: Text(
                  l10n.preferencesScreenSubtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.secondary,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Text(
                l10n.styleVibe,
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.dark,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 10,
                children: vibes.map((vibe) {
                  final selected =
                  onboarding.styleVibes.contains(vibe.id);

                  return _VibeChip(
                    label: vibe.label,
                    selected: selected,
                    onTap: () {
                      controller.toggleStyleVibe(vibe.id);
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              Text(
                l10n.occasions,
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.dark,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: GridView.builder(
                  physics:
                  const NeverScrollableScrollPhysics(),
                  itemCount: occasions.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.05,
                  ),
                  itemBuilder: (context, index) {
                    final occasion = occasions[index];
                    final selected =
                    onboarding.occasions.contains(
                      occasion.id,
                    );

                    return _OccasionCard(
                      option: occasion,
                      selected: selected,
                      onTap: () {
                        controller.toggleOccasion(
                          occasion.id,
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: canContinue
                      ? () {
                    context.push('/onboarding/fit-size');
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dark,
                    disabledBackgroundColor:
                    AppColors.taupe.withValues(
                      alpha: 0.55,
                    ),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(30),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _VibeOption {
  const _VibeOption(
      this.id,
      this.label,
      );

  final String id;
  final String label;
}

class _OccasionOption {
  const _OccasionOption({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}

class _VibeChip extends StatelessWidget {
  const _VibeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        padding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : AppColors.sand,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.taupe.withValues(
              alpha: 0.7,
            ),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: selected
                ? Colors.white
                : AppColors.dark,
            fontWeight: selected
                ? FontWeight.w600
                : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _OccasionCard extends StatelessWidget {
  const _OccasionCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _OccasionOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : AppColors.sand,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.taupe.withValues(
              alpha: 0.7,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              option.icon,
              size: 25,
              color: selected
                  ? Colors.white
                  : AppColors.dark,
            ),

            const SizedBox(height: 8),

            Text(
              option.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.small.copyWith(
                color: selected
                    ? Colors.white
                    : AppColors.dark,
                fontSize: 11.5,
                height: 1.2,
                fontWeight: selected
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ],
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
            : AppColors.taupe.withValues(
          alpha: 0.65,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}