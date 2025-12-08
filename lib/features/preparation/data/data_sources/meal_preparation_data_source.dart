import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/common/helpers/helper_utils.dart';
import 'package:utakula_v2/core/error/exceptions.dart';
import 'package:utakula_v2/core/network/api_endpoints.dart';
import 'package:utakula_v2/core/network/dio_client.dart';
import 'package:utakula_v2/features/preparation/data/models/meal_preparation_model.dart';
import 'package:utakula_v2/features/preparation/domain/entities/meal_preparation_entity.dart';

abstract class MealPreparationDataSource {
  Future getPreparationInstructions(MealPreparationEntity mealPrepEntity);

  Future getCustomRecipeInstructions(String prompt);
}

class MealPreparationDataSourceImpl implements MealPreparationDataSource {
  final DioClient dioClient;
  Logger logger = Logger();
  HelperUtils helperUtils = HelperUtils();

  MealPreparationDataSourceImpl(this.dioClient);

  // --------------------------------------------------------------------
  // Get Preparation Instructions
  // --------------------------------------------------------------------

  @override
  Future getPreparationInstructions(
    MealPreparationEntity mealPrepEntity,
  ) async {
    try {
      final mealPrepModel = MealPreparationModel.fromEntity(mealPrepEntity);

      final response = await dioClient.post(
        ApiEndpoints.preparationInstructions,
        data: mealPrepModel.toJson(),
      );

      final payload = response.data['payload'];

      return payload;
    } on DioException catch (e) {
      throw helperUtils.handleException(e);
    } catch (e) {
      throw ServerException("Unexpected error: $e");
    }
  }

  @override
  Future getCustomRecipeInstructions(String prompt) async {}
}
