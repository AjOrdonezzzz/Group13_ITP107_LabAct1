import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: hook up actual registration logic
    final fullName =
        "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}"
            .trim();
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => false,
      arguments: fullName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 420,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      _buildHeader(context, textTheme),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _buildField(
                              label: "First Name",
                              controller: _firstNameController,
                              textTheme: textTheme,
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                  ? "Required"
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildField(
                              label: "Last Name",
                              controller: _lastNameController,
                              textTheme: textTheme,
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                  ? "Required"
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _buildField(
                        label: "E-mail",
                        hintText: "Enter your email",
                        controller: _emailController,
                        textTheme: textTheme,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Required";
                          if (!value.contains("@"))
                            return "Enter a valid email";
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      _buildField(
                        label: "Password",
                        controller: _passwordController,
                        textTheme: textTheme,
                        obscureText: !_passwordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppTheme.muted,
                          ),
                          onPressed: () {
                            setState(
                              () => _passwordVisible = !_passwordVisible,
                            );
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.length < 8) {
                            return "Must contain 8 characters";
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 4),
                        child: Text(
                          "must contain 8 characters.",
                          style: textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildField(
                        label: "Confirm Password",
                        controller: _confirmPasswordController,
                        textTheme: textTheme,
                        obscureText: !_confirmPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _confirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppTheme.muted,
                          ),
                          onPressed: () {
                            setState(
                              () => _confirmPasswordVisible =
                                  !_confirmPasswordVisible,
                            );
                          },
                        ),
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),
                      FilledButton(
                        onPressed: _handleRegister,
                        child: const Text("Register"),
                      ),
                      const SizedBox(height: 18),
                      _buildTermsNotice(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TextTheme textTheme) {
    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: AppTheme.textDark,
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Text("Register", style: textTheme.headlineMedium),
          ),
        ),
        const SizedBox(width: 36),
      ],
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required TextTheme textTheme,
    String? hintText,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.titleMedium),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  Widget _buildTermsNotice() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.muted,
            height: 1.4,
          ),
          children: [
            const TextSpan(text: "By continuing, you agree to our "),
            TextSpan(
              text: "Terms of Service",
              style: const TextStyle(
                color: AppTheme.primary,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
            const TextSpan(text: " and\n"),
            TextSpan(
              text: "Privacy Policy.",
              style: const TextStyle(
                color: AppTheme.primary,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
          ],
        ),
      ),
    );
  }
}
