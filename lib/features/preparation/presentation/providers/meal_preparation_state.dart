class MealPreparationState {
  final bool isLoading;
  final List<String> instructions;
  final String? errorMessage;

  const MealPreparationState({
    this.isLoading = false,
    this.instructions = const [],
    this.errorMessage,
  });

  MealPreparationState copyWith({
    bool? isLoading,
    List<String>? instructions,
    String? errorMessage,
  }) {
    return MealPreparationState(
      isLoading: isLoading ?? this.isLoading,
      instructions: instructions ?? this.instructions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}