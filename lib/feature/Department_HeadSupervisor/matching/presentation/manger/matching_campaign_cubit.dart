import 'package:finalproject/feature/Department_HeadSupervisor/Hospitals/data/hospital_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Hospitals/repo/hospital_repo.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/data/matching_campaign_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/domain/repositories/matching_campaign_repository.dart';
import 'package:finalproject/feature/Department_Student_Affair/specializations/data/specialization_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'matching_campaign_state.dart';

class MatchingCampaignCubit extends Cubit<MatchingCampaignState> {
  final MatchingCampaignRepository repository;
  final HospitalRepository hospitalRepository;

  // Specializations ثابتة (3 فقط)
  static final List<SpecializationModel> _staticSpecializations = [
    SpecializationModel(id: 1, name: 'توليد طبيعي', durationYears: 4),
    SpecializationModel(id: 2, name: 'تخدير وإنعاش', durationYears: 4),
    SpecializationModel(id: 3, name: 'غرف عمليات', durationYears: 4),
  ];

  List<MatchingCampaignModel> campaigns = [];
  List<HospitalModel> hospitals = [];
  List<SpecializationModel> specializations = [];

  MatchingCampaignCubit(this.repository, this.hospitalRepository)
    : super(MatchingCampaignInitial());

  Future<void> loadInitialData() async {
    emit(MatchingCampaignLoading());
    try {
      // Load hospitals (required)
      await loadHospitals();

      String? warningMessage;

      // Load campaigns (optional - may fail on server)
      try {
        await fetchCampaigns(page: 1);
      } catch (e) {
        warningMessage = e.toString().replaceAll('Exception:', '').trim();
        campaigns = [];
      }

      // Use static specializations
      specializations = _staticSpecializations;

      emit(
        MatchingCampaignLoaded(
          campaigns: campaigns,
          hospitals: hospitals,
          specializations: specializations,
          warningMessage: warningMessage,
        ),
      );
    } catch (e) {
      emit(
        MatchingCampaignError(e.toString().replaceAll('Exception:', '').trim()),
      );
    }
  }

  Future<void> fetchCampaigns({int page = 1}) async {
    try {
      print('🔍 Calling repository.getCampaigns()...');
      final result = await repository.getCampaigns(page: page, perPage: 15);
      print('✅ Repository returned: $result');
      print('📝 Campaign count: ${result.length}');
      campaigns = result;
      print('💾 Campaigns stored in cubit: ${campaigns.length}');
    } catch (e) {
      print('❌ fetchCampaigns error: $e');
      throw Exception(e.toString().replaceAll('Exception:', '').trim());
    }
  }

  Future<void> loadHospitals() async {
    try {
      hospitals = await hospitalRepository.getHospitals();
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception:', '').trim());
    }
  }

  Future<bool> createCampaign({
    required String title,
    required String type,
    required String startDate,
    required String endDate,
    required String status,
  }) async {
    emit(MatchingCampaignActionLoading());
    try {
      final created = await repository.createCampaign(
        title: title,
        type: type,
        startDate: startDate,
        endDate: endDate,
        status: status,
      );
      campaigns.insert(0, created);
      // إعادة الحالة إلى Loaded بالبيانات المُحدّثة
      emit(
        MatchingCampaignLoaded(
          campaigns: campaigns,
          hospitals: hospitals,
          specializations: specializations,
        ),
      );
      return true;
    } catch (e) {
      emit(
        MatchingCampaignError(e.toString().replaceAll('Exception:', '').trim()),
      );
      return false;
    }
  }

  Future<bool> updateCampaign({
    required int id,
    String? title,
    String? type,
    String? startDate,
    String? endDate,
    String? status,
  }) async {
    emit(MatchingCampaignActionLoading());
    try {
      final updated = await repository.updateCampaign(
        id: id,
        title: title,
        type: type,
        startDate: startDate,
        endDate: endDate,
        status: status,
      );
      
      final index = campaigns.indexWhere((c) => c.id == id);
      if (index != -1) {
        campaigns[index] = updated;
      }
      
      emit(
        MatchingCampaignLoaded(
          campaigns: campaigns,
          hospitals: hospitals,
          specializations: specializations,
        ),
      );
      return true;
    } catch (e) {
      emit(
        MatchingCampaignError(e.toString().replaceAll('Exception:', '').trim()),
      );
      return false;
    }
  }

  Future<bool> createSeats({
    required int campaignId,
    required List<MatchingSeatInput> seats,
  }) async {
    emit(MatchingCampaignActionLoading());
    try {
      await repository.createSeats(campaignId: campaignId, seats: seats);
      // إعادة الحالة إلى Loaded بالبيانات الحالية لتفادي كسر الواجهة
      emit(
        MatchingCampaignLoaded(
          campaigns: campaigns,
          hospitals: hospitals,
          specializations: specializations,
        ),
      );
      return true;
    } catch (e) {
      emit(
        MatchingCampaignError(e.toString().replaceAll('Exception:', '').trim()),
      );
      return false;
    }
  }
  Future<bool> deleteCampaign(int id) async {
    emit(MatchingCampaignActionLoading());
    try {
      await repository.deleteCampaign(id);
      campaigns.removeWhere((c) => c.id == id);
      emit(
        MatchingCampaignLoaded(
          campaigns: campaigns,
          hospitals: hospitals,
          specializations: specializations,
        ),
      );
      return true;
    } catch (e) {
      emit(
        MatchingCampaignError(e.toString().replaceAll('Exception:', '').trim()),
      );
      return false;
    }
  }
}
