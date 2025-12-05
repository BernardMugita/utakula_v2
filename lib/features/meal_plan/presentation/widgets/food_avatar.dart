import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';

class FoodAvatar extends HookConsumerWidget {
  final String imageUrl;

  const FoodAvatar({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CircleAvatar(
      radius: 13,
      backgroundColor: ThemeUtils.$backgroundColor,
      child: imageUrl.isEmpty
          ? const Icon(FluentIcons.food_24_regular, size: 15)
          : ClipOval(
              child: Image.asset(
                'assets/foods/$imageUrl',
                height: 20,
                width: 20,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(FluentIcons.food_24_regular, size: 15);
                },
              ),
            ),
    );
  }
}
