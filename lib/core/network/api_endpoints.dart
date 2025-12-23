class ApiEndpoints {
  // -------------------- AUTH --------------------
  static const String signUp = "/auth/create_account/";
  static const String signIn = "/auth/authorize_account";

  // -------------------- USERS --------------------
  static const String getAllUsers = "/users/get_all_users";
  static const String getUserAccount = "/users/get_user_account";
  static const String editUserAccount = "/users/edit_account";
  static const String deleteUserAccount = "/users/delete_account";

  // -------------------- FOODS --------------------
  static const String addNewFood = "/foods/add_new_food";
  static const String getAllFoods = "/foods/get_all_foods";
  static const String getFoodById = "/foods/get_food_by_id";
  static const String editFood = "/foods/edit_food";
  static const String deleteFood = "/foods/delete_food";

  // -------------------- CALORIES --------------------
  static const String addCalorie = "/calories/add_calorie";
  static const String getAllCalories = "/calories/get_all_calories";
  static const String getCalorieByFoodId = "/calories/get_calorie_by_food_id";
  static const String updateCalorie = "/calories/update_calorie_info";

  // -------------------- MEAL PLANS --------------------
  static const String addMealPlan = "/meal_plans/add_new_plan";
  static const String getUserMealPlan = "/meal_plans/get_user_meal_plan";
  static const String suggestMealPlan = "/meal_plans/suggest_plan";
  static const String updateMealPlan = "/meal_plans/update_meal_plan";
  static const String fetchMemberMealPlans = "/meal_plans/fetch_plans";

  // -------------------- INVITES --------------------
  static const String verifyEmailAddress = "/invite/verify_email_address";
  static const String sendOutInvites = "/invite/send_out_invites";

  // -------------------- AI --------------------
  static const String preparationInstructions = "/genai/preparation_instructions";
  static const String generateCustomRecipe = "/genai/custom_recipe";
}
