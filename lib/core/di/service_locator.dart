import 'package:finalproject/feature/Department_Exam/Exam_Schedule/presentation/manger/seat_allocation/exam_seat_allocation_cubit.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Schedule/data/repositories/exam_seating_repository.dart';
import 'package:finalproject/feature/complaints_advanced_search/data/datasources/complaints_search_local_data_source.dart';
import 'package:finalproject/feature/complaints_advanced_search/data/datasources/complaints_search_remote_data_source.dart';
import 'package:finalproject/feature/complaints_advanced_search/data/repositories/complaints_search_repository_impl.dart';
import 'package:finalproject/feature/complaints_advanced_search/domain/repositories/complaints_search_repository.dart';
import 'package:finalproject/feature/complaints_advanced_search/domain/usecases/get_search_history_usecase.dart';
import 'package:finalproject/feature/complaints_advanced_search/domain/usecases/save_search_history_usecase.dart';
import 'package:finalproject/feature/complaints_advanced_search/domain/usecases/search_complaints_usecase.dart';
import 'package:finalproject/feature/complaints_advanced_search/presentation/manger/complaints_search_cubit.dart';
import 'package:finalproject/core/services/firebase_notification_service.dart';
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
import 'package:finalproject/feature/Department_HeadSupervisor/matching/domain/repositories/matching_campaign_repository.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/domain/repositories/matching_campaign_repository_impl.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/presentation/manger/matching_campaign_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/presentation/manger/matching_results_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/domain/repositories/hospital_training_groups_repo.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/domain/repositories/hospital_training_groups_repo_impl.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/presentation/manger/hospital_training_groups_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/RoomAssignments/domain/repositories/room_assignment_repo.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/RoomAssignments/domain/repositories/room_assignment_repo_impl.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/RoomAssignments/domain/repositories/room_assignment_students_repo.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/RoomAssignments/domain/repositories/room_assignment_students_repo_impl.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/RoomAssignments/presentation/manger/room_assignment_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/RoomAssignments/presentation/manger/room_assignment_students_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/manger/cubit_delete/delete_penalties_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/manger/cubit_get/get_all_penalties_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/manger/cubit_post/add_penalites_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/repo/penalties_repo.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/repo/penalties_repoimp.dart';
import 'package:finalproject/feature/Department_Student_Affair/specializations/presentation/manger/get_cubit/get_specialization_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/specializations/repo/repo_specialization.dart';
import 'package:finalproject/feature/Department_Student_Affair/specializations/repo/repoimpl_specialization.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/domain/repositories/students_repo_impl.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/domain/repositories/student_documents_repo.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/domain/repositories/student_documents_repo_impl.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/addstudent/add_student_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/cubit/delete_student_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/cubit/export_pdf_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/cubit/update_student_cubit.dart';
import 'package:finalproject/feature/Department_Exam/Marks/domain/repositories/marks_repo.dart';
import 'package:finalproject/feature/Department_Exam/Marks/data/repositories/marks_repo_impl.dart';
import 'package:finalproject/feature/Department_Exam/Marks/presentation/manger/marks_cubit.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Schedule/data/repositories/exam_schedule_repo.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Schedule/data/repositories/exam_schedule_repo_impl.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Schedule/presentation/manger/exam_schedule_cubit.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Schedule/presentation/manger/management/exam_schedule_management_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/students_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/student_documents_cubit.dart';
import 'package:finalproject/feature/auth/presentation/manger/auth_cubit.dart';
import 'package:finalproject/feature/engineering_office/domain/repositories/complaints_repo.dart';
import 'package:finalproject/feature/engineering_office/domain/repositories/complaints_repo_impl.dart';
import 'package:finalproject/feature/engineering_office/inventory/domain/repositories/inventory_repo.dart';
import 'package:finalproject/feature/engineering_office/inventory/domain/repositories/inventory_repo_impl.dart';
import 'package:finalproject/feature/engineering_office/inventory/presentation/manger/inventory_cubit.dart';
import 'package:finalproject/feature/engineering_office/maintenance_requests/domain/repositories/maintenance_requests_repo.dart';
import 'package:finalproject/feature/engineering_office/maintenance_requests/domain/repositories/maintenance_requests_repo_impl.dart';
import 'package:finalproject/feature/engineering_office/maintenance_requests/presentation/manger/maintenance_requests_cubit.dart';
import 'package:finalproject/feature/engineering_office/presentation/manger/complaints_cubit.dart';
import 'package:finalproject/feature/engineering_office/stock-in/domain/repositories/stock_repo.dart';
import 'package:finalproject/feature/engineering_office/stock-in/domain/repositories/stock_repo_impl.dart';
import 'package:finalproject/feature/engineering_office/stock-in/presentation/manger/stock_cubit.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/domain/repositories/students_repo.dart';
import 'package:finalproject/feature/Manager/data/repositories/manager_repo.dart';
import 'package:finalproject/feature/Manager/data/repositories/manager_repo_impl.dart';
import 'package:finalproject/feature/Manager/presentation/manger/manager_dashboard_cubit.dart';
import 'package:finalproject/feature/Manager/presentation/manger/employees_cubit.dart';
import 'package:finalproject/feature/announcements/domain/repositories/announcements_repo.dart';
import 'package:finalproject/feature/announcements/domain/repositories/announcements_repo_impl.dart';
import 'package:finalproject/feature/announcements/presentation/manger/announcements_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/domain/repositories/warehouse_complaints_repo.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/domain/repositories/warehouse_complaints_repo_impl.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/presentation/manger/warehouse_complaints_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/custody/domain/repositories/warehouse_custody_repo.dart';
import 'package:finalproject/feature/warehouse_officer/custody/domain/repositories/warehouse_custody_repo_impl.dart';
import 'package:finalproject/feature/warehouse_officer/custody/presentation/manger/warehouse_custody_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/domain/repositories/warehouse_maintenance_repo.dart';
import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/domain/repositories/warehouse_maintenance_repo_impl.dart';
import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/presentation/manger/warehouse_maintenance_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/domain/repositories/warehouse_stock_in_repo.dart';
import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/domain/repositories/warehouse_stock_in_repo_impl.dart';
import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/presentation/manger/warehouse_stock_in_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/statistics/domain/repositories/warehouse_statistics_repo.dart';
import 'package:finalproject/feature/warehouse_officer/statistics/domain/repositories/warehouse_statistics_repo_impl.dart';
import 'package:finalproject/feature/warehouse_officer/statistics/presentation/manger/warehouse_statistics_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/items/domain/repositories/warehouse_items_repo.dart';
import 'package:finalproject/feature/warehouse_officer/items/domain/repositories/warehouse_items_repo_impl.dart';
import 'package:finalproject/feature/warehouse_officer/items/presentation/manger/warehouse_items_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/clearance/domain/repositories/warehouse_clearance_repo.dart';
import 'package:finalproject/feature/warehouse_officer/clearance/domain/repositories/warehouse_clearance_repo_impl.dart';
import 'package:finalproject/feature/warehouse_officer/clearance/presentation/manger/warehouse_clearance_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Hospitals/presentation/manger/hospital_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Hospitals/repo/hospital_repo.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Hospitals/repo/hospital_repo_impl.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Dormitory/repo/dormitory_repo.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Dormitory/repo/dormitory_repo_impl.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Dormitory/presentation/manger/dorm_building_cubit/dorm_building_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Dormitory/presentation/manger/dorm_room_cubit/dorm_room_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/hospital_attendance/domain/repositories/hospital_attendance_repo.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/hospital_attendance/domain/repositories/hospital_attendance_repo_impl.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/hospital_attendance/presentation/manger/hospital_attendance_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/gate_attendance/domain/repositories/gate_attendance_repo.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/gate_attendance/domain/repositories/gate_attendance_repo_impl.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/gate_attendance/presentation/manger/gate_attendance_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/dormitory_attendance/domain/repositories/dormitory_attendance_repo.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/dormitory_attendance/domain/repositories/dormitory_attendance_repo_impl.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/dormitory_attendance/presentation/manger/dormitory_attendance_cubit.dart';
import 'package:flutter/foundation.dart';
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
  sl.registerLazySingleton<StudentDocumentsRepo>(
    () => StudentDocumentsRepoImpl(apiService: sl()),
  );

  // Cubits
  sl.registerFactory<StudentsCubit>(
    () => StudentsCubit(sl<StudentsRepo>()), // 🟢 استخدم StudentsRepo
  );
  sl.registerFactory<AddStudentCubit>(
    () => AddStudentCubit(sl<StudentsRepo>()),
  );
  sl.registerFactory<DeleteStudentCubit>(
    () => DeleteStudentCubit(sl<StudentsRepo>()),
  );
  sl.registerFactory<StudentDocumentsCubit>(
    () => StudentDocumentsCubit(sl<StudentDocumentsRepo>()),
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
  sl.registerFactory(() => AddPenaltyCubit(sl(), storage: sl()));
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
  sl.registerFactory<UpdateStudentCubit>(
    () => UpdateStudentCubit(sl<StudentsRepo>()),
  );
  // تسجيل الـ Repository
  sl.registerLazySingleton<SpecializationRepository>(
    () => SpecializationRepositoryImpl(sl.get<ApiService>()),
  );

  // تسجيل الـ Cubit (سأفترض أنك ستنشئ Cubit باسم GetSpecializationsCubit)
  sl.registerFactory(
    () => GetSpecializationsCubit(sl.get<SpecializationRepository>()),
  );
  // Engineering Office
  sl.registerLazySingleton<ComplaintsRepo>(
    () => ComplaintsRepoImpl(apiService: sl(), storage: sl()),
  );
  sl.registerFactory<ComplaintsCubit>(() => ComplaintsCubit(sl()));
  sl.registerLazySingleton<StockRepo>(() => StockRepoImpl(apiService: sl()));
  sl.registerFactory<StockCubit>(() => StockCubit(sl()));
  sl.registerLazySingleton<InventoryRepo>(
    () => InventoryRepoImpl(apiService: sl()),
  );
  sl.registerFactory<InventoryCubit>(() => InventoryCubit(sl()));
  sl.registerLazySingleton<MaintenanceRequestsRepo>(
    () => MaintenanceRequestsRepoImpl(apiService: sl()),
  );
  sl.registerFactory<MaintenanceRequestsCubit>(
    () => MaintenanceRequestsCubit(sl()),
  );
  sl.registerLazySingleton<WarehouseComplaintsRepo>(
    () => WarehouseComplaintsRepoImpl(apiService: sl(), storageService: sl()),
  );
  sl.registerFactory<WarehouseComplaintsCubit>(
    () => WarehouseComplaintsCubit(sl()),
  );
  sl.registerLazySingleton<WarehouseStockInRepo>(
    () => WarehouseStockInRepoImpl(apiService: sl()),
  );
  sl.registerFactory<WarehouseStockInCubit>(() => WarehouseStockInCubit(sl()));
  sl.registerLazySingleton<WarehouseCustodyRepo>(
    () => WarehouseCustodyRepoImpl(apiService: sl()),
  );
  sl.registerFactory<WarehouseCustodyCubit>(() => WarehouseCustodyCubit(sl()));
  sl.registerLazySingleton<WarehouseStatisticsRepo>(
    () => WarehouseStatisticsRepoImpl(apiService: sl()),
  );
  sl.registerFactory<WarehouseStatisticsCubit>(
    () => WarehouseStatisticsCubit(sl()),
  );
  sl.registerLazySingleton<WarehouseMaintenanceRepo>(
    () => WarehouseMaintenanceRepoImpl(apiService: sl()),
  );
  sl.registerFactory<WarehouseMaintenanceCubit>(
    () => WarehouseMaintenanceCubit(sl()),
  );
  sl.registerLazySingleton<WarehouseItemsRepo>(
    () => WarehouseItemsRepoImpl(apiService: sl()),
  );
  sl.registerFactory<WarehouseItemsCubit>(
    () => WarehouseItemsCubit(sl()),
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
  sl.registerLazySingleton<HallRepository>(() => HallRepositoryImpl(sl()));
  sl.registerFactory(() => HallCubit(sl()));

  ///////////marks
  sl.registerLazySingleton<MarksRepository>(
    () => MarksRepositoryImpl(apiService: sl()),
  );
  sl.registerFactory(
    // ignore: avoid_redundant_argument_values
    () => MarksCubit(marksRepository: sl(), sessionRepository: sl()),
  );

  ///////////exam schedule
  sl.registerLazySingleton<ExamScheduleRepository>(
    () => ExamScheduleRepositoryImpl(sl()),
  );
  sl.registerFactory(() => ExamScheduleCubit(sl()));
  sl.registerFactory(() => ExamScheduleManagementCubit(sl()));
  sl.registerLazySingleton<ExamSeatingRepository>(
    () => ExamSeatingRepositoryImpl(sl()),
  );
  sl.registerFactory<ExamSeatAllocationCubit>(
    () => ExamSeatAllocationCubit(
      sl<HallRepository>(),
      sl<ExamSeatingRepository>(),
    ),
  );

  /////////// head supervisor hospitals
  sl.registerLazySingleton<HospitalRepository>(
    () => HospitalRepositoryImpl(sl()),
  );
  sl.registerFactory<HospitalCubit>(
    () => HospitalCubit(sl<HospitalRepository>()),
  );

  /////////// matching campaigns
  sl.registerLazySingleton<MatchingCampaignRepository>(
    () => MatchingCampaignRepositoryImpl(sl()),
  );
  sl.registerFactory<MatchingCampaignCubit>(
    () => MatchingCampaignCubit(
      sl<MatchingCampaignRepository>(),
      sl<HospitalRepository>(),
    ),
  );
  sl.registerFactoryParam<MatchingResultsCubit, int, void>(
    (campaignId, _) => MatchingResultsCubit(
      repository: sl<MatchingCampaignRepository>(),
      campaignId: campaignId,
    ),
  );

  /////////// dormitory (buildings & rooms)
  sl.registerLazySingleton<DormitoryRepository>(
    () => DormitoryRepositoryImpl(sl()),
  );
  sl.registerFactory<DormBuildingCubit>(
    () => DormBuildingCubit(sl<DormitoryRepository>()),
  );
  sl.registerFactory<DormRoomCubit>(
    () => DormRoomCubit(sl<DormitoryRepository>()),
  );
  sl.registerLazySingleton<RoomAssignmentRepository>(
    () => RoomAssignmentRepositoryImpl(sl()),
  );
  sl.registerFactory<RoomAssignmentCubit>(
    () => RoomAssignmentCubit(sl<RoomAssignmentRepository>()),
  );
  sl.registerLazySingleton<RoomAssignmentStudentsRepository>(
    () => RoomAssignmentStudentsRepositoryImpl(sl()),
  );
  sl.registerFactory<RoomAssignmentStudentsCubit>(
    () => RoomAssignmentStudentsCubit(sl<RoomAssignmentStudentsRepository>()),
  );

  /////////// hospital training groups
  sl.registerLazySingleton<HospitalTrainingGroupsRepo>(
    () => HospitalTrainingGroupsRepoImpl(sl(), sl<HospitalRepository>()),
  );
  sl.registerFactory<HospitalTrainingGroupsCubit>(
    () => HospitalTrainingGroupsCubit(sl<HospitalTrainingGroupsRepo>()),
  );

  /////////// attendance monitoring (head supervisor)
  sl.registerLazySingleton<HospitalAttendanceRepo>(
    () => HospitalAttendanceRepoImpl(sl()),
  );
  sl.registerFactory<HospitalAttendanceCubit>(
    () => HospitalAttendanceCubit(sl<HospitalAttendanceRepo>()),
  );
  sl.registerLazySingleton<GateAttendanceRepo>(
    () => GateAttendanceRepoImpl(sl()),
  );
  sl.registerFactory<GateAttendanceCubit>(
    () => GateAttendanceCubit(sl<GateAttendanceRepo>()),
  );
  sl.registerLazySingleton<DormitoryAttendanceRepo>(
    () => DormitoryAttendanceRepoImpl(sl()),
  );
  sl.registerFactory<DormitoryAttendanceCubit>(
    () => DormitoryAttendanceCubit(sl<DormitoryAttendanceRepo>()),
  );

  /////////// manager dashboard
  sl.registerLazySingleton<ManagerRepository>(
    () => ManagerRepositoryImpl(sl()),
  );
  sl.registerFactory(() => ManagerDashboardCubit(sl()));
  sl.registerFactory(() => EmployeesCubit(sl()));

  /////////// shared announcements
  sl.registerLazySingleton<AnnouncementsRepo>(
    () => AnnouncementsRepoImpl(sl()),
  );
  sl.registerFactory<AnnouncementsCubit>(
    () => AnnouncementsCubit(sl<AnnouncementsRepo>()),
  );

  /////////// complaints advanced search (Clean Architecture)
  sl.registerLazySingleton<ComplaintsSearchRemoteDataSource>(
    () => ComplaintsSearchRemoteDataSourceImpl(apiService: sl()),
  );
  sl.registerLazySingleton<ComplaintsSearchLocalDataSource>(
    () => ComplaintsSearchLocalDataSourceImpl(storageService: sl()),
  );
  sl.registerLazySingleton<ComplaintsSearchRepository>(
    () => ComplaintsSearchRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<SearchComplaintsUseCase>(
    () => SearchComplaintsUseCase(repository: sl()),
  );
  sl.registerLazySingleton<GetSearchHistoryUseCase>(
    () => GetSearchHistoryUseCase(repository: sl()),
  );
  sl.registerLazySingleton<SaveSearchHistoryUseCase>(
    () => SaveSearchHistoryUseCase(repository: sl()),
  );
  sl.registerFactory<ComplaintsSearchCubit>(
    () => ComplaintsSearchCubit(
      searchComplaintsUseCase: sl(),
      getSearchHistoryUseCase: sl(),
      saveSearchHistoryUseCase: sl(),
    ),
  );

  /////////// Warehouse Officer - Student Clearance
  sl.registerLazySingleton<WarehouseClearanceRepo>(
    () => WarehouseClearanceRepoImpl(api: sl()),
  );
  sl.registerFactory<WarehouseClearanceCubit>(
    () => WarehouseClearanceCubit(sl()),
  );
}

///////////////////225
