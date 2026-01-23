import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utakula_v2/core/providers/session_provider/session_state_provider.dart';
import 'package:utakula_v2/features/account/presentation/pages/user_account.dart';
import 'package:utakula_v2/features/foods/presentation/pages/add_foods.dart';
import 'package:utakula_v2/features/foods/presentation/pages/food.dart';
import 'package:utakula_v2/features/homepage/presentation/pages/homepage.dart';
import 'package:utakula_v2/features/login/presentation/pages/login.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/day_meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/presentation/pages/day_meal_plan.dart';
import 'package:utakula_v2/features/meal_plan/presentation/pages/meal_plan_controller.dart';
import 'package:utakula_v2/features/onboarding/presentation/pages/onboarding_controller.dart';
import 'package:utakula_v2/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:utakula_v2/features/preparation/presentation/pages/how_to_prepare.dart';
import 'package:utakula_v2/features/register/presentation/pages/register.dart';
import 'package:utakula_v2/features/reminders/presentation/pages/reminders.dart';
import 'package:utakula_v2/features/settings/presentation/pages/settings.dart';
import 'package:utakula_v2/routing/routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final session = ref.watch(sessionStateProvider);
  final onboarding = ref.watch(onboardingStateProvider);

  return GoRouter(
    initialLocation: Routes.login,
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = session.status == SessionStatus.authenticated;
      final bool loggingIn =
          state.matchedLocation == Routes.login ||
          state.matchedLocation == Routes.register;

      final bool isOnboarded =
          onboarding.status == OnboardingStatus.isOnboarded;

      if (!isOnboarded) {
        return Routes.onboarding;
      }

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
      GoRoute(
        path: Routes.onboarding,
        name: '/onboarding',
        builder: (context, state) => const OnboardingController(),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const Homepage(),
        routes: [
          GoRoute(
            path: Routes.newPlan,
            name: '/new-meal-plan',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final userMealPlan = extra?['userMealPlan'] as MealPlanEntity?;

              return MealPlanController(userMealPlan: userMealPlan);
            },
            routes: [
              GoRoute(
                path: Routes.dayMealPlan,
                name: '/new-meal-plan/day-meal-plan',
                builder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>;
                  final day = extra['day'] as String;
                  final meals = extra['meals'] as Map;
                  final onSaveCallback =
                      extra['onSave'] as Function(Map<dynamic, dynamic>, int);

                  return DayMealPlan(
                    day: day,
                    meals: meals,
                    onSave: (Map<String, dynamic> updatedMeals, double calories) {
                      int totalCalories = 0;

                      for (var mealType in updatedMeals.values) {
                        if (mealType is List) {
                          for (var item in mealType) {
                            if (item is Map && item.containsKey('calories')) {
                              totalCalories += (item['calories'] as int? ?? 0);
                            }
                          }
                        }
                      }

                      onSaveCallback(updatedMeals, totalCalories);
                    },
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: Routes.preparation,
            name: '/how-to-prepare',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final selectedPlan = extra?['selectedPlan'] as DayMealPlanEntity?;
              return HowToPrepare(selectedPlan: selectedPlan!);
            },
          ),
        ],
      ),
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
        path: Routes.reminders,
        name: '/reminders',
        builder: (context, state) => const Reminders(),
      ),
      GoRoute(
        path: Routes.account,
        name: '/account',
        builder: (context, state) => const UserAccount(),
      ),
      GoRoute(
        path: Routes.settings,
        name: '/settings',
        builder: (context, state) => const Settings(),
      ),
    ],
  );
});
