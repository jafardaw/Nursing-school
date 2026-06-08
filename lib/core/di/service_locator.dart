import 'package:finalproject/feature/Department_Exam/Exam_Session/repo/exam_session_repo.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Session/repo/exam_session_repo_impl.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Session/presentation/manger/exam_session_cubit.dart';
import 'package:finalproject/feature/Department_Exam/Halls/repo/hall_repo.dart';
import 'package:finalproject/feature/Department_Exam/Halls/repo/hall_repo_impl.dart';
import 'package:finalproject/feature/Department_Exam/Halls/presentation/manger/hall_cubit.dart';
import 'package:finalproject/feature/Department_Exam/Subject/presentation/manger/get_cubit/get_all_subject_cubit.dart';
import 'package:finalproject/feature/Department_Exam/Subject/repo/subject_repo.dart';
import 'package:finalproject/feature/Department_Exam/Subject/repo/subject_repo_impl.dart';
import 'package:finalproject/feature/Department_Student_Affair/Statistic/presentation/manger/get_cibit/get_statistic_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/Statistic/repo/statistic_repo.dart';
import 'package:finalproject/feature/Department_Student_Affair/Statistic/repo/statistic_repoimpl.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/manger/cubit_delete/delete_penalties_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/manger/cubit_get/get_all_penalties_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/manger/cubit_post/add_penalites_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/repo/penalties_repo.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/repo/penalties_repoimp.dart';
import 'package:finalproject/feature/Department_Student_Affair/specializations/presentation/manger/get_cubit/get_specialization_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/specializations/repo/repo_specialization.dart';
import 'package:finalproject/feature/Department_Student_Affair/specializations/repo/repoimpl_specialization.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/domain/repositories/students_repo.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/domain/repositories/students_repo_impl.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/addstudent/add_student_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/cubit/export_pdf_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/students_cubit.dart';
import 'package:finalproject/feature/auth/presentation/manger/auth_cubit.dart';
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
  //student record

  //delete_penalties

  sl.registerFactory(() => DeletePenaltyCubit(sl<AbsenceRepository>()));
  //////////Statistic
  sl.registerLazySingleton<StatisticsRepository>(
    () => StatisticsRepositoryImpl(sl.get<ApiService>()),
  );
  sl.registerFactory(() => StatisticsCubit(sl.get<StatisticsRepository>()));

  //////////specialization
  sl.registerFactory<ExportPdfCubit>(() => ExportPdfCubit(sl<StudentsRepo>()));

  // تسجيل الـ Repository
  sl.registerLazySingleton<SpecializationRepository>(
    () => SpecializationRepositoryImpl(sl.get<ApiService>()),
  );

  // تسجيل الـ Cubit (سأفترض أنك ستنشئ Cubit باسم GetSpecializationsCubit)
  sl.registerFactory(
    () => GetSpecializationsCubit(sl.get<SpecializationRepository>()),
  );

  ///////////subject
  sl.registerLazySingleton<SubjectRepository>(
    () => SubjectRepositoryImpl(sl()),
  );
  sl.registerFactory(() => SubjectCubit(sl()));

  ///////////exam session
  sl.registerLazySingleton<ExamSessionRepository>(
    () => ExamSessionRepositoryImpl(sl()),
  );
  sl.registerFactory(() => ExamSessionCubit(sl()));

  ///////////halls
  sl.registerLazySingleton<HallRepository>(
    () => HallRepositoryImpl(sl()),
  );
  sl.registerFactory(() => HallCubit(sl()));
}
