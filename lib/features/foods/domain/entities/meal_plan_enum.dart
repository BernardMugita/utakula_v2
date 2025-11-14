enum MealTypeEnum {
  breakfastOrSnack,
  lunchOrSupper,
  fruit,
  beverage;

  factory MealTypeEnum.fromString(String value) {
    switch (value) {
      case "breakfast or snack":
        return MealTypeEnum.breakfastOrSnack;
      case "lunch or supper":
        return MealTypeEnum.lunchOrSupper;
      case "fruit":
        return MealTypeEnum.fruit;
      case "beverage":
        return MealTypeEnum.beverage;
      default:
        throw Exception("Unknown meal type: $value");
    }
  }

  String toJson() {
    switch (this) {
      case MealTypeEnum.breakfastOrSnack:
        return "breakfast or snack";
      case MealTypeEnum.lunchOrSupper:
        return "lunch or supper";
      case MealTypeEnum.fruit:
        return "fruit";
      case MealTypeEnum.beverage:
        return "beverage";
    }
  }
}
