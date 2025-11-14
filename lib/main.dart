import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/routing/router_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Utakula_V2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ThemeUtils.$primaryColor),
        fontFamily: 'Poppins',
      ),
      routerConfig: router,
    );
  }
}
