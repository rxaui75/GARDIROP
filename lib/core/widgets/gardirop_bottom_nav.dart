import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class GardiropBottomNav extends StatelessWidget {
  const GardiropBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const items = [
      _NavItem(
        label: 'Home',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home_rounded,
      ),
      _NavItem(
        label: 'Closet',
        icon: Icons.checkroom_outlined,
        selectedIcon: Icons.checkroom_rounded,
      ),
      _NavItem(
        label: 'Stylist',
        icon: Icons.auto_awesome_outlined,
        selectedIcon: Icons.auto_awesome_rounded,
        isStylist: true,
      ),
      _NavItem(
        label: 'Style',
        icon: Icons.favorite_border_rounded,
        selectedIcon: Icons.favorite_rounded,
      ),
      _NavItem(
        label: 'You',
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
      ),
    ];

    return SafeArea(
      top: false,
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: AppColors.light,
          border: Border(
            top: BorderSide(
              color: AppColors.taupe.withOpacity(0.45),
            ),
          ),
        ),
        child: Row(
          children: List.generate(
            items.length,
                (index) {
              final item = items[index];
              final selected = currentIndex == index;

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (item.isStylist)
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary
                                : AppColors.beige,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            selected
                                ? item.selectedIcon
                                : item.icon,
                            size: 19,
                            color: selected
                                ? Colors.white
                                : AppColors.primary,
                          ),
                        )
                      else
                        Icon(
                          selected
                              ? item.selectedIcon
                              : item.icon,
                          size: 24,
                          color: selected
                              ? AppColors.primary
                              : AppColors.secondary,
                        ),

                      const SizedBox(height: 3),

                      Text(
                        item.label,
                        style: AppTextStyles.small.copyWith(
                          fontSize: 10,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: selected
                              ? AppColors.primary
                              : AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.isStylist = false,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool isStylist;
}