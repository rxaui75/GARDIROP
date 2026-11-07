import 'package:cloud_firestore/cloud_firestore.dart';

class WardrobeItem {
  const WardrobeItem({
    required this.id,
    required this.name,
    required this.category,
    required this.imagePath,
    required this.quantity,
    required this.occasions,
    required this.seasons,
    required this.styles,
    required this.tags,
    required this.source,
    this.colorHex,
    this.colorName,
    this.brand,
    this.material,
    this.fit,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  final String id;

  final String name;
  final String category;
  final String imagePath;

  final String? colorHex;
  final String? colorName;
  final String? brand;
  final String? material;
  final String? fit;
  final String? notes;

  final List<String> occasions;
  final List<String> seasons;
  final List<String> styles;
  final List<String> tags;

  final int quantity;
  final String source;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory WardrobeItem.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data() ?? {};

    return WardrobeItem(
      id: doc.id,

      name: data['name'] as String? ?? '',
      category: data['category'] as String? ?? '',
      imagePath: data['imagePath'] as String? ?? '',

      colorHex: data['colorHex'] as String?,
      colorName: data['colorName'] as String?,
      brand: data['brand'] as String?,
      material: data['material'] as String?,
      fit: data['fit'] as String?,
      notes: data['notes'] as String?,

      occasions: _stringList(data['occasions']),
      seasons: _stringList(data['seasons']),
      styles: _stringList(data['styles']),
      tags: _stringList(data['tags']),

      quantity: (data['quantity'] as num?)?.toInt() ?? 1,
      source: data['source'] as String? ?? 'quickAdd',

      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  static List<String> _stringList(dynamic value) {
    if (value is! List) return const [];

    return value
        .whereType<String>()
        .toList();
  }
}