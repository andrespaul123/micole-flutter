import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../paralelo_viewmodel.dart';
import '../../periodo_academico/academic_period_viewmodel.dart';

class ParaleloListScreen extends StatefulWidget {
  final int cursoId;

  const ParaleloListScreen({super.key, required this.cursoId});

  @override
  State<ParaleloListScreen> createState() => _ParaleloListScreenState();
}

class _ParaleloListScreenState extends State<ParaleloListScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final periodoVM = context.read<AcademicPeriodViewModel>();

      //  Esperar periodo (CLAVE en web)
      if (periodoVM.periodoActivo == null) {
        await periodoVM.loadPeriodoActivo();
      }

      final periodoId = periodoVM.periodoActivo?.id;

      if (periodoId != null) {
        await context.read<ParaleloViewModel>().loadParalelosByCurso(
          periodoId,
          widget.cursoId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ParaleloViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Paralelos'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4F46E5),
        onPressed: () {
          context.go('/cursos/${widget.cursoId}/paralelos/create');
        },
        child: const Icon(Icons.add),
      ),

      body: vm.loading && vm.paralelos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : vm.error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 40,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          vm.error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : vm.paralelos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.groups_outlined,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No hay paralelos',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: vm.paralelos.length,
                      itemBuilder: (_, i) {
                        final p = vm.paralelos[i];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEEF2FF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.groups_rounded,
                                    color: Color(0xFF4F46E5),
                                    size: 22,
                                  ),
                                ),

                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Paralelo ${p.nombre}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (p.turno != null &&
                                          p.turno!.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.schedule,
                                              size: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              p.turno!,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),

                                IconButton(
                                  tooltip: 'Ver horario',
                                  icon: const Icon(
                                    Icons.calendar_view_week_rounded,
                                    color: Color(0xFF4F46E5),
                                  ),
                                  onPressed: () {
                                    context.go(
                                      '/cursos/${widget.cursoId}/paralelos/${p.id}/horario',
                                    );
                                  },
                                ),

                                // ELIMINAR
                                IconButton(
                                  tooltip: 'Eliminar',
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    await vm.deleteParalelo(p.id!);

                                    final periodoVM = context
                                        .read<AcademicPeriodViewModel>();

                                    final periodoId =
                                        periodoVM.periodoActivo?.id;

                                    if (periodoId != null) {
                                      await vm.loadParalelosByCurso(
                                        periodoId,
                                        widget.cursoId,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}