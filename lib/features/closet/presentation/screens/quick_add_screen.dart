import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../application/quick_add_provider.dart';
import '../../domain/quick_add_item.dart';
import 'package:go_router/go_router.dart';

import '../../domain/item_draft.dart';

class QuickAddScreen extends ConsumerStatefulWidget {
  const QuickAddScreen({super.key});

  @override
  ConsumerState<QuickAddScreen> createState() => _QuickAddScreenState();
}

class _QuickAddScreenState extends ConsumerState<QuickAddScreen> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(quickAddItemsProvider);

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        backgroundColor: AppColors.light,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: AppColors.dark,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
          ),
          onPressed: () {
            context.pop();
          },
        ),

        title: Text(
          'Quick Add',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.dark,
          ),
        ),
      ),
      body: itemsAsync.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Could not load Quick Add items.',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            ),
          );
        },
        data: (items) {
          final categories = <String>[
            'All',
            ...items
                .map((item) => item.category)
                .toSet()
                .toList(),
          ];

          final filteredItems = selectedCategory == 'All'
              ? items
              : items
              .where(
                (item) =>
            item.category == selectedCategory,
          )
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  0,
                ),
                child: Text(
                  'Add wardrobe basics in seconds.',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                height: 42,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) {
                    return const SizedBox(width: 8);
                  },
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final selected =
                        selectedCategory == category;

                    return ChoiceChip(
                      label: Text(category),
                      selected: selected,
                      onSelected: (_) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.beige,
                      labelStyle:
                      AppTextStyles.small.copyWith(
                        color: selected
                            ? Colors.white
                            : AppColors.dark,
                        fontWeight: FontWeight.w600,
                      ),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(20),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 18),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    0,
                    20,
                    24,
                  ),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    return _QuickAddCard(
                      item: filteredItems[index],
                      onTap: () {
                        final item = filteredItems[index];

                        context.push(
                          '/closet/review-item',
                          extra: ItemDraft(
                            name: item.name,
                            category: item.category,
                            imagePath: item.assetPath,
                            colorHex: _defaultColorToHex(item.defaultColor),
                            quantity: item.defaultQuantity,
                            source: ItemDraftSource.quickAdd,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _QuickAddCard extends StatelessWidget {
  const _QuickAddCard({
    required this.item,
    required this.onTap,
  });

  final QuickAddItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: double.infinity,
                    color: AppColors.sand,
                    child: Image.asset(
                      item.assetPath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.dark,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                item.category,
                style: AppTextStyles.small.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _defaultColorToHex(String colorName) {
  switch (colorName.toLowerCase()) {
    case 'white':
      return '#FFFFFF';
    case 'black':
      return '#1F1F1F';
    case 'cream':
      return '#F5EFE6';
    case 'beige':
      return '#D8C3A5';
    case 'camel':
      return '#B8895D';
    case 'brown':
      return '#6B4932';
    case 'gray':
      return '#9C9C9C';
    case 'navy':
      return '#24324A';
    case 'blue':
      return '#6E97C5';
    case 'red':
      return '#A74343';
    case 'pink':
      return '#D7A7A7';
    case 'green':
      return '#7C8A6D';
    case 'gold':
      return '#C9A227';
    case 'silver':
      return '#BFC3C7';
    default:
      return '#FFFFFF';
  }
}