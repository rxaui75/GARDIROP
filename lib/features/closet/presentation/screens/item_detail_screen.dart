import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../domain/wardrobe_item.dart';
import '../../domain/item_draft.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/wardrobe_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ItemDetailScreen extends ConsumerWidget {
  const ItemDetailScreen({
    super.key,
    required this.item,
  });

  final WardrobeItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(
      wardrobeItemProvider(item.id),
    );

    return itemAsync.when(
        loading: () => const Scaffold(
          backgroundColor: AppColors.light,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),

        error: (error, stackTrace) => Scaffold(
          backgroundColor: AppColors.light,
          body: SafeArea(
            child: Center(
              child: Text(
                'Could not load this item.',
                style: AppTextStyles.body,
              ),
            ),
          ),
        ),

        data: (liveItem) {
          if (liveItem == null) {
            return Scaffold(
              backgroundColor: AppColors.light,
              body: SafeArea(
                child: Center(
                  child: Text(
                    'This item no longer exists.',
                    style: AppTextStyles.body,
                  ),
                ),
              ),
            );
          }

          final item = liveItem;
          final selectedColor = _colorFromHex(item.colorHex);

          return Scaffold(
            backgroundColor: AppColors.light,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 20,
                          ),
                        ),

                        const Spacer(),

                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.more_horiz_rounded,
                            size: 28,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Container(
                      width: double.infinity,
                      height: 260,
                      decoration: BoxDecoration(
                        color: AppColors.beige.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      padding: const EdgeInsets.all(28),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          selectedColor,
                          BlendMode.modulate,
                        ),
                        child: Image.asset(
                          item.imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context,
                              error,
                              stackTrace,) {
                            return const Icon(
                              Icons.checkroom_outlined,
                              size: 70,
                              color: AppColors.secondary,
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      item.name,
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.dark,
                      ),
                    ),

                    if (item.brand != null && item.brand!.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        item.brand!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],

                    const SizedBox(height: 8),

                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _MetaText(item.category),

                        if (item.colorName != null &&
                            item.colorName!.isNotEmpty)
                          _MetaText(item.colorName!),

                        if (item.seasons.isNotEmpty)
                          _MetaText(item.seasons.join(', ')),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.auto_awesome_outlined,
                              label: 'Style',
                              onTap: () {},
                            ),
                          ),

                          Expanded(
                            child: _ActionButton(
                              icon: Icons.edit_outlined,
                              label: 'Edit',
                              onTap: () {
                                final draft = ItemDraft(
                                  name: item.name,
                                  category: item.category,
                                  imagePath: item.imagePath,
                                  colorHex: item.colorHex,
                                  brand: item.brand,
                                  material: item.material,
                                  fit: item.fit,
                                  season: item.seasons.join(', '),
                                  occasion: item.occasions,
                                  style: item.styles,
                                  tags: item.tags,
                                  notes: item.notes,
                                  quantity: item.quantity,
                                  source: item.source == 'aiScan'
                                      ? ItemDraftSource.aiScan
                                      : ItemDraftSource.quickAdd,
                                );

                                context.push(
                                  '/closet/edit-item',
                                  extra: {
                                    'itemId': item.id,
                                    'draft': draft,
                                  },
                                );
                              },
                            ),
                          ),

                          Expanded(
                            child: _ActionButton(
                              icon: Icons.copy_outlined,
                              label: 'Duplicate',
                              onTap: () {
                                final draft = ItemDraft(
                                  name: item.name,
                                  category: item.category,
                                  imagePath: item.imagePath,
                                  colorHex: item.colorHex,
                                  brand: item.brand,
                                  material: item.material,
                                  fit: item.fit,
                                  season: item.seasons.join(', '),
                                  occasion: item.occasions,
                                  style: item.styles,
                                  tags: item.tags,
                                  notes: item.notes,
                                  quantity: item.quantity,
                                  source: item.source == 'aiScan'
                                      ? ItemDraftSource.aiScan
                                      : ItemDraftSource.quickAdd,
                                );

                                context.push(
                                  '/closet/review-item',
                                  extra: draft,
                                );
                              },
                            ),
                          ),

                          Expanded(
                            child: _ActionButton(
                              icon: Icons.delete_outline_rounded,
                              label: 'Delete',
                              onTap: () {
                                _confirmDelete(
                                  context,
                                  item,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Details',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.dark,
                      ),
                    ),

                    const SizedBox(height: 10),

                    _DetailRow(
                      label: 'Material',
                      value: _displayValue(item.material),
                    ),

                    _DetailRow(
                      label: 'Fit',
                      value: _displayValue(item.fit),
                    ),

                    _DetailRow(
                      label: 'Style',
                      value: item.styles.isEmpty
                          ? '—'
                          : item.styles.join(', '),
                    ),

                    _DetailRow(
                      label: 'Occasion',
                      value: item.occasions.isEmpty
                          ? '—'
                          : item.occasions.join(', '),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Notes',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.dark,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        item.notes == null || item.notes!.trim().isEmpty
                            ? 'No notes added.'
                            : item.notes!,
                        style: AppTextStyles.body.copyWith(
                          color: item.notes == null ||
                              item.notes!.trim().isEmpty
                              ? AppColors.secondary
                              : AppColors.dark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
    );
  }

  Future<void> _confirmDelete(
      BuildContext context,
      WardrobeItem item,
      ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.light,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Delete item?',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.dark,
            ),
          ),
          content: Text(
            'Are you sure you want to remove "${item.name}" from your closet? This can’t be undone.',
            style: AppTextStyles.body.copyWith(
              color: AppColors.secondary,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(
                'Cancel',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.dark,
                ),
              ),
            ),

            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !context.mounted) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in to delete this item.'),
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('wardrobe_items')
          .doc(item.id)
          .delete();

      if (!context.mounted) return;

      context.go('/closet');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${item.name} removed from your closet.',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not delete this item. Please try again.',
          ),
        ),
      );
    }
  }

  static String _displayValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '—';
    }

    return value;
  }

  static Color _colorFromHex(String? hex) {
    if (hex == null || hex.isEmpty) {
      return Colors.white;
    }

    final cleanHex = hex.replaceAll('#', '');

    final value = int.tryParse(
      cleanHex.length == 6
          ? 'FF$cleanHex'
          : cleanHex,
      radix: 16,
    );

    if (value == null) {
      return Colors.white;
    }

    return Color(value);
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.secondary,
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 4,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 22,
              color: AppColors.dark,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: AppTextStyles.small.copyWith(
                color: AppColors.dark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.secondary,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.dark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}