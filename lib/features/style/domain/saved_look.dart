import 'package:cloud_firestore/cloud_firestore.dart';

class SavedLook {
  const SavedLook({
    required this.id,
    required this.itemIds,
    required this.overallAssessment,
    required this.summary,
    required this.strengths,
    required this.suggestions,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final List<String> itemIds;

  final String overallAssessment;
  final String summary;

  final List<String> strengths;
  final List<String> suggestions;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory SavedLook.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data() ?? {};

    return SavedLook(
      id: doc.id,
      itemIds: _readStringList(
        data['itemIds'],
      ),
      overallAssessment: _readString(
        data['overallAssessment'],
      ),
      summary: _readString(
        data['summary'],
      ),
      strengths: _readStringList(
        data['strengths'],
      ),
      suggestions: _readStringList(
        data['suggestions'],
      ),
      createdAt: _readDateTime(
        data['createdAt'],
      ),
      updatedAt: _readDateTime(
        data['updatedAt'],
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'itemIds': itemIds,
      'overallAssessment': overallAssessment,
      'summary': summary,
      'strengths': strengths,
      'suggestions': suggestions,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static String _readString(dynamic value) {
    if (value is String) {
      return value.trim();
    }

    return '';
  }

  static List<String> _readStringList(
      dynamic value,
      ) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<String>()
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList(growable: false);
  }

  static DateTime? _readDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return null;
  }
}