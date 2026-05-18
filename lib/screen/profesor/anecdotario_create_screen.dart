import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/estudiante_clase.dart';
import '../../viewmodels/anecdotario_viewmodel.dart';
import '../../viewmodels/estudiantes_clase_viewmodel.dart';

class AnecdotarioCreateScreen extends StatefulWidget {
  final int periodoId;
  final int cursoId;
  final int paraleloId;
  final int asignacionId;

  const AnecdotarioCreateScreen({
    super.key,
    required this.periodoId,
    required this.cursoId,
    required this.paraleloId,
    required this.asignacionId,
  });

  @override
  State<AnecdotarioCreateScreen> createState() =>
      _AnecdotarioCreateScreenState();
}

class _AnecdotarioCreateScreenState
    extends State<AnecdotarioCreateScreen> {
  final tituloCtrl = TextEditingController();
  final descripcionCtrl = TextEditingController();

  EstudianteClase? estudiante;

  String tipo = 'conducta';

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<EstudiantesClaseViewModel>().load(
            periodoId: widget.periodoId,
            cursoId: widget.cursoId,
            paraleloId: widget.paraleloId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final estudiantesVM =
        context.watch<EstudiantesClaseViewModel>();

    final vm = context.watch<AnecdotarioViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Anecdotario'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<EstudianteClase>(
              value: estudiante,
              hint: const Text('Seleccione estudiante'),
              items: estudiantesVM.estudiantes.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e.nombre ?? ''),
                );
              }).toList(),
              onChanged: (e) {
                setState(() {
                  estudiante = e;
                });
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: tipo,
              items: const [
                DropdownMenuItem(
                  value: 'conducta',
                  child: Text('Conducta'),
                ),
                DropdownMenuItem(
                  value: 'merito',
                  child: Text('Mérito'),
                ),
                DropdownMenuItem(
                  value: 'observacion',
                  child: Text('Observación'),
                ),
              ],
              onChanged: (v) {
                setState(() {
                  tipo = v!;
                });
              },
            ),

            const SizedBox(height: 16),

            TextField(
              controller: tituloCtrl,
              decoration: const InputDecoration(
                labelText: 'Título',
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: descripcionCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Descripción',
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: vm.creating
                    ? null
                    : () async {
                        if (estudiante == null) return;

                        final ok = await vm.createAnecdotario(
                          estudianteId: estudiante!.id!,
                          asignacionDocenteId:
                              widget.asignacionId,
                          academicPeriodId:
                              widget.periodoId,
                          tipo: tipo,
                          titulo: tituloCtrl.text,
                          descripcion:
                              descripcionCtrl.text,
                          fecha: DateTime.now()
                              .toString()
                              .split(' ')
                              .first,
                        );

                        if (ok && mounted) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Anecdotario registrado',
                              ),
                            ),
                          );

                          Navigator.pop(context);
                        }
                      },
                child: vm.creating
                    ? const CircularProgressIndicator()
                    : const Text('Guardar Anecdotario'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}