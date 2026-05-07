import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/circular_viewmodel.dart';

class CircularDetailScreen extends StatefulWidget {
  final int id;

  const CircularDetailScreen({
    super.key,
    required this.id,
  });

  @override
  State<CircularDetailScreen> createState() =>
      _CircularDetailScreenState();
}

class _CircularDetailScreenState
    extends State<CircularDetailScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
  final vm = context.read<CircularViewModel>();

  await vm.loadCircularDetail(widget.id);

  if (!(vm.selected?.leido ?? false)) {
    await vm.marcarLeido(widget.id);
  }
});
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CircularViewModel>();

    if (vm.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final c = vm.selected;

    if (c == null) {
      return const Scaffold(
        body: Center(child: Text('No encontrado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Circular'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              c.titulo ?? '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Por ${c.creadoPor ?? ''}',
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            Text(
              c.contenido ?? '',
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}