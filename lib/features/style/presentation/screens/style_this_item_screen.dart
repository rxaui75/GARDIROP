
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gardirop/l10n/app_localizations.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../closet/domain/wardrobe_item.dart';

class StyleThisItemScreen extends StatelessWidget {
  const StyleThisItemScreen({
    super.key,
    required this.item,
  });

  final WardrobeItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        backgroundColor: AppColors.light,
        foregroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.styleThisItem,
          style: AppTextStyles.h3.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.styleThisItemSubtitle,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      height: 320,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.beige,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: _SelectedItemImage(
                          imagePath: item.imagePath,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      item.name,
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.category,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                    if (item.colorName != null &&
                        item.colorName!.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.colorName!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.auto_awesome_rounded),
                  label: Text(l10n.styleItForMe),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                    AppColors.primary.withOpacity(0.75),
                    disabledForegroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedItemImage extends StatelessWidget {
  const _SelectedItemImage({
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    Widget placeholder() {
      return const Center(
        child: Icon(
          Icons.checkroom_rounded,
          color: AppColors.secondary,
          size: 52,
        ),
      );
    }

    if (imagePath.isEmpty) {
      return placeholder();
    }

    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => placeholder(),
      );
    }

    return Image.file(
      File(imagePath),
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => placeholder(),
    );
  }
}
