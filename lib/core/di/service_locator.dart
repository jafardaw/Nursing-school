import 'package:finalproject/feature/auth/presentation/manger/auth_cubit.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/domain/repositories/students_repo.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/domain/repositories/students_repo_impl.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/presentation/manger/addstudent/add_student_cubit.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/presentation/manger/cubit/export_pdf_cubit.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/presentation/manger/students_cubit.dart';
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

  // 🟢 Cubits
  sl.registerLazySingleton<AuthCubit>(() => AuthCubit(sl<AuthRepoImpl>()));

  //student record
  sl.registerLazySingleton<StudentsRepo>(
    () => StudentsRepoImpl(apiService: sl()),
  );

  // Cubits
  sl.registerFactory<StudentsCubit>(
    () => StudentsCubit(sl<StudentsRepo>()), // 🟢 استخدم StudentsRepo
  );
  sl.registerFactory<AddStudentCubit>(
    () => AddStudentCubit(sl<StudentsRepo>()),
  );

  //
  sl.registerFactory<ExportPdfCubit>(() => ExportPdfCubit(sl<StudentsRepo>()));
  //student record
}
