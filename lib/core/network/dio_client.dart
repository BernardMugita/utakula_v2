import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  late final Dio _dio;

  DioClient({String baseUrl = 'https://philanthropically-farsighted-malik.ngrok-free.dev'}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) {
          if (kDebugMode) {
            print(obj);
          }
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<Response> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) {
    return _dio.get(path, queryParameters: queryParameters, options: options);
  }

  Future<Response> post(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> put(
      String path, {
        dynamic data,
        Options? options,
      }) {
    return _dio.put(path, data: data, options: options);
  }

  Future<Response> delete(
      String path, {
        dynamic data,
        Options? options,
      }) {
    return _dio.delete(path, data: data, options: options);
  }
}