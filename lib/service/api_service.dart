// api_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = "https://evoucher.pk/api/";

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? ''; // Retrieve the token

    if (token.isEmpty) {
      throw Exception('Token is missing');
    }

    final url = Uri.parse(baseUrl + endpoint);

    try {
      // Print request details for debugging
      print('Request URL: $url');
      print('Request Body: $body');

      // Create multipart request
      final request = http.MultipartRequest('POST', url);

      // Add headers
      request.headers.addAll({
        "Authorization": token.isNotEmpty ? "Bearer $token" : "", // Add the token to headers if needed
      });

      // Add the token to the body (as required by your API)
      body['token'] = token;

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
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? queryParams}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    // Create URL with query parameters
    final uri = Uri.parse(baseUrl + endpoint).replace(
      queryParameters: {
        'token': token,
        ...?queryParams,
      },
    );

    try {
      // Print request details for debugging
      print('Request URL: $uri');

      final response = await http.get(
        uri,
        headers: {
          "Authorization": token.isNotEmpty ? "Bearer $token" : "",
        },
      );

      // Print response for debugging
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

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
}



