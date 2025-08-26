String? emailValidator(String? v) {
  if (v == null || v.trim().isEmpty) return 'Email is required';
  final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v);
  return ok ? null : 'Enter a valid email';
}

String? nameValidator(String? v) {
  if (v == null || v.trim().isEmpty) return 'Name is required';
  if (v.trim().length < 2) return 'Enter a valid name';
  return null;
}

String? passwordValidator(String? v) {
  if (v == null || v.isEmpty) return 'Password is required';
  if (v.length < 8) return 'Min 8 characters';
  if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Include an uppercase letter';
  if (!RegExp(r'[a-z]').hasMatch(v)) return 'Include a lowercase letter';
  if (!RegExp(r'\d').hasMatch(v)) return 'Include a number';
  return null;
}
