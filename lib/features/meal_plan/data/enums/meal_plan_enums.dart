// Enums matching your backend
enum BodyGoal {
  weightLoss('Weight Loss', 'WEIGHT_LOSS'),
  muscleGain('Muscle Gain', 'MUSCLE_GAIN'),
  maintenance('Maintenance', 'MAINTENANCE');

  final String display;
  final String value;

  const BodyGoal(this.display, this.value);
}

enum DietaryRestriction {
  vegan('Vegan', 'vegan'),
  vegetarian('Vegetarian', 'vegetarian'),
  pescatarian('Pescatarian', 'pescatarian'),
  glutenFree('Gluten Free', 'gluten_free'),
  dairyFree('Dairy Free', 'dairy_free'),
  nutFree('Nut Free', 'nut_free'),
  halal('Halal', 'halal'),
  kosher('Kosher', 'kosher'),
  keto('Keto', 'keto'),
  paleo('Paleo', 'paleo');

  final String display;
  final String value;

  const DietaryRestriction(this.display, this.value);
}

enum FoodAllergy {
  gluten('Gluten', 'gluten'),
  dairy('Dairy', 'dairy'),
  eggs('Eggs', 'eggs'),
  peanuts('Peanuts', 'peanuts'),
  treeNuts('Tree Nuts', 'tree_nuts'),
  soy('Soy', 'soy'),
  shellfish('Shellfish', 'shellfish'),
  fish('Fish', 'fish'),
  sesame('Sesame', 'sesame'),
  wheat('Wheat', 'wheat');

  final String display;
  final String value;

  const FoodAllergy(this.display, this.value);
}

enum MedicalDietaryCondition {
  diabetes('Diabetes', 'diabetes'),
  hypertension('Hypertension', 'hypertension'),
  highCholesterol('High Cholesterol', 'high_cholesterol'),
  celiacDisease('Celiac Disease', 'celiac_disease'),
  lactoseIntolerance('Lactose Intolerance', 'lactose_intolerance'),
  ibs('IBS', 'ibs'),
  gerd('GERD', 'gerd'),
  kidneyDisease('Kidney Disease', 'kidney_disease'),
  heartDisease('Heart Disease', 'heart_disease'),
  gout('Gout', 'gout');

  final String display;
  final String value;

  const MedicalDietaryCondition(this.display, this.value);
}