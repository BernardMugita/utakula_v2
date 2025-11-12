import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:utakula_v2/features/homepage/presentation/pages/homepage.dart';
import 'package:utakula_v2/features/login/presentation/pages/login.dart';
import 'package:utakula_v2/features/register/presentation/pages/register.dart';
import 'package:utakula_v2/routing/routes.dart';

final router = GoRouter(
  initialLocation: Routes.login,
  routes: [
    GoRoute(path: Routes.home, builder: (context, state) => const Homepage()),
    GoRoute(path: Routes.login, builder: (context, state) => const Login()),
    GoRoute(
      path: Routes.register,
      builder: (context, state) => const Register(),
    ),
  ],
);
