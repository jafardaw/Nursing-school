import 'package:finalproject/feature/auth/presentation/manger/auth_cubit.dart';
import 'package:finalproject/feature/penalties/presentation/manger/cubit_get/get_all_penalties_cubit.dart';
import 'package:finalproject/feature/penalties/presentation/manger/cubit_post/add_penalites_cubit.dart';
import 'package:finalproject/feature/penalties/repo/penalties_repo.dart';
import 'package:finalproject/feature/penalties/repo/penalties_repoimp.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/core/storage/storage_service.dart';
import 'package:finalproject/feature/auth/repo/auth_repo_impl.dart';

final GetIt sl = GetIt.instance;
Future<void> initServiceLocator() async {
  // ====== 1. External (المكتبات الخارجية) ======
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // ====== 2. Core Services (الخدمات الأساسية) ======
  sl.registerLazySingleton<StorageService>(() => StorageServiceImpl(sl()));
  sl.registerLazySingleton<ApiService>(() => ApiService(storageService: sl()));

  // ====== 3. Auth Feature ======
  // Repositories
  sl.registerLazySingleton<AuthRepoImpl>(
    () => AuthRepoImpl(apiService: sl(), storageService: sl()),
  );
  // Cubits (يفضل Factory لضمان حالة نظيفة عند تسجيل الدخول مجدداً)
  sl.registerFactory(() => AuthCubit(sl<AuthRepoImpl>()));

  // ====== 4. Penalties Feature (الغيابات والعقوبات) ======
  // Repository (نسخة واحدة لكل التطبيق)
  sl.registerLazySingleton<AbsenceRepository>(
    () => AbsenceRepositoryImpl(sl()),
  );

  // Cubits (نسخة جديدة عند كل طلب صفحة)
  sl.registerFactory(() => AbsenceCubit(sl()));
  sl.registerFactory(() => AddPenaltyCubit(sl()));
}
