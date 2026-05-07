import 'package:flutter/material.dart';
import '../models/circular.dart';
import '../repository/circular_repository.dart';

class CircularViewModel extends ChangeNotifier {
  final CircularRepository repository;
  CircularViewModel({required this.repository});

  bool loading  = false;
  bool creating = false;
  List<Circular> circulares = [];
   Circular? selected;

  Future<void> loadCirculares() async {
    loading = true;
    notifyListeners();
    circulares = await repository.getCirculares();
    loading = false;
    notifyListeners();
  }
  Future<void> loadCircularDetail(int id) async {
    loading = true;
    notifyListeners();

    selected = await repository.getCircularById(id);

    loading = false;
    notifyListeners();
  }


  Future<bool> createCircular({
    required String titulo,
    required String contenido,
    required String target,
  }) async {
    if (creating) return false;
    creating = true;
    notifyListeners();
    try {
      final success = await repository.createCircular(
        titulo: titulo, contenido: contenido, target: target,
      );
      if (success) await loadCirculares();
      return success;
    } finally {
      creating = false;
      notifyListeners();
    }
  }

  Future<bool> marcarLeido(int id) async {
    final success = await repository.marcarLeido(id);
    if (success) {
      // Actualización optimista
      final idx = circulares.indexWhere((c) => c.id == id);
      if (idx != -1) {
        circulares[idx] = Circular(
          id:          circulares[idx].id,
          titulo:      circulares[idx].titulo,
          contenido:   circulares[idx].contenido,
          target:      circulares[idx].target,
          publishedAt: circulares[idx].publishedAt,
          leido:       true,
          creadoPor:   circulares[idx].creadoPor,
        );
        notifyListeners();
      }
    }
    return success;
  }

  Future<bool> deleteCircular(int id) async {
    loading = true;
    notifyListeners();
    final success = await repository.deleteCircular(id);
    if (success) await loadCirculares();
    loading = false;
    notifyListeners();
    return success;
  }
}