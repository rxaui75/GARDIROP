import 'package:flutter/material.dart';
import 'package:gardirop/l10n/app_localizations.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/onboarding_controller.dart';

class ExploreGardiropScreen extends ConsumerWidget {
  const ExploreGardiropScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final features = [
      _ExploreFeature(
        title: l10n.aiStylist,
        description: l10n.aiStylistDescription,
        icon: Icons.auto_awesome_rounded,
      ),
      _ExploreFeature(
        title: l10n.myCloset,
        description: l10n.myClosetDescription,
        icon: Icons.checkroom_rounded,
      ),
      _ExploreFeature(
        title: l10n.styleFeature,
        description: l10n.styleFeatureDescription,
        icon: Icons.style_outlined,
      ),
      _ExploreFeature(
        title: l10n.shouldIBuyThis,
        description: l10n.shouldIBuyThisDescription,
        icon: Icons.shopping_bag_outlined,
      ),
      _ExploreFeature(
        title: l10n.closetGaps,
        description: l10n.closetGapsDescription,
        icon: Icons.grid_view_rounded,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.light,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            28,
            34,
            28,
            20,
          ),
          child: Column(
            children: [
              Text(
                l10n.exploreGardiropTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.h1.copyWith(
                  color: AppColors.dark,
                  fontSize: 30,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                l10n.exploreGardiropSubtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.secondary,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: features.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _FeatureCard(
                      feature: features[index],
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      ref
                          .read(onboardingControllerProvider.notifier)
                          .completeOnboarding();

                      await ref
                          .read(onboardingControllerProvider.notifier)
                          .saveOnboardingToFirestore();

                      if (!context.mounted) return;

                      context.go('/home');
                    } catch (error) {
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.genericError,
                          ),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.startExploring,
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 20,
                      ),
                    ],
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

class _ExploreFeature {
  const _ExploreFeature({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.feature,
  });

  final _ExploreFeature feature;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 82,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.taupe.withValues(alpha: 0.7),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.sand,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              feature.icon,
              color: AppColors.primary,
              size: 26,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  feature.title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.dark,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  feature.description,
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.secondary,
                    fontSize: 12,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}