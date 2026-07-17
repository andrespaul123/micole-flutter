import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../agenda_viewmodel.dart';
import '../entrega_estudiante.dart';

class EntregasListScreen extends StatefulWidget {
  final int agendaId;

  const EntregasListScreen({super.key, required this.agendaId});

  @override
  State<EntregasListScreen> createState() => _EntregasListScreenState();
}

class _EntregasListScreenState extends State<EntregasListScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<AgendaViewModel>().loadEntregas(widget.agendaId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AgendaViewModel>();
    final data = vm.entregasResponse;

    final total = data?.entregas.length ?? 0;
    final entregados = data?.entregas.where((e) => e.entregado).length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(data?.titulo ?? 'Entregas'),
      ),
      body: vm.loadingEntregas
          ? const Center(child: CircularProgressIndicator())
          : vm.errorEntregas != null
              ? Center(
                  child: Text(
                    vm.errorEntregas!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : data == null || data.entregas.isEmpty
                  ? const Center(child: Text('No hay estudiantes inscritos'))
                  : Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          color: const Color(0xFFF5F7FB),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _Resumen(
                                label: 'Entregados',
                                valor: entregados,
                                color: Colors.green,
                              ),
                              _Resumen(
                                label: 'Pendientes',
                                valor: total - entregados,
                                color: Colors.orange,
                              ),
                              _Resumen(
                                label: 'Total',
                                valor: total,
                                color: Colors.deepPurple,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: data.entregas.length,
                            itemBuilder: (_, i) {
                              final e = data.entregas[i];

                              final puedeVerDetalle =
                                  e.entregado && e.entregaId != null;

                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  onTap: puedeVerDetalle
                                      ? () {
                                          context.go(
                                            '/agendas/${widget.agendaId}/entregas/${e.entregaId}',
                                          );
                                        }
                                      : null,
                                  leading: CircleAvatar(
                                    backgroundColor: e.entregado
                                        ? Colors.green.shade100
                                        : Colors.orange.shade100,
                                    child: Icon(
                                      e.entregado
                                          ? Icons.check
                                          : Icons.hourglass_empty,
                                      color: e.entregado
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                  ),
                                  title: Text(
                                    e.nombre,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (e.codigo != null)
                                        Text('Código: ${e.codigo}'),
                                      if (e.entregado && e.fechaEntrega != null)
                                        Text('Entregó: ${e.fechaEntrega}'),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Chip(
                                        label: Text(
                                          e.entregado
                                              ? 'Entregado'
                                              : 'Pendiente',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                        backgroundColor: e.entregado
                                            ? Colors.green
                                            : Colors.orange,
                                      ),
                                      if (puedeVerDetalle) ...[
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.chevron_right,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
    );
  }
}

class _Resumen extends StatelessWidget {
  final String label;
  final int valor;
  final Color color;

  const _Resumen({
    required this.label,
    required this.valor,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$valor',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}