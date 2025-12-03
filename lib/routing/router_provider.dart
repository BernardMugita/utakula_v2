import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utakula_v2/core/providers/session_provider/session_state_provider.dart';
import 'package:utakula_v2/features/foods/presentation/pages/add_foods.dart';
import 'package:utakula_v2/features/foods/presentation/pages/food.dart';
import 'package:utakula_v2/features/homepage/presentation/pages/homepage.dart';
import 'package:utakula_v2/features/login/presentation/pages/login.dart';
import 'package:utakula_v2/features/meal_plan/presentation/pages/day_meal_plan.dart';
import 'package:utakula_v2/features/meal_plan/presentation/pages/meal_plan_controller.dart';
import 'package:utakula_v2/features/register/presentation/pages/register.dart';
import 'package:utakula_v2/routing/routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final session = ref.watch(sessionStateProvider);

  return GoRouter(
    initialLocation: Routes.login,
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = session.status == SessionStatus.authenticated;
      final bool loggingIn =
          state.matchedLocation == Routes.login ||
          state.matchedLocation == Routes.register;

      if (!loggedIn) {
        return loggingIn ? null : Routes.login;
      }

      if (loggingIn) {
        return Routes.home;
      }

      return null;
    },
    routes: [
      GoRoute(path: Routes.login, builder: (context, state) => const Login()),
      GoRoute(
        path: Routes.register,
        builder: (context, state) => const Register(),
      ),
      GoRoute(path: Routes.home, builder: (context, state) => const Homepage()),
      GoRoute(
        path: Routes.foods,
        builder: (context, state) => const Foods(),
        routes: [
          GoRoute(
            path: Routes.addFoods,
            builder: (context, state) => const AddFoods(),
          ),
        ],
      ),
      GoRoute(
        path: Routes.newPlan,
        builder: (context, state) => const MealPlanController(),
        routes: [
          GoRoute(
            path: Routes.dayMealPlan,
            builder: (context, state) => DayMealPlan(
              day: "",
              meals: state.extra as Map<String, dynamic>,
              onSave: (meals) {},
            ),
          ),
        ],
      ),
    ],
  );
});
