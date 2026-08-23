import 'package:data_table_2/data_table_2.dart';
import 'package:finalproject/core/widgets/empty_view_list.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/data/model/warehouse_complaint_model.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/presentation/view/widget/warehouse_complaint_status_badge.dart';
import 'package:flutter/material.dart';

class WarehouseComplaintsTable extends StatelessWidget {
  final List<WarehouseComplaintModel> complaints;
  final int? approvingComplaintId;
  final bool isActionable;
  final ValueChanged<WarehouseComplaintModel> onApprove;
  final ValueChanged<WarehouseComplaintModel> onOpenDetails;
  final ValueChanged<WarehouseComplaintModel>? onCreateMaintenanceRequest;

  const WarehouseComplaintsTable({
    super.key,
    required this.complaints,
    required this.approvingComplaintId,
    this.isActionable = true,
    required this.onApprove,
    required this.onOpenDetails,
    this.onCreateMaintenanceRequest,
  });

  @override
  Widget build(BuildContext context) {
    if (complaints.isEmpty) {
      return const SizedBox(
        height: 360,
        child: EmptyListViews(
          text: 'لا توجد شكاوى مطابقة للفلاتر الحالية',
          iconData: Icons.inventory_2_outlined,
        ),
      );
    }

    return SizedBox(
      height: 520,
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 1250,
        headingRowHeight: 56,
        headingTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF5E6278),
          fontSize: 13,
        ),
        headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
        dataTextStyle: const TextStyle(color: Color(0xFF3F4254), fontSize: 13),
        dividerThickness: 0.5,
        columns: const [
          DataColumn2(label: Text('الشكوى'), fixedWidth: 75),
          DataColumn2(label: Text('النوع'), fixedWidth: 110),
          DataColumn2(label: Text('الوصف'), size: ColumnSize.L),
          DataColumn2(label: Text('الغرفة'), fixedWidth: 85),
          DataColumn2(label: Text('المبنى'), fixedWidth: 130),
          DataColumn2(label: Text('الحالة'), fixedWidth: 120),
          DataColumn2(label: Text('إجراءات'), fixedWidth: 300),
        ],
        rows: complaints.map(_buildRow).toList(),
      ),
    );
  }

  DataRow _buildRow(WarehouseComplaintModel complaint) {
    final isLoading = approvingComplaintId == complaint.id;

    return DataRow(
      cells: [
        DataCell(
          Text(
            '#${complaint.id}',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        DataCell(Text(complaint.type)),
        DataCell(
          Tooltip(
            message: complaint.description,
            child: Text(
              complaint.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(Text(complaint.room?.roomNumber ?? '-')),
        DataCell(Text(complaint.room?.building?.name ?? '-')),
        DataCell(WarehouseComplaintStatusBadge(status: complaint.status)),
        DataCell(
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                IconButton(
                  tooltip: 'عرض التفاصيل',
                  onPressed: () => onOpenDetails(complaint),
                  icon: const Icon(
                    Icons.visibility_outlined,
                    color: Color(0xFF0D47A1),
                  ),
                ),
                if (isActionable && onCreateMaintenanceRequest != null) ...[
                  const SizedBox(width: 6),
                  OutlinedButton.icon(
                    onPressed: () => onCreateMaintenanceRequest!(complaint),
                    icon: const Icon(
                      Icons.home_repair_service_outlined,
                      size: 15,
                    ),
                    label: const Text('طلب صيانة'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0D47A1),
                      side: const BorderSide(color: Color(0xFF0D47A1)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 6),
                if (isActionable)
                  ElevatedButton.icon(
                    onPressed: isLoading || complaint.isResolved
                        ? null
                        : () => onApprove(complaint),
                    icon: isLoading
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check_circle_outline, size: 16),
                    label: Text(complaint.isResolved ? 'منجزة' : 'اعتماد'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF50CD89),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFE4E6EF),
                      disabledForegroundColor: const Color(0xFF7E8299),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.visibility_rounded,
                          size: 14,
                          color: Color(0xFF64748B),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'معاينة فقط',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
