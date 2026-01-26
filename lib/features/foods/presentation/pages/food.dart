import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:utakula_v2/common/global_widgets/utakula_exit_alert.dart';
import 'package:utakula_v2/common/global_widgets/utakula_side_navigation.dart';
import 'package:utakula_v2/common/helpers/helper_utils.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/foods/presentation/providers/foods_provider.dart';
import 'package:utakula_v2/features/foods/presentation/widgets/food_banner.dart';
import 'package:utakula_v2/features/foods/presentation/widgets/food_container.dart';
import 'package:utakula_v2/features/foods/presentation/widgets/food_search.dart';

class Foods extends HookConsumerWidget {
  const Foods({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Logger logger = Logger();

    // Watch the current state
    final foodState = ref.watch(foodStateProvider);

    // Fetch foods on initial load
    useEffect(() {
      Future.microtask(() => ref.read(foodStateProvider.notifier).fetchFoods());
      return null;
    }, []);

    final displayList = foodState.searchResults.isNotEmpty
        ? foodState.searchResults
        : foodState.foods;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => _showExitConfirmationDialog(context, (pop) {}),
      child: Scaffold(
        backgroundColor: ThemeUtils.backgroundColor(context),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: const Icon(Icons.reorder),
            ),
          ),
        ),
        drawer: UtakulaSideNavigation(),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () {
              return Future.microtask(
                () => ref.read(foodStateProvider.notifier).fetchFoods(),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Fixed header section
                  const FoodBanner(),
                  const Gap(16),
                  FoodSearch(
                    handleSearch: (query) =>
                        ref.read(foodStateProvider.notifier).searchFoods(query),
                  ),
                  const Gap(24),
                  Expanded(
                    child: foodState.isLoading
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: Lottie.asset(
                                    'assets/animations/Loading.json',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const Gap(16),
                                Text(
                                  "Loading delicious foods...",
                                  style: TextStyle(
                                    color: ThemeUtils.primaryColor(
                                      context,
                                    ).withOpacity(0.6),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : displayList.isEmpty
                        ? Center(child: _buildErrorMessage(context))
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 20),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: displayList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: FoodContainer(
                                  foodDetails: displayList[index],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: ThemeUtils.secondaryColor(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ThemeUtils.$error.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeUtils.$error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              FluentIcons.food_24_regular,
              color: ThemeUtils.$error,
              size: 48,
            ),
          ),
          const Gap(20),
          const Text(
            "No results found",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Gap(8),
          Text(
            "Try adjusting your search",
            style: TextStyle(
              color: ThemeUtils.primaryColor(context).withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showExitConfirmationDialog(
    BuildContext context,
    void Function(bool) onPop,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return UtakulaExitAlert(dialogContext: dialogContext, onPop: onPop);
      },
    );
  }
}
