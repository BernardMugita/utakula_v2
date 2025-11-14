class CalorieEntity {
  final String id;
  final String foodId;
  final int total;
  final Map<String, dynamic> breakdown;

  const CalorieEntity({
    required this.id,
    required this.foodId,
    required this.total,
    required this.breakdown,
  });
}
