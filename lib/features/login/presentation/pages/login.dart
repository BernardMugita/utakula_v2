import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Included in hooks_riverpod
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:utakula_v2/common/global_widgets/utakula_button.dart';
import 'package:utakula_v2/common/global_widgets/utakula_input.dart';
import 'package:utakula_v2/common/helpers/helper_utils.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/login/presentation/providers/sign_in_provider.dart';
import 'package:utakula_v2/features/login/presentation/providers/sign_in_state_providers.dart';
import 'package:utakula_v2/routing/routes.dart';

class Login extends HookConsumerWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    HelperUtils helperUtils = HelperUtils();

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1200),
    );

    final fadeAnimation = useMemoized(
      () => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
        ),
      ),
      [animationController],
    );

    final slideAnimation = useMemoized(
      () =>
          Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
            CurvedAnimation(
              parent: animationController,
              curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
            ),
          ),
      [animationController],
    );

    useEffect(() {
      animationController.forward();
      return null;
    }, []);

    final loginState = ref.watch(loginStateProvider);

    ref.listen<LoginState>(loginStateProvider, (previous, next) {
      if (next.errorMessage != null) {
        helperUtils.showSnackBar(context, next.errorMessage!, Colors.red);
      } else if (next.isSuccess) {
        helperUtils.showSnackBar(context, "Login successful!", Colors.green);
        Future.delayed(const Duration(seconds: 1), () {
          if (context.mounted) {
            context.go(Routes.home);
          }
        });
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            opacity: 0.3,
            fit: BoxFit.cover,
            image: const AssetImage('assets/images/background.png'),
            colorFilter: ColorFilter.mode(
              ThemeUtils.backgroundColor(context).withOpacity(0.7),
              BlendMode.darken,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ThemeUtils.backgroundColor(context).withOpacity(0.6),
                ThemeUtils.backgroundColor(context).withOpacity(0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLogo(context),
                          const Gap(40),
                          _buildWelcomeText(context),
                          const Gap(50),
                          _buildFormContainer(
                            context,
                            ref,
                            formKey,
                            usernameController,
                            passwordController,
                            loginState.isLoading,
                          ),
                          const Gap(30),
                          _buildDivider(context),
                          const Gap(20),
                          _buildSignUpPrompt(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Hero(
      tag: 'app_logo',
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.dark
                ? [
                    ThemeUtils.primaryColor(context).withOpacity(0.3),
                    ThemeUtils.primaryColor(context).withOpacity(0.1),
                  ]
                : [
                    ThemeUtils.primaryColor(context),
                    ThemeUtils.primaryColor(context).withOpacity(0.8),
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: ThemeUtils.primaryColor(context).withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: CircleAvatar(
          radius: MediaQuery.of(context).size.width / 6,
          backgroundColor: Colors.transparent,
          child: Image(
            width: 100,
            height: 100,
            fit: BoxFit.contain,
            image: AssetImage("assets/images/utakula-logo-white.png"),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              ThemeUtils.primaryColor(context),
              ThemeUtils.primaryColor(context).withOpacity(0.8),
            ],
          ).createShader(bounds),
          child: const Text(
            "Utakula?!",
            style: TextStyle(
              fontFamily: 'Diana',
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const Gap(8),
        Text(
          "Login to continue your culinary journey",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ThemeUtils.blacks(context).withOpacity(0.8),
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildFormContainer(
    BuildContext context,
    WidgetRef ref,
    GlobalKey<FormState> formKey,
    TextEditingController usernameController,
    TextEditingController passwordController,
    bool isLoading,
  ) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: ThemeUtils.backgroundColor(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          UtakulaInput(
            controller: usernameController,
            hintText: "Please enter your username",
            prefixIcon: FluentIcons.person_24_regular,
          ),
          const Gap(12),
          UtakulaInput(
            controller: passwordController,
            hintText: "Please enter your password",
            prefixIcon: FluentIcons.lock_closed_24_regular,
            obscureText: true,
            showPasswordToggle: true,
          ),
          const Gap(12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                "Forgot password?",
                style: TextStyle(
                  color: ThemeUtils.blacks(context),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const Gap(24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: UtakulaButton(
              text: "Login",
              textColor: ThemeUtils.blacks(context),
              onPressed: isLoading
                  ? null
                  : () async {
                      if (formKey.currentState!.validate()) {
                        await ref
                            .read(loginStateProvider.notifier)
                            .signIn(
                              usernameController.text,
                              passwordController.text,
                            );
                      }
                    },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(color: ThemeUtils.borderColor(context), thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Or",
            style: TextStyle(
              color: ThemeUtils.blacks(context).withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: ThemeUtils.borderColor(context), thickness: 1),
        ),
      ],
    );
  }

  Widget _buildSignUpPrompt(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account?",
            style: TextStyle(
              color: ThemeUtils.blacks(context).withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(8),
          GestureDetector(
            onTap: () {
              context.go('/register');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: ThemeUtils.primaryColor(context).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ThemeUtils.primaryColor(context).withOpacity(0.8),
                  width: 1,
                ),
              ),
              child: Text(
                "Sign up",
                style: TextStyle(
                  color: ThemeUtils.primaryColor(context),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
