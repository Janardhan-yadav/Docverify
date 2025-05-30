import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/validation_response.dart';
import 'dart:io';

class ApiService {
  static const String baseUrl =
      'http://192.168.29.107:8000'; // Update this if your backend is hosted elsewhere

  Future<ValidationResponse> validateDocument({
    required String docType,
    required Map<String, String> formData,
    required File file,
    required String userId, // Add userId parameter
  }) async {
    try {
      // Get Firebase authentication token
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      final token = await user.getIdToken();

      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/validate'),
      );

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';

      // Add fields
      request.fields['doc_type'] = docType;
      request.fields['form_data'] = jsonEncode(formData);
      request.fields['user_id'] = userId; // Add user_id to the request

      // Add the file
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType('application', 'octet-stream'),
        ),
      );

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Parse the response
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return ValidationResponse.fromJson(jsonResponse);
      } else {
        throw Exception(
          'Failed to validate document: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error validating document: $e');
    }
  }
}
