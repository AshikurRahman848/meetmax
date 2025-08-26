import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meetmax/fatures/auth/data/auth_repository.dart';
import 'package:meetmax/fatures/auth/presantation/login_screen.dart';
import 'package:meetmax/fatures/auth/presantation/sign-up_screen.dart';
import 'package:meetmax/fatures/feed/presantation/feed_screen.dart';

/// Replacement for GoRouterRefreshStream
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

final authStateProvider = StreamProvider<bool>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges,
);

final routerProvider = Provider<GoRouter>((ref) {
  final authStream = ref.watch(authStateProvider.stream);
  return GoRouter(
    initialLocation: '/signup',
    // ⬇️ use our RouterRefresh instead of GoRouterRefreshStream
    refreshListenable: RouterRefresh(authStream),
    redirect: (_, state) {
      final loggedIn = ref.read(authRepositoryProvider).isLoggedInSync;
      final onAuth = state.matchedLocation == '/login' || state.matchedLocation == '/signup';
      if (!loggedIn && !onAuth) return '/signup';
      if (loggedIn && onAuth) return '/feed';
      return null;
    },
    routes: [
      GoRoute(path: '/signup', builder: (_, __) => const SignUpScreen()),
      GoRoute(path: '/login',  builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/feed',   builder: (_, __) => const FeedScreen()),
    ],
  );
});
