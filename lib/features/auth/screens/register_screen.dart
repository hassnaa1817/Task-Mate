import 'package:flutter/material.dart';

import 'package:task_mate/core/services/storage_service.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreed = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You must agree to the Terms of Service and Privacy Policy.',
          ),
        ),
      );
      return;
    }

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmedPassword = _confirmPasswordController.text;

    if (password != confirmedPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match.')));
      return;
    }

    final registered = AuthStorage.instance.registerUser(
      name: name,
      email: email,
      password: password,
    );

    if (!registered) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An account with this email already exists.'),
        ),
      );
      return;
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account created. Please log in.')),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E7),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: SizedBox(
                  width: constraints.maxWidth > 390
                      ? 390
                      : constraints.maxWidth,
                  height: 820,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 24,
                        top: 110,
                        child: _DecorCircle(
                          size: 110,
                          color: const Color(0xFFE7C7C6).withValues(
                            alpha: 0.82,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 18,
                        top: 120,
                        child: _DecorCircle(
                          size: 140,
                          color: const Color(0xFFE2EEF7).withValues(alpha: 0.8),
                        ),
                      ),
                      Positioned(
                        left: 24,
                        top: 44,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => Navigator.of(context).pop(),
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 22,
                              color: Color(0xFF1F3554),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 94,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Create your account',
                                style: TextStyle(
                                  color: Color(0xFF263D62),
                                  fontSize: 38,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -1.2,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Plan smarter, stress less, and stay on top of campus life.',
                                style: TextStyle(
                                  color: Color(0xFF71809A),
                                  fontSize: 15,
                                  height: 1.45,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 28,
                        right: 28,
                        top: 220,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _InputField(
                                label: 'Full name',
                                hint: 'Your full name',
                                prefixIcon: Icons.person_outline_rounded,
                                controller: _nameController,
                                validator: (value) {
                                  if ((value ?? '').trim().isEmpty) {
                                    return 'Full name is required.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _InputField(
                                label: 'University email',
                                hint: 'name@university.edu',
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                                validator: (value) {
                                  final email = (value ?? '').trim();
                                  if (email.isEmpty) {
                                    return 'Email is required.';
                                  }
                                  if (!email.contains('@')) {
                                    return 'Enter a valid email.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _InputField(
                                label: 'Password',
                                hint: 'Create a secure password',
                                prefixIcon: Icons.lock_outline_rounded,
                                isPassword: true,
                                suffixIcon: Icons.visibility_off_outlined,
                                controller: _passwordController,
                                validator: (value) {
                                  if ((value ?? '').isEmpty) {
                                    return 'Password is required.';
                                  }
                                  if ((value ?? '').length < 6) {
                                    return 'Password must be at least 6 characters.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _InputField(
                                label: 'Confirm password',
                                hint: 'Re-enter your password',
                                prefixIcon: Icons.lock_outline_rounded,
                                isPassword: true,
                                suffixIcon: Icons.visibility_off_outlined,
                                controller: _confirmPasswordController,
                                validator: (value) {
                                  if ((value ?? '').isEmpty) {
                                    return 'Please confirm your password.';
                                  }
                                  if ((value ?? '') !=
                                      _passwordController.text) {
                                    return 'Passwords do not match.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Checkbox(
                                      value: _agreed,
                                      onChanged: (value) => setState(
                                        () => _agreed = value ?? false,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      side: const BorderSide(
                                        color: Color(0xFFB1BCCB),
                                        width: 1.5,
                                      ),
                                      activeColor: const Color(0xFF7DBE8B),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Expanded(
                                    child: Text(
                                      'I agree to the Terms of Service and Privacy Policy.',
                                      style: TextStyle(
                                        color: Color(0xFF2A446A),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                width: double.infinity,
                                height: 58,
                                child: ElevatedButton(
                                  onPressed: _handleRegister,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF263D62),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Create Account',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () => Navigator.of(context)
                                    .pushReplacement(
                                      MaterialPageRoute<void>(
                                        builder: (_) => const LoginScreen(),
                                      ),
                                    ),
                                child: const Text(
                                  'Already have an account? Log in',
                                  style: TextStyle(
                                    color: Color(0xFF2A446A),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFEF8F71),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF7DBE8B),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFB7D7E9),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
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
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.controller,
    this.keyboardType,
    this.isPassword = false,
    this.suffixIcon,
    this.validator,
  });

  final String label;
  final String hint;
  final IconData prefixIcon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool isPassword;
  final IconData? suffixIcon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF2A446A),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFCBD4DE)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Icon(prefixIcon, size: 18, color: const Color(0xFF2A446A)),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  obscureText: isPassword,
                  keyboardType: keyboardType,
                  validator: validator,
                  enableSuggestions: !isPassword,
                  autocorrect: !isPassword,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      color: Color(0xFF8A99AA),
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              if (suffixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    suffixIcon,
                    size: 17,
                    color: const Color(0xFF8A99AA),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DecorCircle extends StatelessWidget {
  const _DecorCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
