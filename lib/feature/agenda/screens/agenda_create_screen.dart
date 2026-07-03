import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../agenda_viewmodel.dart';
import '../../../core/widgest/auth_card.dart';

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
  State<AgendaCreateScreen> createState() => _AgendaCreateScreenState();
}

class _AgendaCreateScreenState extends State<AgendaCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final tituloCtrl = TextEditingController();
  final descripcionCtrl = TextEditingController();
  final fechaCtrl = TextEditingController();

  String tipo = 'tarea';
  List<PlatformFile> archivos = [];

  @override
  void dispose() {
    tituloCtrl.dispose();
    descripcionCtrl.dispose();
    fechaCtrl.dispose();
    super.dispose();
  }

  Future<void> seleccionarArchivos() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true, withData: true);
    if (result == null) return;
    setState(() => archivos = result.files);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AgendaViewModel>();
    final esRecurso = tipo == 'recurso';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(title: const Text('Crear Agenda')),
      body: AuthCard(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              const Icon(Icons.edit_calendar, size: 48, color: Colors.deepPurple),
              const SizedBox(height: 8),
              const Text(
                'Nueva Agenda',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Título
              const Text('Título', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextFormField(
                controller: tituloCtrl,
                decoration: InputDecoration(
                  hintText: 'Ej: Tarea de matemáticas',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),

              // Tipo
              const Text('Tipo', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: tipo,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                items: const [
                  DropdownMenuItem(value: 'tarea',   child: Text('Tarea')),
                  DropdownMenuItem(value: 'examen',  child: Text('Examen')),
                  DropdownMenuItem(value: 'recurso', child: Text('Recurso')),
                ],
                onChanged: (v) => setState(() {
                  tipo = v!;
                  if (tipo == 'recurso') fechaCtrl.clear();
                }),
              ),
              const SizedBox(height: 16),

              // Fecha — solo si no es recurso
              if (!esRecurso) ...[
                const Text('Fecha de entrega', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: fechaCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'YYYY-MM-DD',
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      fechaCtrl.text = date.toString().split(' ').first;
                    }
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Descripción
              const Text('Descripción', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                controller: descripcionCtrl,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Describe la actividad...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 16),

              // Archivos
              const Text('Archivos adjuntos', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: seleccionarArchivos,
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Seleccionar archivos'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

              if (archivos.isNotEmpty) ...[
                const SizedBox(height: 10),
                ...archivos.map(
                  (file) => Card(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: ListTile(
                      leading: const Icon(Icons.insert_drive_file, color: Colors.deepPurple),
                      title: Text(file.name, style: const TextStyle(fontSize: 13)),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, color: Colors.red, size: 20),
                        onPressed: () => setState(() => archivos.remove(file)),
                      ),
                    ),
                  ),
                ),
              ],

              if (vm.error != null) ...[
                const SizedBox(height: 10),
                Text(vm.error!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
              ],

              const SizedBox(height: 24),

              // Guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: vm.creating
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          FocusScope.of(context).unfocus();

                          final agenda = await vm.crearAgenda(
                            periodoId: widget.periodoId,
                            asignacionId: widget.asignacionId,
                            titulo: tituloCtrl.text.trim(),
                            descripcion: descripcionCtrl.text.trim(),
                            tipo: tipo,
                            fechaEntrega: fechaCtrl.text.isEmpty ? null : fechaCtrl.text,
                          );

                          if (!mounted) return;

                          if (agenda != null) {
                            if (archivos.isNotEmpty) {
                              await vm.subirArchivos(agendaId: agenda.id!, archivos: archivos);
                            }
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Agenda creada correctamente')),
                            );
                            context.go(
                              '/mis-clases/${widget.periodoId}/${widget.cursoId}/${widget.paraleloId}/${widget.asignacionId}/agendas',
                            );
                          }
                        },
                  icon: const Icon(Icons.save),
                  label: vm.creating
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Guardar Agenda'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}