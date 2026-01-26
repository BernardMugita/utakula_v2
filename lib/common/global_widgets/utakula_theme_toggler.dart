// common/global_widgets/theme_toggle_button.dart

import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/core/providers/theme_provider/theme_provider.dart';

class UtakulaThemeToggler extends ConsumerWidget {
  final bool showLabel;

  const UtakulaThemeToggler({super.key, this.showLabel = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.read(themeProvider.notifier);
    final isDark = themeNotifier.isDarkMode(context);

    if (showLabel) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ThemeUtils.secondaryColor(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ThemeUtils.primaryColor(context).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isDark
                    ? FluentIcons.weather_moon_24_filled
                    : FluentIcons.weather_sunny_24_filled,
                color: ThemeUtils.primaryColor(context),
                size: 20,
              ),
            ),
            const Gap(12),
            Expanded(
              child: Text(
                'Dark Mode',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: ThemeUtils.blacks(context),
                ),
              ),
            ),
            Switch(
              value: isDark,
              onChanged: (_) => themeNotifier.toggleTheme(),
              activeColor: ThemeUtils.primaryColor(context),
              inactiveThumbColor: ThemeUtils.primaryColor(context),
            ),
          ],
        ),
      );
    }

    return IconButton(
      icon: Icon(
        isDark
            ? FluentIcons.weather_moon_24_filled
            : FluentIcons.weather_sunny_24_filled,
        color: ThemeUtils.primaryColor(context),
      ),
      onPressed: () => themeNotifier.toggleTheme(),
      tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
    );
  }
}
