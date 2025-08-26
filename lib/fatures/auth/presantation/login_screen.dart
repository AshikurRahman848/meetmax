import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meetmax/common/widget/app_button.dart';
import 'package:meetmax/common/widget/app_text_field.dart';
import 'package:meetmax/common/widget/or_divider.dart';
import 'package:meetmax/common/widget/social_button.dart';
import 'package:meetmax/core/validator.dart';
import '../data/auth_repository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(authRepositoryProvider).signIn(
            _email.text.trim(),
            _password.text,
          );
      if (mounted) context.go('/feed');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            Row(
              children: [
                const Icon(Icons.chat_bubble_rounded, color: Color(0xFF377DFF)),
                const SizedBox(width: 8),
                Text('Meetmax', style: t.titleLarge),
                const Spacer(),
                OutlinedButton.icon(
                  icon: const Icon(Icons.language),
                  label: const Text('English (UK)'),
                  onPressed: () {}, // non-functional placeholder
                ),
              ],
            ),
            const SizedBox(height: 32),
            Center(child: Text('Welcome back', style: t.headlineMedium)),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Log in to continue and connect\nwith the people.',
                textAlign: TextAlign.center,
                style: t.bodyMedium,
              ),
            ),
            const SizedBox(height: 24),

            // Card container like your Figma
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SocialButton(
                              icon: Icons.g_mobiledata,
                              label: 'Log in with Google',
                              onTap: () {}, // mock
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SocialButton(
                              icon: Icons.apple,
                              label: 'Log in with Apple',
                              onTap: () {}, // mock
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const OrDivider(),
                      const SizedBox(height: 12),

                      AppTextField(
                        controller: _email,
                        hint: 'Your Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: emailValidator,
                      ),
                      const SizedBox(height: 12),

                      AppTextField(
                        controller: _password,
                        hint: 'Password',
                        obscure: _obscure,
                        validator: (v) => passwordValidator(v),
                        suffix: IconButton(
                          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      const SizedBox(height: 8),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {}, // placeholder
                          child: const Text('Forgot password?'),
                        ),
                      ),
                      const SizedBox(height: 4),

                      AppButton(
                        label: 'Log In',
                        loading: _loading,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: 8),

                      TextButton(
                        onPressed: () => context.go('/signup'),
                        child: const Text('Don’t have an account?  Sign Up'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
