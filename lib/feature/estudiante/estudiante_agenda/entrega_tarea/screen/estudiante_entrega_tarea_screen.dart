import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../padre_agenda/padre_agenda.dart';
import '../entrega_tarea_viewmodel.dart';

class EstudianteEntregaTareaScreen extends StatefulWidget {
  final PadreAgenda agenda;

  const EstudianteEntregaTareaScreen({
    super.key,
    required this.agenda,
  });

  @override
  State<EstudianteEntregaTareaScreen> createState() =>
      _EstudianteEntregaTareaScreenState();
}

class _EstudianteEntregaTareaScreenState
    extends State<EstudianteEntregaTareaScreen> {
  final _comentarioController = TextEditingController();
  final List<PlatformFile> _archivosSeleccionados = [];

  int get agendaId => widget.agenda.id!;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<EntregaTareaViewModel>().loadEntrega(agendaId);
    });
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarArchivos() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true, // clave: trae los bytes, funciona en web y mobile
    );
    if (result != null) {
      setState(() => _archivosSeleccionados.addAll(result.files));
    }
  }

  Future<void> _entregarTarea() async {
    final vm = context.read<EntregaTareaViewModel>();
    final ok = await vm.entregarTarea(
      agendaId: agendaId,
      comentario: _comentarioController.text.trim().isEmpty
          ? null
          : _comentarioController.text.trim(),
      archivos: _archivosSeleccionados,
    );

    if (!mounted) return;

    if (ok) {
      setState(() => _archivosSeleccionados.clear());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarea entregada correctamente')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.error ?? 'Error al entregar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EntregaTareaViewModel>();
    final agenda = widget.agenda;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(title: Text(agenda.titulo)),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ── Card: info de la tarea ──────────────────
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          agenda.materia,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (agenda.descripcion.isNotEmpty)
                          Text(agenda.descripcion),
                        if (agenda.fechaEntrega != null) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Fecha límite',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(agenda.fechaEntrega!),
                        ],
                        if (agenda.archivos.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Archivos del profesor',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          ...agenda.archivos.map(
                            (archivo) => InkWell(
                              onTap: () async {
                                final uri = Uri.parse(archivo.url);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri,
                                      mode: LaunchMode.externalApplication);
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Text(
                                  archivo.nombreOriginal,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Card: mi entrega ─────────────────────────
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.file_upload_outlined),
                            SizedBox(width: 8),
                            Text(
                              'Mi entrega',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _comentarioController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Escribe un comentario...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: _seleccionarArchivos,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade400,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Column(
                              children: [
                                Icon(Icons.attach_file, color: Colors.grey),
                                SizedBox(height: 6),
                                Text('Arrastra archivos aquí'),
                                Text(
                                  'o haz clic para seleccionarlos',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_archivosSeleccionados.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          ..._archivosSeleccionados.map(
                            (f) => ListTile(
                              dense: true,
                              leading: const Icon(Icons.insert_drive_file),
                              title: Text(f.name),
                              trailing: IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () => setState(
                                  () => _archivosSeleccionados.remove(f),
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: vm.submitting ? null : _entregarTarea,
                            child: vm.submitting
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Text('Entregar tarea'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (vm.entrega != null && vm.entrega!.archivos.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Archivos entregados',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...vm.entrega!.archivos.map(
                    (a) => Card(
                      child: ListTile(
                        leading:
                            const Icon(Icons.attach_file, color: Colors.blue),
                        title: Text(a.nombreOriginal),
                        onTap: () async {
                          final uri = Uri.parse(a.url);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri,
                                mode: LaunchMode.externalApplication);
                          }
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              vm.eliminarArchivo(a.id, agendaId),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}