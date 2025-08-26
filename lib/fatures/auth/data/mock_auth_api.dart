import 'dart:async';

class MockAuthApi {
  Future<String> signUp({
    required String email, required String name, required String password,
    required DateTime dob, required String gender,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return 'token_signup';
  }

  Future<String> signIn({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return 'token_login';
  }
}
