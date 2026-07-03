import 'package:finalproject/feature/Department_HeadSupervisor/Hospitals/data/hospital_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/data/matching_campaign_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/presentation/manger/matching_campaign_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/specializations/data/specialization_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageSeatsView extends StatefulWidget {
  final MatchingCampaignModel campaign;
  final List<HospitalModel> hospitals;
  final List<SpecializationModel> specializations;

  const ManageSeatsView({
    super.key,
    required this.campaign,
    required this.hospitals,
    required this.specializations,
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
    final isSpecializationOnly = widget.campaign.type == 'Specialization';

    return Scaffold(
      appBar: AppBar(
        title: Text('إدارة المقاعد - ${widget.campaign.title}'),
        backgroundColor: const Color(0xFF0EA5E9),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'إرشادات',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isSpecializationOnly
                        ? 'هذه المفاضلة اختصاص فقط، لذلك يتم إدخال اختصاص واحد فقط في كل صف.'
                        : 'هذه المفاضلة مشافي، ويمكنك إدخال مستشفى فقط أو مستشفى مع اختصاص في نفس الصف.',
                    style: const TextStyle(color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _seats.length,
                itemBuilder: (context, index) {
                  final seat = _seats[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        if (!isSpecializationOnly)
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  initialValue: seat.hospitalId,
                                  decoration: const InputDecoration(
                                    labelText: 'المشفى',
                                  ),
                                  items: widget.hospitals.map((h) {
                                    return DropdownMenuItem<int>(
                                      value: h.id,
                                      child: Text(h.name),
                                    );
                                  }).toList(),
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
                              ),
                              const SizedBox(width: 12),
                            ],
                          ),
                        if (isSpecializationOnly)
                          DropdownButtonFormField<int>(
                            initialValue: seat.specializationId,
                            decoration: const InputDecoration(
                              labelText: 'الاختصاص',
                            ),
                            items: widget.specializations.map((s) {
                              return DropdownMenuItem<int>(
                                value: s.id,
                                child: Text(s.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _seats[index] = MatchingSeatInput(
                                  hospitalId: null,
                                  specializationId: value,
                                  capacity: seat.capacity,
                                );
                              });
                            },
                          )
                        else
                          DropdownButtonFormField<int>(
                            initialValue: seat.specializationId,
                            decoration: const InputDecoration(
                              labelText: 'الاختصاص (اختياري)',
                            ),
                            items:
                                [
                                      {'id': null, 'name': 'بدون اختصاص'},
                                    ]
                                    .map(
                                      (e) => DropdownMenuItem<int>(
                                        value: null as int?,
                                        child: Text(e['name'] as String),
                                      ),
                                    )
                                    .toList()
                                  ..addAll(
                                    widget.specializations.map((s) {
                                      return DropdownMenuItem<int>(
                                        value: s.id,
                                        child: Text(s.name),
                                      );
                                    }),
                                  ),
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
                        const SizedBox(height: 12),
                        TextFormField(
                          initialValue: seat.capacity.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'السعة'),
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
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() => _seats.removeAt(index));
                            },
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('حذف الصف'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(
                        () => _seats.add(
                          MatchingSeatInput(
                            hospitalId: null,
                            specializationId: null,
                            capacity: 1,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('إضافة صف جديد'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveSeats,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_rounded),
                    label: Text(_isSaving ? 'جاري الحفظ...' : 'حفظ المقاعد'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveSeats() async {
    final cubit = context.read<MatchingCampaignCubit>();
    setState(() => _isSaving = true);
    final success = await cubit.createSeats(
      campaignId: widget.campaign.id,
      seats: _seats,
    );
    setState(() => _isSaving = false);
    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }
}
