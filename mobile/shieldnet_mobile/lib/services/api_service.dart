import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://shieldnet-backend.onrender.com';
  static const Duration timeout = Duration(seconds: 60);

  static Future<Map<String, dynamic>> getStats() async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/stats'))
        .timeout(timeout);
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Failed to load stats');
  }

  static Future<Map<String, dynamic>> submitReport({
    required String country,
    required String category,
    required String platform,
    required String description,
    required String harasserUsername,
    String harasserProfileUrl = '',
    String contact = '',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/report'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'country': country,
        'category': category,
        'platform': platform,
        'description': description,
        'harasser_username': harasserUsername,
        'harasser_profile_url': harasserProfileUrl,
        'contact': contact,
      }),
    ).timeout(timeout);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to submit report');
  }

  static Future<Map<String, dynamic>> trackCase(String token) async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/track/$token'))
        .timeout(timeout);
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Token not found');
  }

  static Future<Map<String, dynamic>> analyzeReport(int reportId) async {
    final response = await http
        .post(Uri.parse('$baseUrl/api/analyze/$reportId'))
        .timeout(timeout);
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Analysis failed');
  }

  static Future<Map<String, dynamic>> analyzeReportWithImages({
    required int reportId,
    required File originalImage,
    required File fakeImage,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/analyze/$reportId'),
    );
    request.files.add(
        await http.MultipartFile.fromPath('original', originalImage.path));
    request.files.add(
        await http.MultipartFile.fromPath('fake', fakeImage.path));
    final streamed = await request.send().timeout(timeout);
    final response = await http.Response.fromStream(streamed);
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Image analysis failed');
  }

  static String getPdfUrl(int reportId) {
    return '$baseUrl/api/generate-pdf/$reportId';
  }
}