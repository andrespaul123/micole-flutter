import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../estudiante_biblioteca.dart';
import '../../estudiante_agenda/estudiante_agenda_viewmodel.dart';

class EstudianteBibliotecaScreen extends StatefulWidget {
  final int asignacionId;
  const EstudianteBibliotecaScreen({
    super.key,
    required this.asignacionId,
    
  });

  @override
  State<EstudianteBibliotecaScreen> createState() =>
      _EstudianteBibliotecaScreenState();
}

class _EstudianteBibliotecaScreenState
    extends State<EstudianteBibliotecaScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<EstudianteAgendaViewModel>().loadBiblioteca(asignacionId: widget.asignacionId);
          
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EstudianteAgendaViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Biblioteca')),
      body: Builder(
        builder: (_) {
          if (vm.loading) return const Center(child: CircularProgressIndicator());
          if (vm.error != null) return Center(child: Text(vm.error!));
          if (vm.biblioteca.isEmpty)
            return const Center(child: Text('Sin recursos disponibles'));

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: vm.biblioteca.length,
            itemBuilder: (_, index) =>
                _RecursoCard(recurso: vm.biblioteca[index]),
          );
        },
      ),
    );
  }
}

class _RecursoCard extends StatelessWidget {
  final EstudianteBiblioteca recurso;

  const _RecursoCard({required this.recurso});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recurso.titulo,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Materia: ${recurso.materia}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Profesor: ${recurso.profesor}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (recurso.descripcion.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(recurso.descripcion),
            ],
            if (recurso.archivos.isNotEmpty) ...[
              const Divider(height: 20),
              Text(
                'Archivos:',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 6),
              ...recurso.archivos.map(
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
    );
  }
}