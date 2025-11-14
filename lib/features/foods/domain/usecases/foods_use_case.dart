import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/food_entity.dart';
import '../repositories/foods_repository.dart';

class GetFoods {
  final FoodsRepository repository;

  GetFoods(this.repository);

  Future<Either<Failure, List<FoodEntity>>> call() async {
    return await repository.getAllFoods();
  }
}

class GetFoodById {
  final FoodsRepository repository;

  GetFoodById(this.repository);

  Future<Either<Failure, FoodEntity>> call(String foodId) async {
    return await repository.getFoodById(foodId);
  }
}

class CreateFood {
  final FoodsRepository repository;

  CreateFood(this.repository);

  Future<Either<Failure, FoodEntity>> call(FoodEntity food) async {
    return await repository.createFood(food);
  }
}

class UpdateFood {
  final FoodsRepository repository;

  UpdateFood(this.repository);

  Future<Either<Failure, FoodEntity>> call(
    String foodId,
    FoodEntity updatedFood,
  ) async {
    return await repository.updateFood(updatedFood);
  }
}

class DeleteFood {
  final FoodsRepository repository;

  DeleteFood(this.repository);

  Future<Either<Failure, void>> call(String foodId) async {
    return await repository.deleteFood(foodId);
  }
}
