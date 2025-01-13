// api_service.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:evoucher/service/session_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  String baseUrl = "https://evoucher.pk/api-new/";
  final String baseUrl2 = "https://evoucher.pk/api-test/";

  void updateBaseUrl(String url) {
    baseUrl = url;
  }


  var dio = Dio();

  // Reuse the existing `postLogin` method pattern for a generic POST request
  Future<Map<String, dynamic>> postData({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse(baseUrl + endpoint);

    try {
      // Print request details for debugging
      debugPrint('Request URL: $url');
      debugPrint('Request Body: $body');

      // Create request
      final request = http.Request('POST', url);
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': token.isNotEmpty ? "Bearer $token" : "",
      });

      // Set the request body
      request.body = json.encode(body);

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Print response for debugging
      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Request failed');
      }
    } catch (e) {
      debugPrint('API Error: $e');
      throw Exception('Network error: Please check your internet connection');
    }
  }

  Future<Map<String, dynamic>> postLogin(
      {required String endpoint, required Map<String, dynamic> body}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse(baseUrl + endpoint);

    try {
      // Validate input parameters
      if (endpoint.isEmpty) {
        throw ArgumentError('Endpoint cannot be empty');
      }

      // Print request details for debugging (only in debug mode)
      debugPrint('Request URL: $url');
      debugPrint('Request Body: $body');

      // Create request with timeout
      final request = http.Request('POST', url);
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': token.isNotEmpty ? 'Bearer $token' : '',
        'Accept': 'application/json',
      });

      // Set the request body
      request.body = json.encode(body);

      // Send the request with a timeout
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('The connection has timed out');
        },
      );

      // Convert streamed response to a regular response
      final response = await http.Response.fromStream(streamedResponse);

      // Print response for debugging (only in debug mode)
      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      // Parse the response body
      final Map<String, dynamic> responseData;
      try {
        responseData = json.decode(response.body);
      } catch (e) {
        throw const FormatException('Invalid response format');
      }

      // Handle different types of errors
      switch (response.statusCode) {
        case 200:
          return responseData;
        case 400:
          throw BadRequestException(
              responseData['message'] ?? 'Bad Request: Invalid input');
        case 401:
          // Handle token expiration
          final sessionManager = Get.find<SessionManager>();
          await sessionManager.logout();
          throw UnauthorizedException(
              responseData['message'] ?? 'Unauthorized: Invalid credentials');
        case 403:
          throw ForbiddenException(
              responseData['message'] ?? 'Forbidden: Access denied');
        case 404:
          throw NotFoundException(
              responseData['message'] ?? 'Not Found: Resource does not exist');
        case 500:
          throw ServerException(
              responseData['message'] ?? 'Internal Server Error');
        default:
          throw HttpException(
              'Unexpected error occurred: ${response.statusCode}');
      }
    } on TimeoutException {
      throw NetworkException(
          'Connection timed out. Please check your internet.');
    } on SocketException {
      throw NetworkException('No internet connection. Please try again.');
    } catch (e) {
      // Log the error (consider using a proper logging mechanism)
      debugPrint('Login Error: $e');

      // Rethrow specific exceptions or wrap generic ones
      if (e is UnauthorizedException) {
        rethrow;
      }

      throw NetworkException('An unexpected error occurred. Please try again.');
    }
  }

  Future<Map<String, dynamic>> fetchAccounts({String? subheadName}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse('${baseUrl}fetchAccounts');

    try {
      // Prepare the request body
      final body = subheadName != null ? {"subhead_name": subheadName} : {};

      // Print request details for debugging
      print('Request URL: $url');
      print('Request Body: $body');

      // Create request
      final request = http.Request('POST', url);

      // Add headers
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': token.isNotEmpty ? "Bearer $token" : "",
      });

      // Set the request body
      request.body = json.encode(body);

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Print response for debugging
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
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

  Future<Map<String, dynamic>> fetchAccountLedger(
      {required String accountId,
      required String fromDate,
      required String toDate}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse('${baseUrl}accountLedger');

    try {
      // Prepare the request body
      final body = {
        "account_id": accountId,
        "from_date": fromDate,
        "to_date": toDate
      };

      // Print request details for debugging
      print('Request URL: $url');
      print('Request Body: $body');

      // Create request
      final request = http.Request('POST', url);

      // Add headers
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': token.isNotEmpty ? "Bearer $token" : "",
      });

      // Set the request body
      request.body = json.encode(body);

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Print response for debugging
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
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

  // get unposted data
  Future<Map<String, dynamic>?> fetchVoucherUnPosted({
    required String fromDate,
    required String toDate,
    required String voucherId,
    required String voucherType,
  }) async {
    // Get the token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    // Define headers
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token.isNotEmpty ? "Bearer $token" : "",
    };

    // Encode data
    var data = {
      "fromDate": fromDate,
      "toDate": toDate,
      "voucher_id": voucherId,
      "voucher_type": voucherType,
    };

    try {
      // Send request
      var response = await dio.post(
        "${baseUrl}getVoucherUnPosted",
        options: Options(
          headers: headers,
        ),
        data: data,
      );

      // Handle response
      if (response.statusCode == 200) {
        print('Response data: ${response.data}');

        if (response.data['status'] == 'success') {
          print('Response data: ${response.data}');

          return response.data as Map<String, dynamic>;
        } else {
          throw Exception(response.data['message'] ?? 'Request failed');
        }
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error: $e");
      throw Exception('Failed to fetch unposted vouchers: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchDailyActivity({
    required String fromDate,
    required String toDate,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    // Define headers
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token.isNotEmpty ? "Bearer $token" : "",
    };

    // Request payload
    var data = {
      "fromDate": fromDate,
      "toDate": toDate,
    };

    try {
      // Send POST request
      var response = await dio.post(
        "${baseUrl2}dailyActivity",
        options: Options(headers: headers),
        data: data,
      );

      // Handle response
      if (response.statusCode == 200) {
        print(response.data);
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print("API Error: $e");
      throw Exception('Failed to fetch daily activity: $e');
    }
  }
}

// Custom Exception Classes
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => message;
}

class BadRequestException implements Exception {
  final String message;
  BadRequestException(this.message);

  @override
  String toString() => message;
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);

  @override
  String toString() => message;
}

class ForbiddenException implements Exception {
  final String message;
  ForbiddenException(this.message);

  @override
  String toString() => message;
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);

  @override
  String toString() => message;
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() => message;
}
