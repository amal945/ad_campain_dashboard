import 'package:ad_campaign_dashboard/core/utils/result.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class RequestHandler {
  Future<Result<T>> handle<T>(Future<T> Function() call) async {
    try {
      final response = await call();
      return Success<T>(response);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return Failure<T>('Request timed out. Please try again.');
      }
      if (e.type == DioExceptionType.connectionError) {
        return Failure<T>('No internet connection.');
      }
      final statusCode = e.response?.statusCode ?? 0;
      if (statusCode >= 500) {
        return Failure<T>('Server error. Please try again later.');
      }
      final responseData = e.response?.data;
      String? message;
      if (responseData is Map<String, dynamic>) {
        message = responseData['message']?.toString();
      } else if (responseData is String && responseData.trim().isNotEmpty) {
        message = responseData;
      }
      return Failure<T>(message ?? 'Request failed.');
    } catch (e) {
      if (kDebugMode) {
        return Failure<T>('Unexpected parsing/cache error: $e');
      }
      return Failure<T>('Something went wrong. Please try again.');
    }
  }
}
