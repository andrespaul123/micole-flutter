import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../asignacion_viewmodel.dart';
import 'package:go_router/go_router.dart';
class MateriasAsignadasScreen extends StatefulWidget {
  final int profesorId;

  const MateriasAsignadasScreen({
    super.key,
    required this.profesorId,
  });

  @override
  State<MateriasAsignadasScreen> createState() =>
      _MateriasAsignadasScreenState();
}

class _MateriasAsignadasScreenState
    extends State<MateriasAsignadasScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<AsignacionViewModel>()
          .loadAsignacionesProfesor(
            widget.profesorId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AsignacionViewModel>();

    if (vm.loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Materias asignadas',
        ),
      ),
      body: vm.asignacionesProfesor.isEmpty
          ? const Center(
              child: Text(
                'No tiene materias asignadas',
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount:
                  vm.asignacionesProfesor.length,
              itemBuilder: (_, index) {
                final a =
                    vm.asignacionesProfesor[index];

                return Card(
                  margin: const EdgeInsets.only(
                    bottom: 16,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.materia,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Profesor: ${a.profesor}",
                        ),

                        Text(
                          "Curso: ${a.curso}",
                        ),

                        Text(
                          "Paralelo: ${a.paralelo}",
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          "Horarios",
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        ...a.horarios.map(
                          (h) => ListTile(
                            dense: true,
                            leading:
                                const Icon(Icons.schedule),
                            title: Text(h.dia),
                            subtitle: Text(
                              "${h.horaInicio.substring(0, 5)} - ${h.horaFin.substring(0, 5)}",
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                               context.go(
        '/profesores/${widget.profesorId}/materias-asignadas/${a.id}/agregar-horario',
      );
                            },
                            icon:
                                const Icon(Icons.add),
                            label: const Text(
                              "Agregar horario",
                            ),
                          ),
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