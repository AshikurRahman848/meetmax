import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:meetmax/fatures/auth/data/auth_repository.dart';
import 'package:meetmax/fatures/auth/presantation/forget_password.dart';
import 'package:meetmax/fatures/auth/presantation/login_screen.dart';
import 'package:meetmax/fatures/auth/presantation/sign-up_screen.dart';
//import 'package:meetmax/fatures/auth/presantation/forgot_password_screen.dart';
import 'package:meetmax/fatures/feed/presantation/feed_screen.dart';

class RouterRefresh extends ChangeNotifier {
  RouterRefresh(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  // Rebuild routes when auth state changes
  final auth = ref.read(authRepositoryProvider);
  final refresh = RouterRefresh(auth.authStateChanges);

  return GoRouter(
    initialLocation: '/signup',
    refreshListenable: refresh,
    redirect: (_, state) {
      final loggedIn = ref.read(authRepositoryProvider).isLoggedInSync;

      // Treat these as public "auth screens"
      final onAuth = state.matchedLocation == '/login' ||
                     state.matchedLocation == '/signup' ||
                     state.matchedLocation == '/forgot'; // ✅ allow /forgot

      if (!loggedIn && !onAuth) {
        // Not logged in and trying to access a private route
        return '/signup';
      }
      if (loggedIn && onAuth) {
        // Logged in users shouldn’t stay on auth screens
        return '/feed';
      }
      return null; // no redirect
    },
    routes: [
      GoRoute(path: '/signup', builder: (_, __) => const SignUpScreen()),
      GoRoute(path: '/login',  builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/forgot', builder: (_, __) => const ForgotPasswordScreen()),
      GoRoute(path: '/feed',   builder: (_, __) => const FeedScreen()),
    ],
  );
});
