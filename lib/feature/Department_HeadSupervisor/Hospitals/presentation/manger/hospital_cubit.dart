import 'package:finalproject/feature/Department_HeadSupervisor/Hospitals/data/hospital_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repo/hospital_repo.dart';
import 'hospital_state.dart';

class HospitalCubit extends Cubit<HospitalState> {
  final HospitalRepository repository;
  List<HospitalModel> hospitals = [];

  HospitalCubit(this.repository) : super(HospitalInitial());

  Future<void> fetchHospitals() async {
    emit(HospitalLoading());
    try {
      hospitals = await repository.getHospitals();
      emit(HospitalLoaded(hospitals));
    } catch (e) {
      emit(HospitalError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }

  Future<void> createHospital({required String name}) async {
    emit(HospitalActionLoading());
    try {
      final newHospital = await repository.createHospital(name: name);
      hospitals.insert(0, newHospital);
      emit(HospitalActionSuccess('تم إضافة المستشفى بنجاح'));
    } catch (e) {
      emit(HospitalError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }

  Future<void> updateHospital({required int id, required String name}) async {
    emit(HospitalActionLoading());
    try {
      final updated = await repository.updateHospital(id: id, name: name);
      final index = hospitals.indexWhere((h) => h.id == id);
      if (index != -1) hospitals[index] = updated;
      emit(HospitalActionSuccess('تم تعديل المستشفى بنجاح'));
    } catch (e) {
      emit(HospitalError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }

  Future<void> deleteHospital(int id) async {
    emit(HospitalActionLoading());
    try {
      await repository.deleteHospital(id);
      hospitals.removeWhere((h) => h.id == id);
      emit(HospitalActionSuccess('تم حذف المستشفى بنجاح'));
    } catch (e) {
      emit(HospitalError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }
}
