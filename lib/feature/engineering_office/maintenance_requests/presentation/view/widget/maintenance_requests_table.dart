import 'package:data_table_2/data_table_2.dart';
import 'package:finalproject/core/widgets/empty_view_list.dart';
import 'package:finalproject/feature/engineering_office/maintenance_requests/data/model/maintenance_request_model.dart';
import 'package:finalproject/feature/engineering_office/maintenance_requests/presentation/view/widget/maintenance_status_badge.dart';
import 'package:flutter/material.dart';

class MaintenanceRequestsTable extends StatelessWidget {
  final List<MaintenanceRequestModel> requests;
  final ValueChanged<MaintenanceRequestModel> onOpenDetails;

  const MaintenanceRequestsTable({
    super.key,
    required this.requests,
    required this.onOpenDetails,
  });

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return const SizedBox(
        height: 360,
        child: EmptyListViews(
          text: 'لا توجد طلبات صيانة مطابقة للفلاتر الحالية',
          iconData: Icons.home_repair_service_outlined,
        ),
      );
    }

    return SizedBox(
      height: 520,
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 980,
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
          DataColumn2(label: Text('الطلب'), size: ColumnSize.S),
          DataColumn2(label: Text('الوصف'), size: ColumnSize.L),
          DataColumn2(label: Text('الشكوى'), size: ColumnSize.M),
          DataColumn2(label: Text('المواد'), size: ColumnSize.S),
          DataColumn2(label: Text('الحالة'), size: ColumnSize.S),
          DataColumn2(label: Text('تاريخ الطلب'), size: ColumnSize.S),
          DataColumn2(label: Text('تفاصيل'), size: ColumnSize.S),
        ],
        rows: requests.map(_buildRow).toList(),
      ),
    );
  }

  DataRow _buildRow(MaintenanceRequestModel request) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            '#${request.id}',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        DataCell(
          Tooltip(
            message: request.description,
            child: Text(
              request.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(Text(request.housingComplaint?.type ?? '-')),
        DataCell(Text('${request.itemsCount}')),
        DataCell(MaintenanceStatusBadge(status: request.status)),
        DataCell(
          Text(
            _formatDate(request.dateSubmitted),
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ),
        DataCell(
          IconButton(
            tooltip: 'عرض التفاصيل',
            onPressed: () => onOpenDetails(request),
            icon: const Icon(
              Icons.visibility_outlined,
              color: Color(0xFF0D47A1),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(String date) {
    try {
      final d = DateTime.parse(date);
      return '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return date;
    }
  }
}
