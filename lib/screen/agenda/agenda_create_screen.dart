import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/agenda_viewmodel.dart';

class AgendaCreateScreen extends StatefulWidget {
  final int periodoId;
  final int cursoId;
  final int paraleloId;
  final int asignacionId;

  const AgendaCreateScreen({
    super.key,
    required this.periodoId,
    required this.cursoId,
    required this.paraleloId,
    required this.asignacionId,
  });

  @override
  State<AgendaCreateScreen> createState() =>
      _AgendaCreateScreenState();
}

class _AgendaCreateScreenState
    extends State<AgendaCreateScreen> {

  final _formKey = GlobalKey<FormState>();

  final tituloCtrl = TextEditingController();
  final descripcionCtrl = TextEditingController();
  final fechaCtrl = TextEditingController();

  String tipo = 'tarea';

  @override
  void dispose() {
    tituloCtrl.dispose();
    descripcionCtrl.dispose();
    fechaCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AgendaViewModel>();

    return Scaffold(

      // 🔥 quita flecha atrás
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Crear Agenda',
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              TextFormField(
                controller: tituloCtrl,

                decoration: const InputDecoration(
                  labelText: 'Título',
                ),

                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Campo requerido';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: tipo,

                decoration: const InputDecoration(
                  labelText: 'Tipo',
                ),

                items: const [
                  DropdownMenuItem(
                    value: 'tarea',
                    child: Text('Tarea'),
                  ),

                  DropdownMenuItem(
                    value: 'examen',
                    child: Text('Examen'),
                  ),

                  DropdownMenuItem(
                    value: 'recurso',
                    child: Text('Recurso'),
                  ),
                ],

                onChanged: (v) {
                  setState(() {
                    tipo = v!;
                  });
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: descripcionCtrl,
                maxLines: 5,

                decoration: const InputDecoration(
                  labelText: 'Descripción',
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: fechaCtrl,
                readOnly: true,

                decoration: const InputDecoration(
                  labelText: 'Fecha de entrega',
                  hintText: 'YYYY-MM-DD',
                  suffixIcon: Icon(
                    Icons.calendar_today,
                  ),
                ),

                onTap: () async {

                  final date =
                      await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );

                  if (date != null) {
                    fechaCtrl.text =
                        date
                            .toString()
                            .split(' ')
                            .first;
                  }
                },
              ),

              if (vm.error != null) ...[
                const SizedBox(height: 10),

                Text(
                  vm.error!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed:
                      vm.creating
                          ? null
                          : () async {

                              if (!_formKey.currentState!
                                  .validate()) {
                                return;
                              }

                              FocusScope.of(context)
                                  .unfocus();

                              final ok =
                                  await vm.crearAgenda(
                                periodoId:
                                    widget.periodoId,

                                asignacionId:
                                    widget.asignacionId,

                                titulo:
                                    tituloCtrl.text
                                        .trim(),

                                descripcion:
                                    descripcionCtrl.text
                                        .trim(),

                                tipo: tipo,

                                fechaEntrega:
                                    fechaCtrl
                                            .text
                                            .isEmpty
                                        ? null
                                        : fechaCtrl.text,
                              );

                              if (!mounted) return;

                              if (ok) {

                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Agenda creada correctamente',
                                    ),
                                  ),
                                );

                                // 🔥 recarga lista
                                context.go(
                                  '/mis-clases/${widget.periodoId}/${widget.cursoId}/${widget.paraleloId}/${widget.asignacionId}/agendas',
                                );
                              }
                            },

                  child:
                      vm.creating
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Guardar',
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}