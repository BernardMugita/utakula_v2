class TotalMacros {
  final double proteinGrams;
  final double carbohydrateGrams;
  final double fatGrams;
  final double fibreGrams;

  TotalMacros({
    required this.proteinGrams,
    required this.carbohydrateGrams,
    required this.fatGrams,
    required this.fibreGrams,
  });

  Map toJson() {
    return {
      'protein_g': proteinGrams,
      'carbs_g': carbohydrateGrams,
      'fat_g': fatGrams,
      'fiber_g': fibreGrams,
    };
  }

  factory TotalMacros.fromJson(Map<String, dynamic> json) {
    return TotalMacros(
      proteinGrams: json['protein_g'],
      carbohydrateGrams: json['carbs_g'],
      fatGrams: json['fat_g'],
      fibreGrams: json['fiber_g'],
    );
  }

  factory TotalMacros.fromEntity(TotalMacrosEntity entity) {
    return TotalMacros(
      proteinGrams: entity.proteinGrams,
      carbohydrateGrams: entity.carbohydrateGrams,
      fatGrams: entity.fatGrams,
      fibreGrams: entity.fibreGrams,
    );
  }
}

class TotalMacrosEntity {
  final double proteinGrams;
  final double carbohydrateGrams;
  final double fatGrams;
  final double fibreGrams;

  TotalMacrosEntity(
    this.proteinGrams,
    this.carbohydrateGrams,
    this.fatGrams,
    this.fibreGrams,
  );
}
