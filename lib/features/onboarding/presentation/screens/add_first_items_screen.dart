import 'package:flutter/material.dart';
import 'package:gardirop/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

class AddFirstItemsScreen extends StatefulWidget {
  const AddFirstItemsScreen({super.key});

  @override
  State<AddFirstItemsScreen> createState() =>
      _AddFirstItemsScreenState();
}

class _AddFirstItemsScreenState
    extends State<AddFirstItemsScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final List<XFile> _selectedImages = [];

  Future<void> _takePhoto() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );

      if (image == null) return;

      if (!mounted) return;

      setState(() {
        _selectedImages.add(image);
      });

      // Next phase:
      // Upload image to Firebase Storage
      // Create wardrobe item
      // Run AI clothing analysis
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not open the camera.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _uploadFromGallery() async {
    try {
      final images = await _imagePicker.pickMultiImage(
        imageQuality: 90,
      );

      if (images.isEmpty) return;

      if (!mounted) return;

      setState(() {
        _selectedImages.addAll(images);
      });

      // Next phase:
      // Upload images to Firebase Storage
      // Create wardrobe items
      // Run AI clothing analysis
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not open your gallery.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _browseCatalog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Catalog will be available soon.',
        ),
      ),
    );
  }

  void _doThisLater() {
    context.push(
      '/onboarding/all-set?hasItems=false',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

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
              IconButton(
                onPressed: () =>
                    Navigator.of(context).maybePop(),
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

              const SizedBox(height: 28),

              Center(
                child: Text(
                  l10n.addFirstItemsTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h1.copyWith(
                    color: AppColors.dark,
                    fontSize: 29,
                    height: 1.15,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 320,
                  ),
                  child: Text(
                    l10n.addFirstItemsSubtitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.secondary,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 38),

              _AddItemOption(
                icon: Icons.photo_camera_outlined,
                title: l10n.takePhotos,
                subtitle: l10n.takePhotosSubtitle,
                onTap: _takePhoto,
              ),

              const SizedBox(height: 14),

              _AddItemOption(
                icon: Icons.photo_library_outlined,
                title: l10n.uploadFromGallery,
                subtitle: l10n.uploadFromGallerySubtitle,
                onTap: _uploadFromGallery,
              ),

              const SizedBox(height: 14),

              _AddItemOption(
                icon: Icons.checkroom_outlined,
                title: l10n.browseCatalog,
                subtitle: l10n.browseCatalogSubtitle,
                onTap: _browseCatalog,
              ),


              if (_selectedImages.isNotEmpty) ...[
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_selectedImages.length} '
                          '${_selectedImages.length == 1 ? 'item added' : 'items added'}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.dark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedImages.clear();
                        });
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                SizedBox(
                  height: 74,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_selectedImages[index].path),
                          width: 62,
                          height: 74,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ],
              const Spacer(),

              const Spacer(),

              if (_selectedImages.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push(
                        '/onboarding/all-set?hasItems=true',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dark,
                      foregroundColor: Colors.white,
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
                )
              else
                Center(
                  child: TextButton(
                    onPressed: _doThisLater,
                    child: Text(
                      l10n.doThisLater,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.dark,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 6),

            ],
          ),
        ),
      ),
    );
  }
}

class _AddItemOption extends StatelessWidget {
  const _AddItemOption({
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
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(
            minHeight: 84,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 15,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.55,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.taupe.withValues(
                alpha: 0.7,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.035,
                ),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 38,
                child: Icon(
                  icon,
                  color: AppColors.dark,
                  size: 28,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.dark,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      style:
                      AppTextStyles.small.copyWith(
                        color: AppColors.secondary,
                        fontSize: 12,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Icon(
                isRtl(context)
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
                color: AppColors.secondary,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isRtl(BuildContext context) {
    return Directionality.of(context) ==
        TextDirection.rtl;
  }
}