import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';

class FoodAvatar extends HookConsumerWidget {
  final String imageUrl;

  const FoodAvatar({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // State to track image loading
    final imageLoadFuture = useMemoized(() => _loadImage(imageUrl), [imageUrl]);

    final imageSnapshot = useFuture(imageLoadFuture);

    return CircleAvatar(
      radius: 13,
      backgroundColor: ThemeUtils.$backgroundColor,
      child: _buildAvatarContent(imageSnapshot),
    );
  }

  Widget _buildAvatarContent(AsyncSnapshot<String?> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Icon(FluentIcons.food_24_regular, size: 15);
    } else if (snapshot.hasError ||
        !snapshot.hasData ||
        snapshot.data == null) {
      return const Icon(FluentIcons.food_24_regular, size: 15);
    } else {
      return ClipOval(
        child: Image.network(
          snapshot.data!,
          height: 20,
          width: 20,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(FluentIcons.food_24_regular, size: 15);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Icon(FluentIcons.food_24_regular, size: 15);
          },
        ),
      );
    }
  }

  Future<String?> _loadImage(String url) async {
    if (url.isEmpty) return null;

    // TODO: Replace with your actual image loading logic
    // For example, if you're using Firebase Storage:
    // return await FuncUtils().getDownloadUrl(url);

    // For now, return the URL directly if it's already a full URL
    if (url.startsWith('http')) {
      return url;
    }

    // Otherwise return null and show placeholder
    return null;
  }
}
