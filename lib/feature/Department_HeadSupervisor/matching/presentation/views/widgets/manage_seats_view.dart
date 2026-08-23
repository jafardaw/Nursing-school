import 'package:finalproject/feature/Department_HeadSupervisor/Hospitals/data/hospital_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/data/matching_campaign_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/presentation/manger/matching_campaign_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/specializations/data/specialization_model.dart';
import 'package:flutter/material.dart';

class ManageSeatsView extends StatefulWidget {
  final MatchingCampaignModel campaign;
  final List<HospitalModel> hospitals;
  final List<SpecializationModel> specializations;
  final MatchingCampaignCubit cubit;

  const ManageSeatsView({
    super.key,
    required this.campaign,
    required this.hospitals,
    required this.specializations,
    required this.cubit,
  });

  @override
  State<ManageSeatsView> createState() => _ManageSeatsViewState();
}

class _ManageSeatsViewState extends State<ManageSeatsView> {
  final List<MatchingSeatInput> _seats = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _seats.add(
      MatchingSeatInput(hospitalId: null, specializationId: null, capacity: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final campaignType = widget.campaign.type;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'إضافة مقاعد - ${widget.campaign.title}',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 17,
            color: Color(0xFF1E293B),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildInfoCard(campaignType),
                const SizedBox(height: 24),
                ..._seats.asMap().entries.map((entry) {
                  return _buildSeatCard(
                    entry.key,
                    entry.value,
                    campaignType,
                  );
                }),
                const SizedBox(height: 12),
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _seats.add(
                          MatchingSeatInput(
                            hospitalId: null,
                            specializationId: null,
                            capacity: 1,
                          ),
                        );
                      });
                    },
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Color(0xFF2563EB),
                    ),
                    label: const Text(
                      'إضافة صف جديد',
                      style: TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      backgroundColor: const Color(0xFFEFF6FF),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String campaignType) {
    String infoText;
    switch (campaignType) {
      case 'Specialization':
        infoText =
            'هذه المفاضلة مخصصة للاختصاصات فقط. يرجى تحديد الاختصاص والسعة المطلوبة في كل صف لتوزيعها بشكل صحيح.';
        break;
      case 'General_Hospital':
        infoText =
            'هذه المفاضلة مخصصة للمشافي العامة. يرجى تحديد المشفى والسعة المطلوبة في كل صف. لا حاجة لتحديد اختصاص.';
        break;
      case 'Specialized_Hospital':
        infoText =
            'هذه المفاضلة مخصصة للمشافي المتخصصة. يرجى تحديد المشفى والاختصاص والسعة المطلوبة في كل صف.';
        break;
      default:
        infoText = 'يرجى تعبئة بيانات المقاعد أدناه.';
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: Color(0xFF2563EB),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'إرشادات الإدخال',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  infoText,
                  style: const TextStyle(
                    color: Color(0xFF1D4ED8),
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatCard(
    int index,
    MatchingSeatInput seat,
    String campaignType,
  ) {
    final showHospital = campaignType == 'General_Hospital' ||
        campaignType == 'Specialized_Hospital';
    final showSpecialization = campaignType == 'Specialization' ||
        campaignType == 'Specialized_Hospital';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF64748B),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'تفاصيل المقعد',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF334155),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              if (_seats.length > 1)
                InkWell(
                  onTap: () {
                    setState(() => _seats.removeAt(index));
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          color: Color(0xFFEF4444),
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'حذف',
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          // ──── Hospital dropdown (General_Hospital & Specialized_Hospital) ────
          if (showHospital) ...[
            _buildDropdown<int>(
              label: 'المشفى',
              icon: Icons.local_hospital_rounded,
              value: seat.hospitalId,
              items: widget.hospitals
                  .map(
                    (h) => DropdownMenuItem(value: h.id, child: Text(h.name)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _seats[index] = MatchingSeatInput(
                    hospitalId: value,
                    specializationId: seat.specializationId,
                    capacity: seat.capacity,
                  );
                });
              },
            ),
            const SizedBox(height: 16),
          ],
          // ──── Specialization dropdown (Specialization & Specialized_Hospital) ────
          if (showSpecialization)
            _buildDropdown<int>(
              label: 'الاختصاص',
              icon: Icons.school_rounded,
              value: seat.specializationId,
              items: widget.specializations
                  .map(
                    (s) => DropdownMenuItem(value: s.id, child: Text(s.name)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _seats[index] = MatchingSeatInput(
                    hospitalId: seat.hospitalId,
                    specializationId: value,
                    capacity: seat.capacity,
                  );
                });
              },
            ),
          if (showSpecialization) const SizedBox(height: 16),
          _buildNumberField(
            label: 'السعة المطلوبة',
            icon: Icons.people_alt_rounded,
            initialValue: seat.capacity.toString(),
            onChanged: (value) {
              setState(() {
                _seats[index] = MatchingSeatInput(
                  hospitalId: seat.hospitalId,
                  specializationId: seat.specializationId,
                  capacity: int.tryParse(value) ?? 0,
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFF64748B),
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 22),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      icon: const Icon(Icons.expand_more_rounded, color: Color(0xFF94A3B8)),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(14),
      items: items,
      onChanged: onChanged,
    );
  }

  Widget _buildNumberField({
    required String label,
    required IconData icon,
    required String initialValue,
    required void Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: TextInputType.number,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 15,
        color: Color(0xFF1E293B),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFF64748B),
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 22),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  foregroundColor: const Color(0xFF475569),
                ),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveSeats,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  disabledBackgroundColor: const Color(0xFF93C5FD),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save_rounded, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'حفظ المقاعد',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveSeats() async {
    setState(() => _isSaving = true);
    final success = await widget.cubit.createSeats(
      campaignId: widget.campaign.id,
      seats: _seats,
    );
    setState(() => _isSaving = false);
    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }
}
