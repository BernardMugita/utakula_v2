import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/core/error/exceptions.dart';
import 'package:utakula_v2/core/network/api_endpoints.dart';
import 'package:utakula_v2/core/network/dio_client.dart';
import 'package:utakula_v2/features/meal_plan/data/models/meal_plan_model.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/meal_plan_entity.dart';

abstract class MealPlanDataSource {
  Future<MealPlanEntity> createMealPlan(MealPlanEntity mealPlanEntity);

  Future<MealPlanEntity> getUserMealPlan();

  Future<MealPlanEntity> updateUserMealPlan(MealPlanEntity mealPlanEntity);
}

class MealPlanDataSourceImpl implements MealPlanDataSource {
  final DioClient dioClient;
  Logger logger = Logger();

  MealPlanDataSourceImpl(this.dioClient);

  // ---------------------------------------------------------------------------
  // Create Meal plan data source
  // ---------------------------------------------------------------------------

  @override
  Future<MealPlanEntity> createMealPlan(MealPlanEntity mealPlanEntity) async {
    try {
      final mealPlanModel = MealPlanModel.fromEntity(mealPlanEntity);

      final response = await dioClient.post(
        ApiEndpoints.addMealPlan,
        data: mealPlanModel.toJson(),
      );

      final payload = response.data['payload'];

      return MealPlanModel.fromJson(payload).toEntity();
    } on DioException catch (e) {
      throw _handleException(e);
    } catch (e) {
      throw ServerException("Unexpected error: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // Get Meal plan data source
  // ---------------------------------------------------------------------------

  @override
  Future<MealPlanEntity> getUserMealPlan() async {
    try {
      final response = await dioClient.post(ApiEndpoints.getUserMealPlan);

      final payload = response.data['payload'];

      return MealPlanModel.fromJson(payload).toEntity();
    } on DioException catch (e) {
      throw _handleException(e);
    } catch (e) {
      throw ServerException("Unexpected error: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // Update Meal plan data source
  // ---------------------------------------------------------------------------

  @override
  Future<MealPlanEntity> updateUserMealPlan(
    MealPlanEntity mealPlanEntity,
  ) async {
    final updatedUserMealPlanModel = MealPlanModel.fromEntity(mealPlanEntity);

    try {
      final response = await dioClient.post(
        ApiEndpoints.updateMealPlan,
        data: updatedUserMealPlanModel.toJson(),
      );
      final payload = response.data['payload'];

      return MealPlanModel.fromJson(payload).toEntity();
    } on DioException catch (e) {
      throw _handleException(e);
    } catch (e) {
      throw ServerException("Unexpected error: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // Handle exceptions
  // ---------------------------------------------------------------------------

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
