import '../data/hospital_model.dart';

abstract class HospitalRepository {
  Future<List<HospitalModel>> getHospitals({int page = 1, int perPage = 15});
  Future<HospitalModel> createHospital({required String name});
  Future<HospitalModel> updateHospital({required int id, required String name});
  Future<void> deleteHospital(int id);
}
