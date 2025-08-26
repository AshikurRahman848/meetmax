import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meetmax/common/widget/app_button.dart';
import 'package:meetmax/common/widget/app_text_field.dart';
import 'package:meetmax/common/widget/gender_selector.dart';
import 'package:meetmax/common/widget/or_divider.dart';
import 'package:meetmax/common/widget/social_button.dart';
import 'package:meetmax/core/validator.dart';
import '../../../core/theme.dart';
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
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            Row(
              children: [
                const Icon(Icons.chat_bubble_rounded, color: AppTheme.primary),
                const SizedBox(width: 8),
                Text('Meetmax', style: t.titleLarge),
                const Spacer(),
                OutlinedButton.icon(
                  icon: const Icon(Icons.language),
                  label: const Text('English (UK)'),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
            Center(child: Text('Getting Started', style: t.headlineMedium)),
            const SizedBox(height: 8),
            Center(child: Text('Create an account to continue and connect\nwith the people.', textAlign: TextAlign.center, style: t.bodyMedium)),
            const SizedBox(height: 24),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      Row(children: [
                        Expanded(child: SocialButton(icon: Icons.g_mobiledata, label: 'Log in with Google', onTap: (){})),
                        const SizedBox(width: 12),
                        Expanded(child: SocialButton(icon: Icons.apple, label: 'Log in with Apple', onTap: (){})),
                      ]),
                      const SizedBox(height: 12),
                      const OrDivider(),
                      const SizedBox(height: 12),
                      AppTextField(controller: _email, hint: 'Your Email', keyboardType: TextInputType.emailAddress, validator: emailValidator),
                      const SizedBox(height: 12),
                      AppTextField(controller: _name,  hint: 'Your Name', validator: nameValidator),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _password,
                        hint: 'Create Password',
                        obscure: _hide,
                        validator: passwordValidator,
                        suffix: IconButton(
                          icon: Icon(_hide ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _hide = !_hide),
                        ),
                      ),
                      const SizedBox(height: 12),
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
                            hint: _dob == null ? 'Date of birth' : '${_dob!.year}-${_dob!.month.toString().padLeft(2, '0')}-${_dob!.day.toString().padLeft(2, '0')}',
                            validator: (_) => _dob == null ? 'Select date of birth' : null,
                            controller: TextEditingController(text: ''),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GenderSelector(value: _gender, onChanged: (g) => setState(() => _gender = g)),
                      const SizedBox(height: 16),
                      AppButton(
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
                            if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                          } finally {
                            if (mounted) setState(() => _loading = false);
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: const Text('Already have an account?  Sign In'),
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
