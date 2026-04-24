import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/core/storage/storage_service.dart';
import 'package:finalproject/feature/auth/repo/auth_repo.dart';
import 'package:finalproject/feature/auth/repo/auth_repo_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // ====== External ======
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // ====== Services ======
  sl.registerLazySingleton<StorageService>(() => StorageServiceImpl(sl()));

  sl.registerLazySingleton<ApiService>(() => ApiService(storageService: sl()));

  // ====== Repositories ======
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(apiService: sl(), storageService: sl()),
  );
}
