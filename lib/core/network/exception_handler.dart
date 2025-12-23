import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/core/error/exceptions.dart';

class ExceptionHandler {
  Logger logger = Logger();

  Exception handleException(DioException e) {
    if (e.response != null) {
      logger.e("Server error: ${e.response?.data}");
      return ServerException(
        e.response?.data['message'] ?? e.message ?? "Server error",
      );
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      logger.e("Connection timeout: ${e.message}");
      return NetworkException("Connection timeout");
    } else if (e.type == DioExceptionType.connectionError) {
      logger.e("No internet: ${e.message}");
      return NetworkException("No internet connection");
    } else {
      logger.e("Unknown error: ${e.message}");
      return ServerException(e.message ?? "Unknown error occurred");
    }
  }
}
