import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gardirop/l10n/app_localizations.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../closet/application/wardrobe_provider.dart';
import '../../../closet/domain/wardrobe_item.dart';
import 'package:go_router/go_router.dart';

class SelectOutfitItemsScreen extends ConsumerStatefulWidget {
  const SelectOutfitItemsScreen({super.key});

  @override
  ConsumerState<SelectOutfitItemsScreen> createState() =>
      _SelectOutfitItemsScreenState();
}

class _SelectOutfitItemsScreenState
    extends ConsumerState<SelectOutfitItemsScreen> {
  final Set<String> _selectedItemIds = {};
  String? _selectedCategory;

  void _toggleItem(WardrobeItem item) {
    setState(() {
      if (_selectedItemIds.contains(item.id)) {
        _selectedItemIds.remove(item.id);
      } else {
        _selectedItemIds.add(item.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final wardrobeAsync = ref.watch(wardrobeItemsProvider);

    return Scaffold(
      backgroundColor: AppColors.light,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    l10n.selectOutfitItemsTitle,
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    l10n.selectOutfitItemsSubtitle,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),

                  const SizedBox(height: 18),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: _selectedItemIds.isEmpty
                        ? Align(
                      key: const ValueKey('hint'),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.selectAtLeastTwoItems,
                        style: AppTextStyles.small.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),
                    )
                        : Align(
                      key: const ValueKey('counter'),
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.beige,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          l10n.outfitItemsSelected(
                            _selectedItemIds.length,
                          ),
                          style: AppTextStyles.small.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                ],
              ),
            ),

            Expanded(
              child: wardrobeAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),

                error: (error, stackTrace) => Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      l10n.outfitClosetLoadError,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ),

                data: (items) {
                  if (items.isEmpty) {
                    return _EmptyClosetState(
                      title: l10n.outfitClosetEmptyTitle,
                      subtitle: l10n.outfitClosetEmptySubtitle,
                    );
                  }

                  final categoryMap = <String, String>{};

                  for (final item in items) {
                    final category = item.category.trim();

                    if (category.isEmpty) {
                      continue;
                    }

                    final normalizedCategory = category.toLowerCase();

                    categoryMap.putIfAbsent(
                      normalizedCategory,
                          () => category,
                    );
                  }

                  final categories = categoryMap.entries.toList()
                    ..sort(
                          (a, b) => a.value.toLowerCase().compareTo(
                        b.value.toLowerCase(),
                      ),
                    );

                  final filteredItems = _selectedCategory == null
                      ? items
                      : items.where((item) {
                    return item.category.trim().toLowerCase() ==
                        _selectedCategory;
                  }).toList();

                  return Column(
                    children: [
                      SizedBox(
                        height: 42,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: categories.length + 1,
                          separatorBuilder: (_, __) =>
                          const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final entry =
                            index == 0 ? null : categories[index - 1];

                            final categoryKey = entry?.key;
                            final categoryLabel = entry?.value;

                            final selected =
                                _selectedCategory == categoryKey;

                            return _CategoryChip(
                              label: categoryLabel ?? l10n.allCategories,
                              selected: selected,
                              onTap: () {
                                setState(() {
                                  _selectedCategory = categoryKey;
                                });
                              },
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            20,
                            0,
                            20,
                            20,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemCount: filteredItems.length,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.78,
                          ),
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];

                            final selected =
                            _selectedItemIds.contains(item.id);

                            return _SelectableWardrobeItem(
                              item: item,
                              selected: selected,
                              onTap: () => _toggleItem(item),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            wardrobeAsync.maybeWhen(
              data: (items) {
                if (items.isEmpty) {
                  return const SizedBox.shrink();
                }

                return _BottomActionBar(
                  selectedCount: _selectedItemIds.length,
                  label: l10n.continueOutfit,
                  onPressed: _selectedItemIds.length >= 2
                      ? () {
                    final selectedItems = items
                        .where(
                          (item) => _selectedItemIds.contains(item.id),
                    )
                        .toList();

                    context.push(
                      '/style/outfit-builder',
                      extra: selectedItems,
                    );
                  }
                      : null,
                );
              },
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary
                : AppColors.beige,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.small.copyWith(
                fontWeight: FontWeight.w600,
                color: selected
                    ? Colors.white
                    : AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectableWardrobeItem extends StatelessWidget {
  const _SelectableWardrobeItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final WardrobeItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.beige,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: selected
                        ? AppColors.primary
                        : Colors.transparent,
                    width: selected ? 2.5 : 0,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _WardrobeImage(
                      imagePath: item.imagePath,
                    ),

                    if (selected)
                      Container(
                        color: AppColors.primary.withOpacity(0.08),
                      ),

                    Positioned(
                      top: 10,
                      right: 10,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary
                              : AppColors.light.withOpacity(0.92),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : AppColors.taupe,
                          ),
                        ),
                        child: selected
                            ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 19,
                        )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              item.name.isNotEmpty ? item.name : item.category,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),

            if (item.category.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                item.category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.small.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _WardrobeImage extends StatelessWidget {
  const _WardrobeImage({
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return _fallback();
    }

    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }

    return Image.file(
      File(imagePath),
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallback(),
    );
  }

  Widget _fallback() {
    return Center(
      child: Icon(
        Icons.checkroom_rounded,
        size: 36,
        color: AppColors.secondary,
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({
    required this.selectedCount,
    required this.label,
    required this.onPressed,
  });

  final int selectedCount;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = selectedCount >= 2;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: AppColors.light,
        border: Border(
          top: BorderSide(
            color: AppColors.taupe.withOpacity(0.45),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: enabled
                  ? AppColors.primary
                  : AppColors.beige,
              foregroundColor: enabled
                  ? Colors.white
                  : AppColors.secondary,
              disabledBackgroundColor: AppColors.beige,
              disabledForegroundColor: AppColors.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyClosetState extends StatelessWidget {
  const _EmptyClosetState({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.beige,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.checkroom_outlined,
                color: AppColors.primary,
                size: 28,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.h3.copyWith(
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}