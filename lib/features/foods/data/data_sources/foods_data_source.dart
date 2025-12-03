import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/features/foods/data/models/food_model.dart';
import 'package:utakula_v2/features/foods/domain/entities/food_entity.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';

abstract class FoodRemoteDataSource {
  Future<FoodEntity> createFood(FoodEntity foodEntity);

  Future<List<FoodEntity>> getAllFoods();

  Future<FoodEntity> getFoodById(String id);

  Future<FoodEntity> updateFood(FoodEntity foodEntity);

  Future<void> deleteFood(String id);
}

class FoodRemoteDataSourceImpl implements FoodRemoteDataSource {
  final DioClient dioClient;
  Logger logger = Logger();

  FoodRemoteDataSourceImpl(this.dioClient);

  // ---------------------------------------------------------------------------
  // CREATE FOOD
  // ---------------------------------------------------------------------------
  @override
  Future<FoodEntity> createFood(FoodEntity foodEntity) async {
    try {
      final foodModel = FoodModel.fromEntity(foodEntity);

      logger.log(Level.info, foodModel.toJson());

      final response = await dioClient.post(
        ApiEndpoints.addNewFood,
        data: foodModel.toJson(),
      );
      final payload = response.data['payload'];

      return FoodModel.fromJson(payload).toEntity();
    } on DioException catch (e) {
      throw _handleException(e);
    } catch (e) {
      throw ServerException("Unexpected error: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // GET ALL FOODS
  // ---------------------------------------------------------------------------
  @override
  Future<List<FoodEntity>> getAllFoods() async {
    try {
      final response = await dioClient.post(ApiEndpoints.getAllFoods);
      final List<dynamic> list = response.data['payload'];

      return list.map((item) => FoodModel.fromJson(item).toEntity()).toList();
    } on DioException catch (e) {
      throw _handleException(e);
    } catch (e) {
      throw ServerException("Unexpected error: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // GET FOOD BY ID
  // ---------------------------------------------------------------------------
  @override
  Future<FoodEntity> getFoodById(String id) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.getFoodById,
        data: {"id": id},
      );

      final payload = response.data['payload'];

      return FoodModel.fromJson(payload).toEntity();
    } on DioException catch (e) {
      throw _handleException(e);
    } catch (e) {
      throw ServerException("Unexpected error: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // UPDATE FOOD
  // ---------------------------------------------------------------------------
  @override
  Future<FoodEntity> updateFood(FoodEntity foodEntity) async {
    try {
      final foodModel = FoodModel.fromEntity(foodEntity);

      final response = await dioClient.post(
        ApiEndpoints.editFood,
        data: foodModel.toJson(),
      );

      final payload = response.data['payload'];

      return FoodModel.fromJson(payload).toEntity();
    } on DioException catch (e) {
      throw _handleException(e);
    } catch (e) {
      throw ServerException("Unexpected error: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE FOOD
  // ---------------------------------------------------------------------------
  @override
  Future<void> deleteFood(String id) async {
    try {
      await dioClient.post(ApiEndpoints.deleteFood, data: {"id": id});
      return;
    } on DioException catch (e) {
      throw _handleException(e);
    } catch (e) {
      throw ServerException("Unexpected error: $e");
    }
  }

  Exception _handleException(DioException e) {
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
