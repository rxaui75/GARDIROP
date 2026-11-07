import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/quick_add_item.dart';

class QuickAddRepository {
  Future<List<QuickAddItem>> loadItems() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/quick_add_catalog_v2.json',
    );

    final decoded =
    jsonDecode(jsonString) as Map<String, dynamic>;

    final items =
    decoded['items'] as List<dynamic>;

    return items
        .map(
          (item) => QuickAddItem.fromJson(
        item as Map<String, dynamic>,
      ),
    )
        .toList();
  }
}