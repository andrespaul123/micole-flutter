import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../estudiante_materia_viewmodel.dart';

class EstudianteMateriasScreen extends StatefulWidget {
  const EstudianteMateriasScreen({
    super.key,
  });

  @override
  State<EstudianteMateriasScreen> createState() =>
      _EstudianteMateriasScreenState();
}

class _EstudianteMateriasScreenState
    extends State<EstudianteMateriasScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<EstudianteMateriaViewModel>()
          .loadMaterias();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm =
        context.watch<EstudianteMateriaViewModel>();

    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F7FB,
      ),
      appBar: AppBar(
        title: const Text(
          'Mis Materias',
        ),
      ),
      body: Builder(
        builder: (_) {
          if (vm.loading) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (vm.error != null) {
            return Center(
              child: Text(vm.error!),
            );
          }

          if (vm.materias.isEmpty) {
            return const Center(
              child: Text(
                'No tienes materias asignadas',
              ),
            );
          }

          return LayoutBuilder(
            builder: (
              context,
              constraints,
            ) {
              int columns = 2;

              if (constraints.maxWidth >
                  1200) {
                columns = 4;
              } else if (constraints
                      .maxWidth >
                  800) {
                columns = 3;
              }

              return GridView.builder(
                padding:
                    const EdgeInsets.all(
                  16,
                ),
                itemCount:
                    vm.materias.length,
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      columns,
                  crossAxisSpacing:
                      12,
                  mainAxisSpacing:
                      12,
                  childAspectRatio:
                      1.4,
                ),
                itemBuilder:
                    (_, index) {
                  final materia =
                      vm.materias[index];

                  return Card(
                    elevation: 2,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),
                    child: InkWell(
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                      onTap: () {
                         context.go(
                          '/estudiante/materias/${materia.asignacionId}',
                        );
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.all(
                          16,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration:
                                  BoxDecoration(
                                color:
                                    const Color(
                                  0xFFEEF2FF,
                                ),
                                borderRadius:
                                    BorderRadius.circular(
                                  12,
                                ),
                              ),
                              child:
                                  const Icon(
                                Icons
                                    .menu_book,
                                color:
                                    Color(
                                  0xFF4F46E5,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            Text(
                              materia
                                  .materia,
                              maxLines:
                                  2,
                              overflow:
                                  TextOverflow
                                      .ellipsis,
                              style:
                                  const TextStyle(
                                fontSize:
                                    16,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            Row(
                              children: [
                                const Icon(
                                  Icons
                                      .person,
                                  size:
                                      16,
                                  color:
                                      Colors.grey,
                                ),
                                const SizedBox(
                                  width:
                                      4,
                                ),
                                Expanded(
                                  child:
                                      Text(
                                    materia
                                        .profesor,
                                    maxLines:
                                        1,
                                    overflow:
                                        TextOverflow.ellipsis,
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.grey,
                                      fontSize:
                                          13,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Spacer(),

                            const Row(
                              children: [
                                Text(
                                  'Ver materia',
                                  style:
                                      TextStyle(
                                    color:
                                        Color(
                                      0xFF4F46E5,
                                    ),
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      4,
                                ),
                                Icon(
                                  Icons
                                      .arrow_forward,
                                  size:
                                      16,
                                  color:
                                      Color(
                                    0xFF4F46E5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}