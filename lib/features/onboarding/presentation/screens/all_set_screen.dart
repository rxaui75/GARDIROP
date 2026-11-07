import 'package:flutter/material.dart';
import 'package:gardirop/l10n/app_localizations.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';

class AllSetScreen extends StatelessWidget {
  const AllSetScreen({
    super.key,
    required this.hasItems,
  });

  final bool hasItems;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.light,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            28,
            28,
            28,
            20,
          ),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Decorative wardrobe illustration
              Container(
                width: 240,
                height: 220,
                decoration: BoxDecoration(
                  color: AppColors.sand,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 28,
                      left: 38,
                      child: _ItemTile(
                        icon: Icons.checkroom_rounded,
                        angle: -0.12,
                      ),
                    ),
                    Positioned(
                      top: 22,
                      right: 35,
                      child: _ItemTile(
                        icon: Icons.shopping_bag_outlined,
                        angle: 0.10,
                      ),
                    ),
                    Positioned(
                      bottom: 28,
                      left: 62,
                      child: _ItemTile(
                        icon: Icons.dry_cleaning_outlined,
                        angle: 0.06,
                      ),
                    ),
                    Positioned(
                      bottom: 18,
                      right: 54,
                      child: _ItemTile(
                        icon: Icons.watch_outlined,
                        angle: -0.08,
                      ),
                    ),

                    Positioned(
                      bottom: 6,
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 34),

              Text(
                l10n.allSetTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.h1.copyWith(
                  color: AppColors.dark,
                  fontSize: 30,
                ),
              ),

              const SizedBox(height: 12),

              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 330,
                ),
                child: Text(
                  hasItems
                      ? l10n.allSetWithItemsSubtitle
                      : l10n.allSetWithoutItemsSubtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.secondary,
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
              ),

              const Spacer(flex: 2),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/onboarding/explore');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    hasItems
                        ? l10n.seeFirstOutfits
                        : l10n.startExploring,
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              if (hasItems)
                TextButton(
                  onPressed: () {
                    context.push('/onboarding/explore');
                  },
                  child: Text(
                    l10n.exploreTheApp,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.dark,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.icon,
    required this.angle,
  });

  final IconData icon;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 84,
        height: 94,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 34,
        ),
      ),
    );
  }
}