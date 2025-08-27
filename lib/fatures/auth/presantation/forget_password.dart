import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meetmax/common/widget/app_button.dart';
import 'package:meetmax/common/widget/app_text_field.dart';
import 'package:meetmax/common/widget/top_bar.dart'; // <-- use shared top bar
import 'package:meetmax/core/validator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);

    // TODO: call your API to send reset link
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reset link sent (mock)')),
    );
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            const TopBar(), // ✅ consistent logo + language pill
            const SizedBox(height: 56),

            Center(child: Text('Forgot password?', style: t.headlineMedium)),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Enter your details to receive a reset link',
                style: t.bodyLarge?.copyWith(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 28),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Color(0x1A000000), blurRadius: 22, offset: Offset(0, 8)),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextField(
                      controller: _email,
                      hint: '@ Your Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: emailValidator,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: 'Send',
                        loading: _loading,
                        onPressed: _submit,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton.icon(
                        onPressed: () => context.go('/login'),
                        icon: const Icon(Icons.chevron_left),
                        label: const Text('Back to Sign In'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
