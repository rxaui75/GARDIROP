import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/wardrobe_provider.dart';
import '../../domain/wardrobe_item.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/gardi_item_analysis_service.dart';
import '../widgets/gardi_analyzing_dialog.dart';

class ClosetScreen extends ConsumerWidget {
  const ClosetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wardrobeAsync = ref.watch(wardrobeItemsProvider);
    return Scaffold(
      backgroundColor: AppColors.light,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'My Closet',
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.dark,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _showAddItemOptions(context);
                    },
                    icon: const Icon(
                      Icons.add_rounded,
                      size: 28,
                    ),
                    color: AppColors.dark,
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Text(
                'Everything you own, all in one place.',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.secondary,
                ),
              ),

              const SizedBox(height: 28),

              Expanded(
                child: wardrobeAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),

                  error: (error, stackTrace) => Center(
                    child: Text(
                      'Could not load your closet.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ),

                  data: (items) {
                    if (items.isEmpty) {
                      return _buildEmptyCloset(context);
                    }

                    return _buildClosetGrid(
                      context,
                      items,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCloset(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.beige,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.checkroom_outlined,
              size: 34,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            'Your closet is waiting',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.dark,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Add your first pieces and Gardi will start learning your wardrobe.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.secondary,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: () {
              _showAddItemOptions(context);
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Item'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClosetGrid(
      BuildContext context,
      List<WardrobeItem> items,
      ) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 4, bottom: 24),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return _WardrobeItemCard(
          item: item,
          onTap: () {
            context.push(
              '/closet/item-detail',
              extra: item,
            );
          },
        );
      },
    );
  }


  void _showAddItemOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.light,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.taupe,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'Add to Closet',
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.dark,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Choose how you want to add your item.',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.secondary,
                  ),
                ),

                const SizedBox(height: 22),

                _AddItemOptionCard(
                  icon: Icons.camera_alt_outlined,
                  title: 'Scan an Item',
                  subtitle:
                  'Take a photo or choose one from your gallery. Gardi will fill in the details for you.',
                  onTap: () {
                    Navigator.pop(context);
                    _showScanItemSource(context);
                  },
                ),

                const SizedBox(height: 12),

                _AddItemOptionCard(
                  icon: Icons.bolt_rounded,
                  title: 'Quick Add',
                  subtitle:
                  'Choose a common wardrobe basic and customize it in seconds.',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/closet/quick-add');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showScanItemSource(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.light,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.taupe,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'Scan an Item',
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.dark,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Add a clear photo of one clothing item.',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.secondary,
                  ),
                ),

                const SizedBox(height: 22),

                _AddItemOptionCard(
                  icon: Icons.camera_alt_outlined,
                  title: 'Take a Photo',
                  subtitle: 'Use your camera to photograph the item.',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/closet/ai-scan-camera');
                  },
                ),

                const SizedBox(height: 12),

                _AddItemOptionCard(
                  icon: Icons.photo_library_outlined,
                  title: 'Choose from Gallery',
                  subtitle: 'Select an existing photo from your gallery.',
                  onTap: () async {
                    final rootContext = Navigator.of(context).context;

                    Navigator.pop(context);

                    await _pickScanImage(
                      rootContext,
                      ImageSource.gallery,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickScanImage(
      BuildContext context,
      ImageSource source,
      ) async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: source,
      imageQuality: 75,
      maxWidth: 1600,
    );

    if (image == null) {
      debugPrint('SCAN IMAGE: No image selected.');
      return;
    }

    debugPrint('SCAN IMAGE SELECTED: ${image.path}');

    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.48),
      builder: (_) => const GardiAnalyzingDialog(),
    );

    try {
      final result = await GardiItemAnalysisService.analyze(
        imagePath: image.path,
      );

      if (!context.mounted) return;

      Navigator.of(
        context,
        rootNavigator: true,
      ).pop();

      debugPrint(
        'GARDI ANALYSIS: ${result.analysis}',
      );

      context.push(
        '/closet/ai-result',
        extra: {
          'draft': result.draft,
          'analysis': result.analysis,
        },
      );
    } catch (error) {
      if (!context.mounted) return;

      // Close Gardi analyzing popup.
      Navigator.of(
        context,
        rootNavigator: true,
      ).pop();

      debugPrint('GARDI SCAN ERROR: $error');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Gardi is a little busy right now. Please try again in a moment.',
          ),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  List<String> _stringList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  String _stringValue(
      dynamic value, {
        required String fallback,
      }) {
    if (value == null) {
      return fallback;
    }

    final text = value.toString().trim();

    return text.isEmpty ? fallback : text;
  }

  String? _nullableString(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();

    return text.isEmpty ? null : text;
  }
}

class _WardrobeItemCard extends StatelessWidget {
  const _WardrobeItemCard({
    required this.item,
    required this.onTap,
  });

  final WardrobeItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selectedColor = _colorFromHex(item.colorHex);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: AppColors.beige.withOpacity(0.45),
                  padding: const EdgeInsets.all(14),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      selectedColor,
                      BlendMode.modulate,
                    ),
                    child: Image.asset(
                      item.imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (
                          context,
                          error,
                          stackTrace,
                          ) {
                        return const Center(
                          child: Icon(
                            Icons.checkroom_outlined,
                            size: 42,
                            color: AppColors.secondary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  12,
                  12,
                  12,
                  14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.dark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        if (item.colorHex != null) ...[
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: selectedColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black.withOpacity(0.08),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],

                        Expanded(
                          child: Text(
                            item.colorName ?? item.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.small.copyWith(
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

class _AddItemOptionCard extends StatelessWidget {
  const _AddItemOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.beige.withOpacity(0.6),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 23,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.dark,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.secondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}