import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utakula_v2/common/helpers/helper_utils.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/common/global_widgets/utakula_input.dart';
import 'package:utakula_v2/common/global_widgets/utakula_button.dart';
import 'package:utakula_v2/features/register/helpers/registration_helpers.dart';
import 'package:utakula_v2/features/register/presentation/providers/sign_up_provider.dart';
import 'package:utakula_v2/features/register/presentation/providers/sign_up_state_provider.dart';
import 'package:utakula_v2/routing/routes.dart';

class Register extends HookConsumerWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    HelperUtils helperUtils = HelperUtils();
    RegistrationHelpers registrationHelpers = RegistrationHelpers();

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

    final registerState = ref.watch(registerStateProvider);

    ref.listen<RegisterState>(registerStateProvider, (previous, next) {
      if (next.errorMessage != null) {
        helperUtils.showSnackBar(context, next.errorMessage!, Colors.red);
      } else if (next.isSuccess) {
        helperUtils.showSnackBar(
          context,
          "Registration successful!",
          Colors.green,
        );
        Future.delayed(const Duration(seconds: 1), () {
          if (context.mounted) {
            context.go(Routes.login);
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
              ThemeUtils.$blacks.withOpacity(0.7),
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
                ThemeUtils.$blacks.withOpacity(0.6),
                ThemeUtils.$blacks.withOpacity(0.8),
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
                          _buildBackButton(context),
                          const Gap(20),
                          _buildLogo(context),
                          const Gap(30),
                          _buildWelcomeText(),
                          const Gap(40),
                          _buildFormContainer(
                            formKey,
                            usernameController,
                            emailController,
                            passwordController,
                            confirmPasswordController,
                            ref,
                            registerState.isLoading,
                            registrationHelpers,
                          ),
                          const Gap(30),
                          _buildDivider(),
                          const Gap(20),
                          _buildLoginPrompt(context),
                          const Gap(20),
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

  Widget _buildBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () {
          context.go(Routes.login);
        },
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: ThemeUtils.$secondaryColor,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Hero(
      tag: 'app_logo',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              ThemeUtils.$primaryColor.withOpacity(0.3),
              ThemeUtils.$primaryColor.withOpacity(0.1),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: ThemeUtils.$primaryColor.withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: CircleAvatar(
          radius: MediaQuery.of(context).size.width / 8,
          backgroundColor: Colors.transparent,
          child: Image(
            fit: BoxFit.contain,
            image: AssetImage("assets/images/utakula-logo-white.png"),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              ThemeUtils.$primaryColor,
              ThemeUtils.$primaryColor.withOpacity(0.8),
            ],
          ).createShader(bounds),
          child: const Text(
            "Create Account",
            style: TextStyle(
              fontFamily: 'Diana',
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const Gap(8),
        Text(
          "Join Utakula and start your culinary adventure",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ThemeUtils.$secondaryColor.withOpacity(0.8),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildFormContainer(
    GlobalKey<FormState> formKey,
    TextEditingController usernameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController confirmPasswordController,
    WidgetRef ref,
    bool isLoading,
    RegistrationHelpers registrationHelpers,
  ) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
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
            validator: registrationHelpers.validateUsername,
          ),
          const Gap(16),
          UtakulaInput(
            controller: emailController,
            hintText: "Enter you Email address",
            prefixIcon: FluentIcons.mail_24_regular,
            keyboardType: TextInputType.emailAddress,
            validator: registrationHelpers.validateEmail,
          ),
          const Gap(16),
          UtakulaInput(
            controller: passwordController,
            hintText: "Please enter your Password",
            prefixIcon: FluentIcons.lock_closed_24_regular,
            obscureText: true,
            showPasswordToggle: true,
            validator: registrationHelpers.validatePassword,
          ),
          const Gap(16),
          UtakulaInput(
            controller: confirmPasswordController,
            hintText: "Please Confirm password",
            prefixIcon: FluentIcons.lock_closed_24_regular,
            obscureText: true,
            showPasswordToggle: true,
            validator: (value) => registrationHelpers.validateConfirmPassword(
              value,
              passwordController.text,
            ),
          ),
          const Gap(8),
          _buildPasswordRequirements(),
          const Gap(24),
          UtakulaButton(
            text: "Create Account",
            onPressed: isLoading
                ? null
                : () async {
                    if (formKey.currentState!.validate()) {
                      await ref
                          .read(registerStateProvider.notifier)
                          .registerUser(
                            usernameController.text,
                            emailController.text,
                            passwordController.text,
                          );
                    }
                  },
            isLoading: isLoading,
            size: UtakulaButtonSize.large,
            width: double.infinity,
            icon: FluentIcons.checkmark_circle_24_filled,
            iconRight: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Password requirements:",
            style: TextStyle(
              color: ThemeUtils.$secondaryColor.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(6),
          _buildRequirementItem("At least 8 characters"),
          _buildRequirementItem("One uppercase letter"),
          _buildRequirementItem("One number"),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            FluentIcons.checkmark_12_filled,
            size: 12,
            color: ThemeUtils.$primaryColor.withOpacity(0.7),
          ),
          const Gap(6),
          Text(
            text,
            style: TextStyle(
              color: ThemeUtils.$secondaryColor.withOpacity(0.7),
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: ThemeUtils.$secondaryColor.withOpacity(0.3),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Or",
            style: TextStyle(
              color: ThemeUtils.$secondaryColor.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: ThemeUtils.$secondaryColor.withOpacity(0.3),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
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
            "Already have an account?",
            style: TextStyle(
              color: ThemeUtils.$secondaryColor.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(8),
          GestureDetector(
            onTap: () {
              context.go(Routes.login);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: ThemeUtils.$primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ThemeUtils.$primaryColor.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                  color: ThemeUtils.$primaryColor,
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
