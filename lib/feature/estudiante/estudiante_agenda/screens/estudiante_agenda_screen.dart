import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../padre_agenda/padre_agenda.dart';
import '../estudiante_agenda_viewmodel.dart';

class EstudianteAgendaScreen extends StatefulWidget {
  final int asignacionId; 
  final String? tipo;

  const EstudianteAgendaScreen({
    super.key,
     required this.asignacionId, 
    this.tipo,
  });

  @override
  State<EstudianteAgendaScreen> createState() => _EstudianteAgendaScreenState();
}

class _EstudianteAgendaScreenState extends State<EstudianteAgendaScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context
          .read<EstudianteAgendaViewModel>()
          .loadPendientes( asignacionId: widget.asignacionId, tipo: widget.tipo,);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EstudianteAgendaViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.tipo == "examen"? "Exámenes": "Tareas",
  ),
),
      body: Builder(
        builder: (_) {
          if (vm.loading) return const Center(child: CircularProgressIndicator());
          if (vm.error != null) return Center(child: Text(vm.error!));
      if (vm.pendientes.isEmpty) { return Center(child: Text(widget.tipo == "examen" ? "Sin exámenes": "Sin tareas",
    ),
  );
}

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: vm.pendientes.length,
            itemBuilder: (_, index) {
              final agenda = vm.pendientes[index];
              final esTarea = agenda.tipo.toLowerCase() == 'tarea';

              return _AgendaCard(
                agenda: agenda,
                onTap: esTarea
    ? () {
        context.go(
          '/estudiante/materias/${widget.asignacionId}/pendientes/${agenda.id}/entrega',
          extra: agenda, // antes: agenda.titulo
        );
      }
    : null,
              );
            },
          );
        },
      ),
    );
  }
}

class _AgendaCard extends StatelessWidget {
  final PadreAgenda agenda;
  final VoidCallback? onTap;

  const _AgendaCard({
    required this.agenda,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      agenda.titulo,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Chip(
                    label: Text(agenda.tipo),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Materia: ${agenda.materia}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (agenda.fechaEntrega != null) ...[
                const SizedBox(height: 2),
                Text(
                  'Entrega: ${agenda.fechaEntrega}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.orange[700],
                      ),
                ),
              ],
              if (agenda.descripcion.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(agenda.descripcion),
              ],
              if (onTap != null) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.touch_app, size: 16, color: Colors.blue),
                    const SizedBox(width: 6),
                    Text(
                      'Toca para entregar',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
              if (agenda.archivos.isNotEmpty) ...[
              const Divider(height: 20),
              Text(
                'Archivos adjuntos:',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 6),
                ...agenda.archivos.map(
                  (archivo) => InkWell(
                    onTap: () async {
                      final uri = Uri.parse(archivo.url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.attach_file, size: 16, color: Colors.blue),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              archivo.nombreOriginal,
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
