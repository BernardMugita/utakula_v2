import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utakula_v2/features/onboarding/presentation/widgets/onboarding_custom_remiders.dart';
import 'package:utakula_v2/features/onboarding/presentation/widgets/onboarding_get_started.dart';
import 'package:utakula_v2/features/onboarding/presentation/widgets/onboarding_local_foods.dart';
import 'package:utakula_v2/features/onboarding/presentation/widgets/onboarding_welcome.dart';

class OnboardingController extends HookConsumerWidget {
  const OnboardingController({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final currentPage = useState(0);

    void nextPage() {
      if (currentPage.value < 3) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    }

    void skipToEnd() {
      pageController.animateToPage(
        3,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // PageView
          PageView(
            controller: pageController,
            onPageChanged: (index) {
              currentPage.value = index;
            },
            children: [
              OnboardingWelcome(onNext: nextPage),
              OnboardingLocalFoods(onNext: nextPage),
              OnboardingCustomReminders(onNext: nextPage),
              const OnboardingGetStarted(),
            ],
          ),

          // Skip button (shows on first 3 pages)
          if (currentPage.value < 3)
            Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                onPressed: skipToEnd,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          // Page indicators
          if (currentPage.value < 3)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: currentPage.value == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: currentPage.value == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
