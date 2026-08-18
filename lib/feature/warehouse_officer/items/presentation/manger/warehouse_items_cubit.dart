import 'package:finalproject/feature/warehouse_officer/items/data/model/warehouse_item_model.dart';
import 'package:finalproject/feature/warehouse_officer/items/domain/repositories/warehouse_items_repo.dart';
import 'package:finalproject/feature/warehouse_officer/items/presentation/manger/warehouse_items_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WarehouseItemsCubit extends Cubit<WarehouseItemsState> {
  final WarehouseItemsRepo _repo;

  List<WarehouseItemModel> _items = [];
  WarehouseItemsMeta? _meta;

  List<WarehouseItemModel> get items => List.unmodifiable(_items);
  WarehouseItemsMeta? get meta => _meta;

  WarehouseItemsCubit(this._repo) : super(WarehouseItemsInitial());

  Future<void> fetchItems({int page = 1}) async {
    emit(WarehouseItemsLoading());
    try {
      final response = await _repo.getItems(page: page);
      _items = response.data;
      _meta = response.meta;
      emit(WarehouseItemsSuccess(items: _items, meta: _meta));
    } catch (e) {
      emit(WarehouseItemsError('فشل جلب قائمة المواد: ${e.toString()}'));
    }
  }

  Future<void> searchItems({
    String? name,
    String? unit,
    int page = 1,
  }) async {
    emit(WarehouseItemsLoading());
    try {
      final response = await _repo.searchItems(
        name: name,
        unit: unit,
        page: page,
      );
      _items = response.data;
      _meta = response.meta;
      emit(WarehouseItemsSuccess(items: _items, meta: _meta));
    } catch (e) {
      emit(WarehouseItemsError('فشل نتائج البحث: ${e.toString()}'));
    }
  }

  Future<void> createItem(CreateUpdateWarehouseItemRequest request) async {
    emit(WarehouseItemActionLoading());
    try {
      final response = await _repo.createItem(request);
      emit(WarehouseItemActionSuccess(response.message.isNotEmpty
          ? response.message
          : 'تمت إضافة المادة بنجاح'));
      fetchItems();
    } catch (e) {
      emit(WarehouseItemsError('فشل إضافة المادة: ${e.toString()}'));
    }
  }

  Future<void> updateItem({
    required int id,
    required CreateUpdateWarehouseItemRequest request,
  }) async {
    emit(WarehouseItemActionLoading());
    try {
      final response = await _repo.updateItem(id: id, request: request);
      emit(WarehouseItemActionSuccess(response.message.isNotEmpty
          ? response.message
          : 'تم تعديل المادة بنجاح'));
      fetchItems();
    } catch (e) {
      emit(WarehouseItemsError('فشل تعديل المادة: ${e.toString()}'));
    }
  }

  Future<void> deleteItem(int id) async {
    emit(WarehouseItemActionLoading());
    try {
      await _repo.deleteItem(id);
      emit(WarehouseItemActionSuccess('تم حذف المادة بنجاح'));
      fetchItems();
    } catch (e) {
      emit(WarehouseItemsError('فشل حذف المادة: ${e.toString()}'));
    }
  }
}
