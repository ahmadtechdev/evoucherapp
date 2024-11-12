// api_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = "https://evoucher.pk/api/";

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse(baseUrl + endpoint);

    try {
      // Print request details for debugging
      print('Request URL: $url');
      print('Request Body: $body');

      // Create multipart request
      final request = http.MultipartRequest('POST', url);

      // Add headers
      request.headers.addAll({
        "Authorization": token.isNotEmpty ? "Bearer $token" : "",
      });

      // Add form fields
      body.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Print response for debugging
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('Response Headers: ${response.headers}');

      final responseData = Map<String, dynamic>.from(
        json.decode(response.body),
      );

      if (response.statusCode == 200) {
        return responseData;
      } else {
        String errorMessage = responseData['message'] ?? 'Request failed';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Network error: $e');
      throw Exception('Network error: Please check your internet connection');
    }
  }


  Future<Map<String, dynamic>> get(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse(baseUrl + endpoint);
    print(url);

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print(response);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // Extract error message from response body if possible
        String errorMessage = 'Failed to load data';
        try {
          final errorResponse = jsonDecode(response.body);
          errorMessage = errorResponse['message'] ?? errorMessage;
        } catch (e) {
          // Handle JSON parsing error
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      // Handle network errors or other unexpected issues
      throw Exception('Network error or unexpected issue: $e');
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse(baseUrl + endpoint);

    try {
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        String errorMessage = 'Failed to delete item';
        try {
          final errorResponse = jsonDecode(response.body);
          errorMessage = errorResponse['message'] ?? errorMessage;
        } catch (e) {
          // Handle JSON parsing error
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

