class ApiEndpoints {
  // -------------------- AUTH --------------------
  static const String signUp = "/utakula/validate/auth/create_account/";
  static const String signIn = "/utakula/validate/auth/authorize_account";

  // -------------------- USERS --------------------
  static const String getAllUsers = "/utakula/jamii/users/get_all_users";
  static const String getUserById = "/utakula/jamii/users/get_user_by_id";
  static const String editUserAccount = "/utakula/jamii/users/edit_account";
  static const String deleteUserAccount = "/utakula/jamii/users/delete_account";

  // -------------------- FOODS --------------------
  static const String addNewFood = "/utakula/chakula/foods/add_new_food";
  static const String getAllFoods = "/utakula/chakula/foods/get_all_foods";
  static const String getFoodById = "/utakula/chakula/foods/get_food_by_id";
  static const String editFood = "/utakula/chakula/foods/edit_food";
  static const String deleteFood = "/utakula/chakula/foods/delete_food";

  // -------------------- CALORIES --------------------
  static const String addCalorie = "/utakula/mawowowo/calories/add_calorie";
  static const String getAllCalories =
      "/utakula/mawowowo/calories/get_all_calories";
  static const String getCalorieByFoodId =
      "/utakula/mawowowo/calories/get_calorie_by_food_id";
  static const String updateCalorie =
      "/utakula/mawowowo/calories/update_calorie_info";

  // -------------------- MEAL PLANS --------------------
  static const String addMealPlan = "/utakula/ratiba/meal_plans/add_new_plan";
  static const String getUserMealPlan =
      "/utakula/ratiba/meal_plans/get_user_meal_plan";
  static const String updateMealPlan =
      "/utakula/ratiba/meal_plans/update_meal_plan";
  static const String fetchMemberMealPlans =
      "/utakula/ratiba/meal_plans/fetch_plans";

  // -------------------- INVITES --------------------
  static const String verifyEmailAddress =
      "/utakula/ombi/invite/verify_email_address";
  static const String sendOutInvites = "/utakula/ombi/invite/send_out_invites";

  // -------------------- AI --------------------
  static const String generateCustomRecipe = "/utakula/ai/genai/custom_recipe";
}
