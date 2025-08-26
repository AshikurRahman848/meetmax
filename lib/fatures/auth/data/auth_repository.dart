import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/di.dart';
import 'mock_auth_api.dart';

class AuthRepository {
  AuthRepository(this._api, {required SharedPreferences prefs})
      : _prefs = prefs { _controller.add(isLoggedInSync); }

  final MockAuthApi _api;
  final SharedPreferences _prefs;
  final _controller = StreamController<bool>.broadcast();
  static const _kToken = 'auth_token';

  Stream<bool> get authStateChanges => _controller.stream;
  bool get isLoggedInSync => _prefs.getString(_kToken) != null;

  Future<void> signUp({required String email, required String name, required String password, required DateTime dob, required String gender}) async {
    final token = await _api.signUp(email: email, name: name, password: password, dob: dob, gender: gender);
    await _prefs.setString(_kToken, token);
    _controller.add(true);
  }

  Future<void> signIn(String email, String password) async {
    final token = await _api.signIn(email: email, password: password);
    await _prefs.setString(_kToken, token);
    _controller.add(true);
  }

  Future<void> signOut() async { await _prefs.remove(_kToken); _controller.add(false); }
}

final authRepositoryProvider = Provider<AuthRepository>((_) => sl<AuthRepository>());
