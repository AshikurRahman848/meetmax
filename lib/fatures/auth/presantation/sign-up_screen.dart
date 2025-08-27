import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meetmax/common/widget/app_button.dart';
import 'package:meetmax/common/widget/app_text_field.dart';
import 'package:meetmax/common/widget/gender_selector.dart';
import 'package:meetmax/common/widget/or_divider.dart';
import 'package:meetmax/common/widget/social_button.dart';
import 'package:meetmax/common/widget/top_bar.dart';
import 'package:meetmax/core/validator.dart';
import '../data/auth_repository.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});
  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _name = TextEditingController();
  final _password = TextEditingController();
  DateTime? _dob;
  Gender _gender = Gender.male;
  bool _loading = false;
  bool _hide = true;

  @override
  void dispose() {
    _email.dispose();
    _name.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            const TopBar(),
            const SizedBox(height: 32),

            // Title + subtitle
            Center(child: Text('Getting Started', style: t.headlineMedium)),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Create an account to continue and connect\nwith the people.',
                textAlign: TextAlign.center,
                style: t.bodyMedium,
              ),
            ),
            const SizedBox(height: 24),

            // Card container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Color(0x1A000000), blurRadius: 22, offset: Offset(0, 8)),
                ],
              ),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    // Social buttons row
                    Row(
                      children: [
                        Expanded(
                          child: SocialButton(
                            icon: Icons.g_mobiledata,
                            label: 'Log in with Google',
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SocialButton(
                            icon: Icons.apple,
                            label: 'Log in with Apple',
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const OrDivider(),
                    const SizedBox(height: 12),

                    // Email
                    AppTextField(
                      controller: _email,
                      hint: 'Your Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: emailValidator,
                      prefix: const Icon(Icons.alternate_email_outlined), // prefix icon to match mock
                    ),
                    const SizedBox(height: 12),

                    // Name
                    AppTextField(
                      controller: _name,
                      hint: 'Your Name',
                      validator: nameValidator,
                      prefix: const Icon(Icons.badge_outlined),
                    ),
                    const SizedBox(height: 12),

                    // Password
                    AppTextField(
                      controller: _password,
                      hint: 'Create Password',
                      obscure: _hide,
                      validator: passwordValidator,
                      prefix: const Icon(Icons.lock_outline),
                      suffix: IconButton(
                        icon: Icon(_hide ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _hide = !_hide),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Date of birth (picker) – keep AppTextField look
                    InkWell(
                      onTap: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(now.year - 90),
                          lastDate: now,
                          initialDate: DateTime(now.year - 20),
                        );
                        if (picked != null) setState(() => _dob = picked);
                      },
                      child: IgnorePointer(
                        child: AppTextField(
                          hint: _dob == null
                              ? 'Date of birth'
                              : '${_dob!.year}-${_dob!.month.toString().padLeft(2, '0')}-${_dob!.day.toString().padLeft(2, '0')}',
                          validator: (_) => _dob == null ? 'Select date of birth' : null,
                          prefix: const Icon(Icons.calendar_today_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Gender
                    GenderSelector(value: _gender, onChanged: (g) => setState(() => _gender = g)),
                    const SizedBox(height: 16),

                    // Sign Up button
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: 'Sign Up',
                        loading: _loading,
                        onPressed: () async {
                          if (!_form.currentState!.validate()) return;
                          setState(() => _loading = true);
                          try {
                            await ref.read(authRepositoryProvider).signUp(
                                  email: _email.text.trim(),
                                  name: _name.text.trim(),
                                  password: _password.text,
                                  dob: _dob!,
                                  gender: _gender == Gender.male ? 'male' : 'female',
                                );
                            if (mounted) context.go('/feed');
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
                              );
                            }
                          } finally {
                            if (mounted) setState(() => _loading = false);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Bottom link
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('Already have an account?  Sign In'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
