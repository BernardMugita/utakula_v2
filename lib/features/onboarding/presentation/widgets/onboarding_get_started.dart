import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utakula_v2/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:utakula_v2/routing/routes.dart';

class OnboardingGetStarted extends HookConsumerWidget {
  const OnboardingGetStarted({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarding = ref.watch(onboardingStateProvider);

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1500),
    );

    useEffect(() {
      animationController.forward();
      return null;
    }, []);

    final fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );

    final scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF5F0), Color(0xFFFFE8E8), Color(0xFFE8F5E9)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Main illustration
              ScaleTransition(
                scale: scaleAnimation,
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background glow
                      Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF4A7C2C).withOpacity(0.2),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                      // Main logo circle
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 40,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(40),
                        child: Image.asset(
                          'assets/images/utakula-logo-green.png',
                          fit: BoxFit.contain,
                        ),
                      ),

                      // Orbiting icons
                      ..._buildOrbitingIcons(animationController),
                    ],
                  ),
                ),
              ),

              const Gap(80),

              // Content
              FadeTransition(
                opacity: fadeAnimation,
                child: Column(
                  children: [
                    const Text(
                      'You\'re All Set!',
                      style: TextStyle(
                        color: Color(0xFF2D5016),
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(20),
                    Text(
                      'Join thousands of users planning their meals effortlessly. Start your culinary journey today!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 17,
                        height: 1.6,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Gap(40),

                    // Quick stats
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     _buildStatCard('1000+', 'Users', fadeAnimation),
                    //     _buildStatCard('50K+', 'Meals', fadeAnimation),
                    //     _buildStatCard('4.8★', 'Rating', fadeAnimation),
                    //   ],
                    // ),
                  ],
                ),
              ),

              const Spacer(),

              // Action buttons
              FadeTransition(
                opacity: fadeAnimation,
                child: Column(
                  children: [
                    // Sign Up button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to sign up
                          context.go(Routes.register);
                          ref
                              .read(onboardingStateProvider.notifier)
                              .setOnboardingComplete();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D5016),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          shadowColor: Colors.black.withOpacity(0.3),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Gap(10),
                            Icon(Icons.arrow_forward_rounded, size: 24),
                          ],
                        ),
                      ),
                    ),
                    const Gap(16),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // Navigate to login
                          context.go(Routes.login);
                          ref
                              .read(onboardingStateProvider.notifier)
                              .setOnboardingComplete();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2D5016),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          side: const BorderSide(
                            color: Color(0xFF2D5016),
                            width: 2,
                          ),
                        ),
                        child: const Text(
                          'I Already Have an Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOrbitingIcons(AnimationController controller) {
    final icons = [
      {'icon': Icons.calendar_today_rounded, 'angle': 0.0},
      {'icon': Icons.notifications_active_rounded, 'angle': 1.57},
      {'icon': Icons.restaurant_menu_rounded, 'angle': 3.14},
      {'icon': Icons.analytics_rounded, 'angle': 4.71},
    ];

    return icons.map((data) {
      return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final angle = (data['angle'] as double) + (controller.value * 6.28);
          final radius = 130.0;
          final x = radius * cos(angle);
          final y = radius * sin(angle);

          return Transform.translate(
            offset: Offset(x, y),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                data['icon'] as IconData,
                color: const Color(0xFF4A7C2C),
                size: 26,
              ),
            ),
          );
        },
      );
    }).toList();
  }

  Widget _buildStatCard(
    String value,
    String label,
    Animation<double> animation,
  ) {
    return FadeTransition(
      opacity: animation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D5016),
              ),
            ),
            const Gap(4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper function for cos and sin
double cos(double radians) => radians.cos();

double sin(double radians) => radians.sin();

extension on double {
  double cos() => (this * 180 / 3.14159265359).toRadians().cosine();

  double sin() => (this * 180 / 3.14159265359).toRadians().sine();

  double toRadians() => this * 3.14159265359 / 180;

  double cosine() {
    // Taylor series approximation for cosine
    double x = this;
    double result = 1.0;
    double term = 1.0;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }

  double sine() {
    // Taylor series approximation for sine
    double x = this;
    double result = x;
    double term = x;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }
}
