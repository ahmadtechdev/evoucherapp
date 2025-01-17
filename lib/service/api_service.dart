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

import '../views/authentication/cotnroller/auth_controller.dart';

class ApiService {
  final controller = Get.put(AuthController());

  var dio = Dio();

  // Generic function for date range based reports
  Future<Map<String, dynamic>> postRequest({
    required String endpoint,
    required Map<String, dynamic> body,
    // String? baseUrlOverride,
    Duration timeout = const Duration(seconds: 90),
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    // final url = Uri.parse((baseUrlOverride ?? baseUrl2) + endpoint);
    final url = Uri.parse((controller.baseUrl.value) + endpoint);

    try {
      // Validate input parameters
      if (endpoint.isEmpty) {
        throw ArgumentError('Endpoint cannot be empty');
      }

      // Print request details for debugging
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
        timeout,
        onTimeout: () {
          throw TimeoutException('The connection has timed out');
        },
      );

      // Convert streamed response to a regular response
      final response = await http.Response.fromStream(streamedResponse);

      // Print response for debugging
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
    } on FormatException catch (e) {
      debugPrint('Format Error: $e');
      throw FormatException('Invalid response format. Please try again.');
    } catch (e) {
      // Log the error (consider using a proper logging mechanism)
      debugPrint('API Error: $e');

      // Rethrow specific exceptions or wrap generic ones
      if (e is UnauthorizedException ||
          e is BadRequestException ||
          e is ForbiddenException ||
          e is NotFoundException ||
          e is ServerException) {
        rethrow;
      }

      throw NetworkException('An unexpected error occurred. Please try again.');
    }
  }

  // Helper function for date range based reports using the enhanced postRequest
  Future<Map<String, dynamic>> fetchDateRangeReport({
    required String endpoint,
    required String fromDate,
    required String toDate,
    // String? baseUrlOverride,
    Map<String, dynamic>? additionalParams,
  }) async {
    final body = {
      "fromDate": fromDate,
      "toDate": toDate,
      if (additionalParams != null) ...additionalParams,
    };

    return await postRequest(
      endpoint: endpoint,
      body: body,
      // baseUrlOverride: baseUrlOverride ?? baseUrl2,
    );
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
