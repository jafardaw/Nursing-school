import 'package:flutter/material.dart';
import '../../../data/dorm_building_model.dart';
import '../../../data/dorm_room_model.dart';

class AddEditRoomDialog extends StatefulWidget {
  final DormRoomModel? room;
  final List<DormBuildingModel> buildings;
  final bool isLoading;
  final void Function(int dormBuildingId, String roomNumber, int floorNumber, int capacity) onSave;

  const AddEditRoomDialog({
    super.key,
    this.room,
    required this.buildings,
    required this.isLoading,
    required this.onSave,
  });

  @override
  State<AddEditRoomDialog> createState() => _AddEditRoomDialogState();
}

class _AddEditRoomDialogState extends State<AddEditRoomDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _roomNumberController;
  late final TextEditingController _floorNumberController;
  late final TextEditingController _capacityController;
  int? _selectedBuildingId;

  @override
  void initState() {
    super.initState();
    _roomNumberController = TextEditingController(text: widget.room?.roomNumber ?? '');
    _floorNumberController = TextEditingController(
      text: widget.room?.floorNumber != null ? widget.room!.floorNumber.toString() : '',
    );
    _capacityController = TextEditingController(
      text: widget.room?.capacity != null ? widget.room!.capacity.toString() : '',
    );
    _selectedBuildingId = widget.room?.dormBuildingId ??
        (widget.buildings.isNotEmpty ? widget.buildings.first.id : null);
  }

  @override
  void dispose() {
    _roomNumberController.dispose();
    _floorNumberController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedBuildingId != null) {
      final floor = int.tryParse(_floorNumberController.text) ?? 1;
      final cap = int.tryParse(_capacityController.text) ?? 4;
      widget.onSave(
        _selectedBuildingId!,
        _roomNumberController.text.trim(),
        floor,
        cap,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.room != null;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          width: 460,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                blurRadius: 40,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isEdit ? Icons.edit_rounded : Icons.meeting_room_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      isEdit ? 'تعديل بيانات الغرفة' : 'إضافة غرفة جديدة',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                    ),
                  ],
                ),
              ),
              // Body
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dropdown for Building
                        const Text(
                          'المبنى السكني',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _selectedBuildingId,
                          items: widget.buildings.map((b) {
                            return DropdownMenuItem<int>(
                              value: b.id,
                              child: Text(b.name),
                            );
                          }).toList(),
                          onChanged: isEdit
                              ? null // disable switching buildings on edit if API doesn't support or just to be safe
                              : (val) => setState(() => _selectedBuildingId = val),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.business_outlined,
                              color: Color(0xFF8B5CF6),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                          ),
                          validator: (val) {
                            if (val == null) {
                              return 'الرجاء اختيار المبنى السكني';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Room Number
                        const Text(
                          'رقم الغرفة',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _roomNumberController,
                          decoration: InputDecoration(
                            hintText: 'مثال: 101، 204...',
                            hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                            prefixIcon: const Icon(
                              Icons.tag_outlined,
                              color: Color(0xFF8B5CF6),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'الرجاء إدخال رقم الغرفة';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Floor Number
                        const Text(
                          'رقم الطابق',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _floorNumberController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'مثال: 1، 2...',
                            hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                            prefixIcon: const Icon(
                              Icons.layers_outlined,
                              color: Color(0xFF8B5CF6),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'الرجاء إدخال رقم الطابق';
                            }
                            final parsed = int.tryParse(val);
                            if (parsed == null || parsed < 0) {
                              return 'الرجاء إدخال رقم طابق صحيح';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Capacity
                        const Text(
                          'السعة الاستيعابية للغرفة (عدد الأسرة)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _capacityController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'مثال: 4، 6...',
                            hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                            prefixIcon: const Icon(
                              Icons.airline_seat_flat_outlined,
                              color: Color(0xFF8B5CF6),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'الرجاء إدخال السعة';
                            }
                            final parsed = int.tryParse(val);
                            if (parsed == null || parsed <= 0) {
                              return 'الرجاء إدخال سعة استيعابية صحيحة';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: widget.isLoading
                                    ? null
                                    : () => Navigator.of(context).pop(),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                                  ),
                                ),
                                child: const Text(
                                  'إلغاء',
                                  style: TextStyle(
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: widget.isLoading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8B5CF6),
                                  disabledBackgroundColor: const Color(0xFF8B5CF6).withValues(alpha: 0.5),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: widget.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        isEdit ? 'حفظ التعديلات' : 'إضافة الغرفة',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
