import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/routing/routes.dart';

class FoodBanner extends HookWidget {
  const FoodBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1200),
    );
    final scaleAnimation = useAnimation(
      Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOutBack),
      ),
    );
    final fadeAnimation = useAnimation(
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
        ),
      ),
    );

    useEffect(() {
      animationController.forward();
      return null;
    }, []);

    return Transform.scale(
      scale: scaleAnimation,
      child: Opacity(
        opacity: fadeAnimation,
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: ThemeUtils.primaryColor(context).withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background Image Layer
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ThemeUtils.primaryColor(context).withOpacity(0.05),
                        ThemeUtils.primaryColor(context).withOpacity(0.15),
                      ],
                    ),
                  ),
                  child: Image.asset(
                    "assets/images/banner_foods_tp.png",
                    fit: BoxFit.contain,
                    opacity: const AlwaysStoppedAnimation(0.9),
                  ),
                ),
              ),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ThemeUtils.primaryColor(context).withOpacity(0.1),
                      ThemeUtils.primaryColor(context).withOpacity(0.3),
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),

              // Decorative Elements
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    FluentIcons.bowl_salad_24_regular,
                    color: ThemeUtils.secondaryColor(context).withOpacity(0.8),
                    size: 24,
                  ),
                ),
              ),

              // Bottom Banner with Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ThemeUtils.primaryColor(context),
                        ThemeUtils.primaryColor(context).withOpacity(0.9),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ThemeUtils.primaryColor(
                          context,
                        ).withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      // Icon Container
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ThemeUtils.secondaryColor(
                            context,
                          ).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: ThemeUtils.secondaryColor(
                              context,
                            ).withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          FluentIcons.food_24_filled,
                          color: ThemeUtils.secondaryColor(context),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Title
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Foods",
                              style: TextStyle(
                                color: ThemeUtils.secondaryColor(context),
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                height: 1.0,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Explore & Track",
                              style: TextStyle(
                                color: ThemeUtils.secondaryColor(context),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.2,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          context.go("${Routes.foods}${Routes.addFoods}");
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: ThemeUtils.secondaryColor(context),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            FluentIcons.add_circle_24_filled,
                            color: ThemeUtils.primaryColor(context),
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Floating Badge (Optional)
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: ThemeUtils.secondaryColor(context),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.5),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Fresh",
                        style: TextStyle(
                          color: ThemeUtils.primaryColor(context),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
