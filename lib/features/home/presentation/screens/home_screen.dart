import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../application/home_user_provider.dart';
import '../../../closet/application/wardrobe_provider.dart';
import 'package:go_router/go_router.dart';
//import 'package:gardirop/core/services/gardi_functions_service.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(homeUserNameProvider);
    final wardrobeAsync = ref.watch(wardrobeItemsProvider);

    return Scaffold(
      backgroundColor: AppColors.light,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: userName.when(
                      data: (name) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good evening, $name',
                              style: AppTextStyles.h2.copyWith(
                                color: AppColors.dark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ready to style your day?',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 180,
                              height: 24,
                              decoration: BoxDecoration(
                                color: AppColors.beige,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 140,
                              height: 16,
                              decoration: BoxDecoration(
                                color: AppColors.beige,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ],
                        );
                      },
                      error: (_, __) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good evening',
                              style: AppTextStyles.h2.copyWith(
                                color: AppColors.dark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ready to style your day?',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 16),

                  IconButton(
                    onPressed: () {
                      // Notifications later
                    },
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      size: 28,
                    ),
                    color: AppColors.dark,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              Container(
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.72),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.taupe.withOpacity(0.75),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      // AI Stylist route later
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.auto_awesome_outlined,
                            color: AppColors.primary,
                            size: 22,
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              'Ask me anything...',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.secondary,
                              ),
                            ),
                          ),

                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Expanded(
                    child: _SmartToolCard(
                      icon: Icons.checkroom_outlined,
                      title: 'Style Me',
                      onTap: () {
                        // Style Me later
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SmartToolCard(
                      icon: Icons.grid_view_rounded,
                      title: 'Closet\nGaps',
                      onTap: () {
                        // Closet Gaps later
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SmartToolCard(
                      icon: Icons.favorite_border_rounded,
                      title: 'Fix My\nOutfit',
                      onTap: () {
                        // Fix My Outfit later
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SmartToolCard(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Should I\nBuy This?',
                      onTap: () {
                        // Should I Buy This later
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Text(
                "Today's Outfit Suggestion",
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.dark,
                ),
              ),

              const SizedBox(height: 14),

              wardrobeAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),

                error: (error, stackTrace) => _buildEmptyOutfitCard(context),

                data: (items) {
                  if (items.isEmpty) {
                    return _buildEmptyOutfitCard(context);
                  }

                  return _buildReadyForStylingCard(
                    context,
                    items.length,
                  );
                },
              ),


              const SizedBox(height: 28),

              Text(
                'Quick Actions',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.dark,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.add_shopping_cart_rounded,
                      title: 'Add Item',
                      onTap: () {
                        context.push('/closet/quick-add');
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.checkroom_outlined,
                      title: 'View Closet',
                      onTap: () {
                        context.go('/closet');
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.favorite_border_rounded,
                      title: 'My Outfits',
                      onTap: () {
                        // TODO: Navigate to My Outfits.
                      },
                    ),
                  ),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyOutfitCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.beige.withOpacity(0.55),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),

          const SizedBox(height: 22),

          Text(
            'Your first outfit is waiting',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.dark,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Add a few pieces to your closet and Gardi will create a look using what you already own.',
            style: AppTextStyles.body.copyWith(
              color: AppColors.secondary,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 18),

          OutlinedButton.icon(
            onPressed: () {
              // Add Item flow next
            },
            icon: const Icon(
              Icons.add_rounded,
              size: 20,
            ),
            label: const Text('Add Items'),
          ),
        ],
      ),
    );
  }

  Widget _buildReadyForStylingCard(
      BuildContext context,
      int itemCount,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.beige.withOpacity(0.55),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),

          const SizedBox(height: 22),

          Text(
            'Your closet is ready to style',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.dark,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'You have $itemCount ${itemCount == 1 ? 'piece' : 'pieces'} in your closet. Let Gardi put them together for you.',
            style: AppTextStyles.body.copyWith(
              color: AppColors.secondary,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 18),

          OutlinedButton.icon(
            onPressed: () {
              // Style My Closet later
            },
            icon: const Icon(
              Icons.auto_awesome_rounded,
              size: 18,
            ),
            label: const Text('Style My Closet'),
          ),
        ],
      ),
    );
  }
}

class _SmartToolCard extends StatelessWidget {
  const _SmartToolCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.beige.withOpacity(0.72),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AspectRatio(
          aspectRatio: 0.92,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 23,
                  color: AppColors.primary,
                ),

                const SizedBox(height: 8),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.dark,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
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


class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.55),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 8,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 22,
                color: AppColors.primary,
              ),

              const SizedBox(height: 8),

              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.small.copyWith(
                  color: AppColors.dark,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}