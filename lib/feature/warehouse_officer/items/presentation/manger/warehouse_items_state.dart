import 'package:finalproject/feature/warehouse_officer/items/data/model/warehouse_item_model.dart';

abstract class WarehouseItemsState {}

class WarehouseItemsInitial extends WarehouseItemsState {}

class WarehouseItemsLoading extends WarehouseItemsState {}

class WarehouseItemsSuccess extends WarehouseItemsState {
  final List<WarehouseItemModel> items;
  final WarehouseItemsMeta? meta;

  WarehouseItemsSuccess({required this.items, this.meta});
}

class WarehouseItemsError extends WarehouseItemsState {
  final String message;

  WarehouseItemsError(this.message);
}

class WarehouseItemActionLoading extends WarehouseItemsState {}

class WarehouseItemActionSuccess extends WarehouseItemsState {
  final String message;

  WarehouseItemActionSuccess(this.message);
}
