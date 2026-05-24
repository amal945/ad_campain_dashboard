import 'dart:convert';
import 'dart:developer';

import 'package:ad_campaign_dashboard/core/config/app_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  DioClient() : _dio = Dio(BaseOptions(baseUrl: AppConfig.baseUrl)) {
    _dio.options
      ..connectTimeout = AppConfig.connectionTimeout
      ..receiveTimeout = AppConfig.receiveTimeout
      ..sendTimeout = AppConfig.connectionTimeout;

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _ApiDebugPrinter.printRequest(options);
          handler.next(options);
        },
        onResponse: (response, handler) {
          response.data = _ApiDebugPrinter.decodeJsonStringIfNeeded(response.data);
          _ApiDebugPrinter.printResponse(response);
          handler.next(response);
        },
        onError: (error, handler) {
          _ApiDebugPrinter.printError(error);
          handler.next(error);
        },
      ),
    );
  }

  final Dio _dio;

  Dio get instance => _dio;
}

abstract final class _ApiDebugPrinter {
  static final JsonEncoder _prettyJson = const JsonEncoder.withIndent('  ');

  static void printRequest(RequestOptions options) {
    if (!kDebugMode) {
      return;
    }
    _printBlock('''
======== API REQUEST ========
${options.method} ${options.baseUrl}${options.path}
Query: ${_pretty(options.queryParameters)}
Headers: ${_pretty(options.headers)}
Body: ${_pretty(options.data)}
=============================
''');
  }

  static void printResponse(Response<dynamic> response) {
    if (!kDebugMode) {
      return;
    }
    _printBlock('''
======== API RESPONSE =======
${response.requestOptions.method} ${response.requestOptions.baseUrl}${response.requestOptions.path}
Status: ${response.statusCode}
Data: ${_pretty(response.data)}
=============================
''');
  }

  static void printError(DioException error) {
    if (!kDebugMode) {
      return;
    }
    _printBlock('''
========= API ERROR =========
${error.requestOptions.method} ${error.requestOptions.baseUrl}${error.requestOptions.path}
Type: ${error.type}
Status: ${error.response?.statusCode}
Message: ${error.message}
Response: ${_pretty(error.response?.data)}
=============================
''');
  }

  static String _pretty(Object? data) {
    if (data == null) {
      return 'null';
    }
    if (data is Map || data is List) {
      try {
        return _prettyJson.convert(data);
      } catch (_) {
        return data.toString();
      }
    }
    return data.toString();
  }

  static Object? decodeJsonStringIfNeeded(Object? data) {
    if (data is! String) {
      return data;
    }
    final trimmed = data.trimLeft();
    if (!(trimmed.startsWith('{') || trimmed.startsWith('['))) {
      return data;
    }
    try {
      return jsonDecode(data);
    } catch (_) {
      return data;
    }
  }

  static void _printBlock(String message) {
    for (final line in message.split('\n')) {
      if (line.isEmpty) {
        continue;
      }
      log(line, name: 'API_DEBUG');
    }
  }
}
