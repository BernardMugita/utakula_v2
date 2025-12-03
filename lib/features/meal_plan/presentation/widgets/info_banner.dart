import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:gap/gap.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';

class InfoBanner extends StatelessWidget {
  final String message;

  const InfoBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          FluentIcons.info_24_regular,
          color: ThemeUtils.$primaryColor,
        ),
        const Gap(10),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 12,
              color: ThemeUtils.$primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
