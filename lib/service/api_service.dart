// api_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'session_manager.dart';

class ApiService extends GetxController {
  final SessionManager _sessionManager = Get.find<SessionManager>();
  var dio = Dio();

  String get baseUrl => _sessionManager.baseUrl.value;

  Future<Map<String, dynamic>> postRequest({
    required String endpoint,
    required Map<String, dynamic> body,
    Duration timeout = const Duration(seconds: 90),
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse(baseUrl + endpoint);

    try {
      if (endpoint.isEmpty) {
        throw ArgumentError('Endpoint cannot be empty');
      }

      debugPrint('Request URL: $url');
      debugPrint('Request Body: $body');

      final request = http.Request('POST', url);
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': token.isNotEmpty ? 'Bearer $token' : '',
        'Accept': 'application/json',
      });

      request.body = json.encode(body);

      final streamedResponse = await request.send().timeout(
        timeout,
        onTimeout: () {
          throw TimeoutException('The connection has timed out');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      final Map<String, dynamic> responseData;
      try {
        responseData = json.decode(response.body);
      } catch (e) {
        throw const FormatException('Invalid response format');
      }

      switch (response.statusCode) {
        case 200:
          return responseData;
        case 400:
          throw BadRequestException(responseData['message'] ?? 'Bad Request: Invalid input');
        case 401:
          await _sessionManager.logout();
          throw UnauthorizedException(responseData['message'] ?? 'Unauthorized: Invalid credentials');
        case 403:
          throw ForbiddenException(responseData['message'] ?? 'Forbidden: Access denied');
        case 404:
          throw NotFoundException(responseData['message'] ?? 'Not Found: Resource does not exist');
        case 500:
          throw ServerException(responseData['message'] ?? 'Internal Server Error');
        default:
          throw HttpException('Unexpected error occurred: ${response.statusCode}');
      }
    } catch (e) {
      // Re-throw specific exceptions
      if (e is TimeoutException) {
        throw NetworkException('Connection timed out. Please check your internet.');
      } else if (e is SocketException) {
        throw NetworkException('No internet connection. Please try again.');
      } else if (e is FormatException) {
        throw const FormatException('Invalid response format. Please try again.');
      } else if (e is UnauthorizedException ||
          e is BadRequestException ||
          e is ForbiddenException ||
          e is NotFoundException ||
          e is ServerException) {
        rethrow;
      }
      throw NetworkException('An unexpected error occurred. Please try again.');
    }
  }

  // Helper method for date range reports
  Future<Map<String, dynamic>> fetchDateRangeReport({
    required String endpoint,
    required String fromDate,
    required String toDate,
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
