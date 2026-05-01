import 'dart:ui';

import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/feature/specializations/data/specialization_model.dart';
import 'package:finalproject/feature/specializations/presentation/manger/get_cubit/get_specialization_cubit.dart';
import 'package:finalproject/feature/specializations/presentation/manger/get_cubit/get_specialization_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpecializationsView extends StatefulWidget {
  const SpecializationsView({super.key});

  @override
  State<SpecializationsView> createState() => _SpecializationsViewState();
}

class _SpecializationsViewState extends State<SpecializationsView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<GetSpecializationsCubit>()..fetchSpecializations(),
      child: Scaffold(
        backgroundColor: const Color(0xffEEF2FF),
        body: Stack(
          children: [
            /// الخلفية الجمالية
            Positioned(
              top: -120,
              left: -80,
              child: _glowCircle(
                color: Colors.blue.withOpacity(0.18),
                size: 320,
              ),
            ),

            Positioned(
              bottom: -140,
              right: -100,
              child: _glowCircle(
                color: Colors.purple.withOpacity(0.18),
                size: 380,
              ),
            ),

            BlocBuilder<GetSpecializationsCubit, GetSpecializationsState>(
              builder: (context, state) {
                if (state is GetSpecializationsSuccess) {
                  return Column(
                    children: [
                      /// الهيدر
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 24,
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 20),

                            // const Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Text(
                            //       "Medical Specializations",
                            //       style: TextStyle(
                            //         fontSize: 32,
                            //         fontWeight: FontWeight.w900,
                            //         color: Color(0xff1A1D3A),
                            //       ),
                            //     ),
                            //     SizedBox(height: 6),
                            //     Text(
                            //       "Manage all specializations beautifully",
                            //       style: TextStyle(
                            //         fontSize: 15,
                            //         color: Colors.black54,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            const Spacer(),
                          ],
                        ),
                      ),

                      /// الشبكة
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 10,
                          ),
                          itemCount: state.specializations.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 24,
                                mainAxisSpacing: 24,
                                childAspectRatio: 1.05,
                              ),
                          itemBuilder: (context, index) {
                            return SpecializationCard(
                              model: state.specializations[index],
                              index: index,
                            );
                          },
                        ),
                      ),

                      _buildPaginationControls(context, state),
                    ],
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls(
    BuildContext context,
    GetSpecializationsSuccess state,
  ) {
    final cubit = context.read<GetSpecializationsCubit>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 30, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _paginationButton(
            icon: Icons.chevron_left,
            enabled: cubit.currentPage > 1,
            onTap: () {
              cubit.fetchSpecializations(page: cubit.currentPage - 1);
            },
          ),

          const SizedBox(width: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff5B67F1), Color(0xff7A54FF)],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Text(
              "Page ${cubit.currentPage}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(width: 16),

          _paginationButton(
            icon: Icons.chevron_right,
            enabled: (cubit.currentPage * 15) < state.total,
            onTap: () {
              cubit.fetchSpecializations(page: cubit.currentPage + 1);
            },
          ),
        ],
      ),
    );
  }

  Widget _paginationButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: enabled ? Colors.white : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(18),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Icon(icon, color: enabled ? Colors.black87 : Colors.grey),
      ),
    );
  }

  Widget _glowCircle({required Color color, required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
        child: const SizedBox(),
      ),
    );
  }
}

class SpecializationCard extends StatefulWidget {
  final SpecializationModel model;
  final int index;

  const SpecializationCard({
    super.key,
    required this.model,
    required this.index,
  });

  @override
  State<SpecializationCard> createState() => _SpecializationCardState();
}

class _SpecializationCardState extends State<SpecializationCard> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.identity()
          ..translate(0.0, isHovering ? -12 : 0.0)
          ..scale(isHovering ? 1.03 : 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isHovering
                ? [const Color(0xff5B67F1), const Color(0xff7A54FF)]
                : [
                    Colors.white.withOpacity(0.92),
                    Colors.white.withOpacity(0.82),
                  ],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: isHovering
                  ? Colors.blue.withOpacity(0.25)
                  : Colors.black.withOpacity(0.06),
              blurRadius: isHovering ? 35 : 15,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// أعلى الكارد
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isHovering
                          ? Colors.white.withOpacity(0.18)
                          : const Color(0xffEEF2FF),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Icon(
                      Icons.medical_services_rounded,
                      size: 34,
                      color: isHovering
                          ? Colors.white
                          : const Color(0xff5B67F1),
                    ),
                  ),

                  const Spacer(),

                  /// الاسم
                  Text(
                    widget.model.name,
                    maxLines: 2,
                    style: TextStyle(
                      height: 1.3,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: isHovering
                          ? Colors.white
                          : const Color(0xff1A1D3A),
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// السنوات
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 18,
                        color: isHovering
                            ? Colors.white70
                            : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${widget.model.durationYears} Years",
                        style: TextStyle(
                          fontSize: 14,
                          color: isHovering
                              ? Colors.white70
                              : Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
