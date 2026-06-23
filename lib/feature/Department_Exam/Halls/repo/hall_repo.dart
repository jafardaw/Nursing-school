import '../data/hall_model.dart';

abstract class HallRepository {
  Future<List<HallModel>> getHalls();
  Future<HallModel> createHall({
    required String name,
    required int capacity,
    required String type,
  });
  Future<HallModel> updateHall({
    required int id,
    required String name,
    required int capacity,
    required String type,
  });
  Future<void> deleteHall(int id);
}
