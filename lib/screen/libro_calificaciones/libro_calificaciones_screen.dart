import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/libro_calificaciones_viewmodel.dart';

class LibroCalificacionesScreen extends StatefulWidget {
  final int asignacionId;

  const LibroCalificacionesScreen({
    super.key,
    required this.asignacionId,
  });

  @override
  State<LibroCalificacionesScreen> createState() =>
      _LibroCalificacionesScreenState();
}

class _LibroCalificacionesScreenState
    extends State<LibroCalificacionesScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<LibroCalificacionesViewModel>()
          .loadPeriodos(
            widget.asignacionId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {

    final vm =
        context.watch<LibroCalificacionesViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Libro de Calificaciones",
        ),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: vm.saving
            ? null
            : () async {

                await vm.guardarNotas(
                widget.asignacionId,);

                if (!mounted) return;

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content: Text(
                      vm.error ??
                          "Notas guardadas correctamente",
                    ),
                  ),
                );
              },
        icon: const Icon(Icons.save),
        label: const Text("Guardar"),
      ),

      body: vm.loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : vm.error != null
              ? Center(
                  child: Text(vm.error!),
                )
              : Column(
                  children: [

                    Padding(
                      padding:
                          const EdgeInsets.all(
                        16,
                      ),

                      child:
                          DropdownButtonFormField(
                        value:
                            vm.periodoSeleccionado,

                        decoration:
                            const InputDecoration(
                          labelText:
                              "Periodo de evaluación",
                          border:
                              OutlineInputBorder(),
                        ),

                        items: vm
                            .periodosEvaluacion
                            .map(
                              (p) =>
                                  DropdownMenuItem(
                                value: p,
                                child: Text(
                                  p.nombre ?? "",
                                ),
                              ),
                            )
                            .toList(),

                        onChanged: (value) {

                          if (value == null) {
                            return;
                          }

                          vm.seleccionarPeriodo(
                            widget.asignacionId,
                            value,
                          );
                        },
                      ),
                    ),

                    Expanded(
                      child:
                          SingleChildScrollView(
                        scrollDirection:
                            Axis.horizontal,

                        child:
                            SingleChildScrollView(

                          child: DataTable(

                            columns: [

                              const DataColumn(
                                label: Text(
                                  "Estudiante",
                                ),
                              ),

                              ...vm.criterios.map(
                                (c) =>
                                    DataColumn(
                                  label: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                    children: [

                                      Text(
                                        c.nombre,
                                      ),

                                      Text(
                                        "${c.porcentaje.toStringAsFixed(0)}%",
                                        style:
                                            const TextStyle(
                                          fontSize:
                                              12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const DataColumn(
                                label: Text(
                                  "Promedio",
                                ),
                              ),
                            ],

                            rows: vm.estudiantes.map(
                              (estudiante) {

                                return DataRow(

                                  cells: [

                                    DataCell(

                                      SizedBox(
                                        width: 180,

                                        child: Text(
                                          estudiante.estudiante,
                                        ),
                                      ),
                                    ),

                                    ...vm.criterios.map(
                                      (criterio) {

                                        final nota =
                                            estudiante.notas.firstWhere(
                                          (n) =>
                                              n.criterioId ==
                                              criterio.id,
                                        );

                                        return DataCell(

                                          SizedBox(

                                            width: 80,

                                            child:
                                                TextFormField(

                                              initialValue:
                                                  nota.nota.toString(),

                                              keyboardType:
                                                  TextInputType.number,

                                              onChanged:
                                                  (value) {

                                                vm.actualizarNota(

                                                  estudianteId:
                                                      estudiante.estudianteId,

                                                  criterioId:
                                                      criterio.id,

                                                  nota:
                                                      double.tryParse(
                                                            value,
                                                          ) ??
                                                          0,
                                                );
                                              },

                                            ),
                                          ),
                                        );
                                      },
                                    ),

                                    DataCell(

                                      Text(
                                        estudiante.promedio
                                            .toStringAsFixed(
                                          2,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}