import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class GardiFunctionsService {
  GardiFunctionsService._();

  static const String _baseUrl =
      'http://127.0.0.1:5001/'
      'gardirop-app-a5c92/'
      'me-central2';

  static Future<String> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('No signed-in Firebase user.');
    }

    final token = await user.getIdToken(true);

    if (token == null || token.isEmpty) {
      throw Exception('Could not get Firebase ID token.');
    }

    return token;
  }

  static Future<String> testConnection() async {
    final token = await _getIdToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/testGardi'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'data': {},
      }),
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        'HTTP ${response.statusCode}: ${response.body}',
      );
    }

    final result = Map<String, dynamic>.from(
      decoded['result'] as Map,
    );

    return result['message'] as String? ??
        'Gardi backend responded successfully.';
  }

  static Future<Map<String, dynamic>> analyzeWardrobeItem({
    required String imagePath,
  }) async {
    final token = await _getIdToken();

    final file = File(imagePath);

    if (!await file.exists()) {
      throw Exception('Selected image could not be found.');
    }

    final bytes = await file.readAsBytes();
    final imageBase64 = base64Encode(bytes);

    final extension = imagePath
        .split('.')
        .last
        .toLowerCase();

    final String mimeType;

    switch (extension) {
      case 'png':
        mimeType = 'image/png';
        break;

      case 'webp':
        mimeType = 'image/webp';
        break;

      case 'jpg':
      case 'jpeg':
        mimeType = 'image/jpeg';
        break;

      default:
        throw Exception(
          'Unsupported image format: $extension',
        );
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/analyzeWardrobeItem'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'data': {
            'imageBase64': imageBase64,
            'mimeType': mimeType,
          },
        }),
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(
          'HTTP ${response.statusCode}: ${response.body}',
        );
      }

      final result = Map<String, dynamic>.from(
        decoded['result'] as Map,
      );

      if (result['success'] != true) {
        throw Exception(
          'Gardi could not analyze this item.',
        );
      }

      return Map<String, dynamic>.from(
        result['analysis'] as Map,
      );
    } catch (error) {
      throw Exception(
        'Gardi wardrobe analysis failed: $error',
      );
    }
  }

  static Future<Map<String, dynamic>> analyzeOutfit({
    required List<Map<String, dynamic>> items,
  }) async {
    if (items.length < 2) {
      throw Exception(
        'At least two wardrobe items are required.',
      );
    }

    final token = await _getIdToken();

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/analyzeOutfit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'data': {
            'items': items,
          },
        }),
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(
          'HTTP ${response.statusCode}: ${response.body}',
        );
      }

      final result = Map<String, dynamic>.from(
        decoded['result'] as Map,
      );

      if (result['success'] != true) {
        throw Exception(
          'Gardi could not analyze this outfit.',
        );
      }

      return Map<String, dynamic>.from(
        result['analysis'] as Map,
      );
    } catch (error) {
      throw Exception(
        'Gardi outfit analysis failed: $error',
      );
    }
  }
}