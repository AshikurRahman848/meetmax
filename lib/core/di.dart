import 'package:get_it/get_it.dart';
import 'package:meetmax/fatures/auth/data/auth_repository.dart';
import 'package:meetmax/fatures/auth/data/mock_auth_api.dart';
import 'package:meetmax/fatures/feed/data/feed_repository.dart';
import 'package:meetmax/fatures/feed/data/mock_feed_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  final prefs = await SharedPreferences.getInstance();
  // APIs
  sl.registerLazySingleton(() => MockAuthApi());
  sl.registerLazySingleton(() => MockFeedApi());
  // Infra
  sl.registerSingleton<SharedPreferences>(prefs);
  // Repos
  sl.registerLazySingleton(() => AuthRepository(sl(), prefs: sl()));
  sl.registerLazySingleton(() => FeedRepository(sl()));
}
