import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hint,
    this.obscure = false,
    this.keyboardType,
    this.validator,
    this.suffix,
    this.prefix, 
  });

  final TextEditingController? controller;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffix;
  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefix,
        suffixIcon: suffix,
      ),
    );
  }
}
