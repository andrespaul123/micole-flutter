import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../agenda_viewmodel.dart';

class EntregaDetalleProfesorScreen extends StatefulWidget {
  final int entregaId;

  const EntregaDetalleProfesorScreen({super.key, required this.entregaId});

  @override
  State<EntregaDetalleProfesorScreen> createState() =>
      _EntregaDetalleProfesorScreenState();
}

class _EntregaDetalleProfesorScreenState
    extends State<EntregaDetalleProfesorScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<AgendaViewModel>().loadDetalleEntrega(widget.entregaId);
    });
  }

  Future<void> abrirArchivo(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AgendaViewModel>();
    final entrega = vm.detalleEntrega;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de entrega')),
      body: vm.loadingDetalleEntrega
          ? const Center(child: CircularProgressIndicator())
          : vm.errorDetalleEntrega != null
              ? Center(
                  child: Text(
                    vm.errorDetalleEntrega!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : entrega == null
                  ? const Center(child: Text('No se encontró la entrega'))
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entrega.nombreEstudiante,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (entrega.codigoEstudiante != null)
                                  Text(
                                    'Código: ${entrega.codigoEstudiante}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                const SizedBox(height: 12),
                                Chip(
                                  label: Text(
                                    entrega.estado == 'entregado'
                                        ? 'Entregado'
                                        : 'Pendiente',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: entrega.estado == 'entregado'
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                                if (entrega.fechaEntrega != null) ...[
                                  const SizedBox(height: 8),
                                  Text('Fecha de entrega: ${entrega.fechaEntrega}'),
                                ],
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        if (entrega.comentario != null &&
                            entrega.comentario!.isNotEmpty) ...[
                          const Text(
                            'Comentario del estudiante',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(entrega.comentario!),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        const Text(
                          'Archivos',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),

                        if (entrega.archivos.isEmpty)
                          const Text('No se adjuntaron archivos')
                        else
                          ...entrega.archivos.map(
                            (archivo) => Card(
                              child: ListTile(
                                leading: const Icon(Icons.insert_drive_file),
                                title: Text(archivo.nombreOriginal),
                                trailing: IconButton(
                                  icon: const Icon(Icons.download),
                                  onPressed: () => abrirArchivo(archivo.url),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
    );
  }
}