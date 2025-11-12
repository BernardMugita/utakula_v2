import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/login/presentation/widgets/utakula_button.dart';
import 'package:utakula_v2/features/login/presentation/widgets/utakula_input.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>
    with SingleTickerProviderStateMixin {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Auth registerRequest = Auth();
  bool isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> createAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check if passwords match
    if (passwordController.text != confirmPasswordController.text) {
      _showSnackBar("Passwords do not match!", ThemeUtils.$error);
      return;
    }

    setState(() {
      isLoading = true;
    });

    // TODO: Implement actual registration logic
    // final registerRequest = await authService.createUserAccount(
    //   username: usernameController.text,
    //   email: emailController.text,
    //   password: passwordController.text,
    // );

    // Simulated delay
    await Future.delayed(const Duration(seconds: 2));

    // TODO: Replace with actual response handling
    final bool success = true; // Simulated success
    final String errorMessage = ""; // Simulated error message

    if (success && mounted) {
      _showSnackBar(
        "Account created successfully! Redirecting to login...",
        ThemeUtils.$primaryColor,
      );

      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pop(context); // Go back to login page
        // Or use: Navigator.pushReplacementNamed(context, '/login');
      }
    } else if (mounted) {
      _showSnackBar(
        errorMessage.isEmpty
            ? "Registration failed. Please try again."
            : errorMessage,
        ThemeUtils.$error,
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: ThemeUtils.$secondaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    if (value.length > 20) {
      return 'Username must be less than 20 characters';
    }
    // Check for valid characters (alphanumeric and underscore)
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscore';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    // Check for at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    // Check for at least one number
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
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
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Back Button
                          _buildBackButton(),
                          const Gap(20),

                          // Logo Section
                          _buildLogo(context),
                          const Gap(30),

                          // Welcome Text
                          _buildWelcomeText(),
                          const Gap(40),

                          // Form Container
                          _buildFormContainer(),
                          const Gap(30),

                          // Divider
                          _buildDivider(),
                          const Gap(20),

                          // Login Prompt
                          _buildLoginPrompt(),
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

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
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
          backgroundImage: const AssetImage("assets/images/logo-white.png"),
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

  Widget _buildFormContainer() {
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
          // Username Input
          UtakulaInput(
            controller: usernameController,
            hintText: "Username",
            prefixIcon: FluentIcons.person_24_regular,
            validator: _validateUsername,
          ),
          const Gap(16),

          // Email Input
          UtakulaInput(
            controller: emailController,
            hintText: "Email address",
            prefixIcon: FluentIcons.mail_24_regular,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          const Gap(16),

          // Password Input
          UtakulaInput(
            controller: passwordController,
            hintText: "Password",
            prefixIcon: FluentIcons.lock_closed_24_regular,
            obscureText: true,
            showPasswordToggle: true,
            validator: _validatePassword,
          ),
          const Gap(16),

          // Confirm Password Input
          UtakulaInput(
            controller: confirmPasswordController,
            hintText: "Confirm password",
            prefixIcon: FluentIcons.lock_closed_24_regular,
            obscureText: true,
            showPasswordToggle: true,
            validator: _validateConfirmPassword,
          ),
          const Gap(8),

          // Password Requirements Info
          _buildPasswordRequirements(),
          const Gap(24),

          // Register Button
          UtakulaButton(
            text: "Create Account",
            onPressed: createAccount,
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

  Widget _buildLoginPrompt() {
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
              Navigator.pop(context); // Go back to login
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
