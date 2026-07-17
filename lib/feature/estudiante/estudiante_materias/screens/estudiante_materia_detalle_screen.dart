import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../estudiante_materia_viewmodel.dart';

class EstudianteMateriaDetalleScreen extends StatefulWidget {
  final int asignacionId;

  const EstudianteMateriaDetalleScreen({
    super.key,
    required this.asignacionId,
  });

  @override
  State<EstudianteMateriaDetalleScreen> createState() =>
      _EstudianteMateriaDetalleScreenState();
}

class _EstudianteMateriaDetalleScreenState
    extends State<EstudianteMateriaDetalleScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<EstudianteMateriaViewModel>()
          .loadDetalleMateria(
            widget.asignacionId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {

    final vm =
        context.watch<EstudianteMateriaViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Materia',
        ),
      ),

      body: Builder(
        builder: (_) {

          if (vm.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (vm.error != null) {
            return Center(
              child: Text(vm.error!),
            );
          }

          if (vm.detalleMateria == null) {
            return const Center(
              child: Text(
                'No existe información',
              ),
            );
          }

          final materia = vm.detalleMateria!;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        materia.materia,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Profesor: ${materia.profesor}",
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      const Divider(
                        height: 30,
                      ),

                      const Text(
                        "Horario",
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 10),

                      ...materia.horarios.map(
                        (h) => Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 8,
                          ),
                          child: Row(
                            children: [

                              const Icon(
                                Icons.schedule,
                                size: 18,
                                color: Colors.indigo,
                              ),

                              const SizedBox(
                                width: 8,
                              ),

                              Expanded(
                                child: Text(
                                  "${h.dia}  ${h.horaInicio.substring(0,5)} - ${h.horaFin.substring(0,5)}",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.library_books,
                  ),
                  label: const Text(
                    "Biblioteca",
                  ),
                  onPressed: () {

                    context.go(
                      '/estudiante/materias/${widget.asignacionId}/biblioteca',
                    );

                  },
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.assignment,
                  ),
                  label: const Text(
                    "Tareas",
                  ),
                  onPressed: () {

                    context.go(
                      '/estudiante/materias/${widget.asignacionId}/pendientes',
                    );

                  },
                ),
              ),
              const SizedBox(height: 15),

                SizedBox(
                  height: 55,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.quiz),
                    label: const Text("Exámenes"),
                    onPressed: () {

                      context.go(
                        '/estudiante/materias/${widget.asignacionId}/examenes',
                      );

                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}