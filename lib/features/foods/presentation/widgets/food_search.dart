import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';

class FoodSearch extends HookWidget {
  final Function(String) handleSearch;

  const FoodSearch({Key? key, required this.handleSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchQuery = useTextEditingController();
    final isFocused = useState(false);
    final hasText = useState(false);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: ThemeUtils.secondaryColor(context),
        border: Border.all(
          color: isFocused.value
              ? ThemeUtils.primaryColor(context)
              : ThemeUtils.primaryColor(context).withOpacity(0.3),
          width: isFocused.value ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: isFocused.value
            ? [
                BoxShadow(
                  color: ThemeUtils.primaryColor(context).withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            Icon(
              FluentIcons.search_24_regular,
              color: isFocused.value
                  ? ThemeUtils.primaryColor(context)
                  : ThemeUtils.primaryColor(context).withOpacity(0.5),
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Focus(
                onFocusChange: (focused) {
                  isFocused.value = focused;
                },
                child: TextField(
                  controller: searchQuery,
                  onChanged: (value) {
                    handleSearch(value);
                    hasText.value = value.isNotEmpty;
                  },
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: "Search foods...",
                    hintStyle: TextStyle(
                      color: ThemeUtils.primaryColor(context).withOpacity(0.4),
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            if (hasText.value)
              GestureDetector(
                onTap: () {
                  searchQuery.clear();
                  handleSearch('');
                  hasText.value = false;
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: ThemeUtils.primaryColor(context).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    FluentIcons.dismiss_16_regular,
                    color: ThemeUtils.primaryColor(context),
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
