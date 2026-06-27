import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://shieldnet-backend.onrender.com';
  static const Duration _timeout = Duration(seconds: 60);
  static const String adminToken = 'shieldnet_admin_token_2025';

  static Future<Map<String, dynamic>> submitReport({
    required String country,
    String contact = '',
    required String category,
    required String platform,
    required String description,
    String harasserUsername = '',
    String harasserProfileUrl = '',
  }) async {
    final uri = Uri.parse('$baseUrl/api/report');
    final body = jsonEncode({
      'country': country,
      'contact': contact,
      'category': category,
      'platform': platform,
      'description': description,
      'harasser_username': harasserUsername,
      'harasser_profile_url': harasserProfileUrl,
    });

    final response = await http
        .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
        .timeout(_timeout);

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> trackCase(String token) async {
    final uri = Uri.parse('$baseUrl/api/track/$token');
    final response = await http.get(uri).timeout(_timeout);
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> analyzeReportText(int reportId) async {
    final uri = Uri.parse('$baseUrl/api/analyze/$reportId');
    final response = await http.post(uri).timeout(_timeout);
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> analyzeReportImages({
    required int reportId,
    required File originalImage,
    required File fakeImage,
  }) async {
    final uri = Uri.parse('$baseUrl/api/analyze/$reportId');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(
      await http.MultipartFile.fromPath('original', originalImage.path),
    );
    request.files.add(
      await http.MultipartFile.fromPath('fake', fakeImage.path),
    );
    final streamedResponse = await request.send().timeout(_timeout);
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response);
  }

  static String generatePdfUrl(int reportId) {
    return '$baseUrl/api/generate-pdf/$reportId';
  }

  static Future<Map<String, dynamic>> getStats() async {
    final uri = Uri.parse('$baseUrl/api/stats');
    final response = await http.get(uri).timeout(_timeout);
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> adminLogin({
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/api/admin/login');
    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'username': username, 'password': password}),
        )
        .timeout(_timeout);
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> adminGetAllReports() async {
    final uri = Uri.parse('$baseUrl/api/admin/reports');
    final response = await http
        .get(uri, headers: {'Authorization': 'Bearer $adminToken'})
        .timeout(_timeout);
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> adminUpdateCase({
    required int caseId,
    required String status,
    String notes = '',
  }) async {
    final uri = Uri.parse('$baseUrl/api/admin/case/$caseId');
    final response = await http
        .put(
          uri,
          headers: {
            'Authorization': 'Bearer $adminToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'status': status, 'notes': notes}),
        )
        .timeout(_timeout);
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> adminGetHarassers() async {
    final uri = Uri.parse('$baseUrl/api/admin/harassers');
    final response = await http
        .get(uri, headers: {'Authorization': 'Bearer $adminToken'})
        .timeout(_timeout);
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> adminSendDmca(int reportId) async {
    final uri = Uri.parse('$baseUrl/api/send-dmca/$reportId');
    final response = await http
        .post(uri, headers: {'Authorization': 'Bearer $adminToken'})
        .timeout(_timeout);
    return _handleResponse(response);
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final decoded = response.body.isNotEmpty
        ? jsonDecode(response.body) as Map<String, dynamic>
        : <String, dynamic>{};

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: decoded['error']?.toString() ??
            decoded['message']?.toString() ??
            'Something went wrong. Please try again.',
      );
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => message;
}

class ShieldNetValues {
  static const List<String> categories = [
    'Fake / edited photo',
    'Deepfake video',
    'Impersonation',
    'Sexual harassment',
    'Stalking',
    'Threats',
    'Identity theft',
  ];

  static const List<String> platforms = [
    'facebook',
    'instagram',
    'tiktok',
    'twitter',
    'snapchat',
    'youtube',
    'other',
  ];

  static const List<String> imageBasedCategories = [
    'Fake / edited photo',
    'Deepfake video',
  ];

  static const List<String> statusSteps = [
    'Submitted',
    'Evidence Verified',
    'Under Review',
    'Takedown Sent',
    'Resolved',
  ];
}