import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'estudiante_materia.dart';
import 'estudiante_materia_repository.dart';
import 'materia_detalle.dart';

class EstudianteMateriaViewModel
    extends ChangeNotifier {
  final EstudianteMateriaRepository repository;

  EstudianteMateriaViewModel({
    required this.repository,
  });

  bool loading = false;

  String? error;
  MateriaDetalle? detalleMateria;
  List<EstudianteMateria> materias = [];

  Future<void> loadMaterias() async {
    loading = true;

    error = null;

    notifyListeners();

    try {
      materias =
          await repository.getMaterias();
    } on DioException catch (e) {
      error =
          e.response?.data['message'] ??
          'Error al cargar materias';
    } catch (_) {
      error = 'Error inesperado';
    }

    loading = false;

    notifyListeners();
  }

  Future<void> loadDetalleMateria(
  int asignacionId,
) async {

  loading = true;
  error = null;

  notifyListeners();

  try {

    detalleMateria =
        await repository.getDetalleMateria(
      asignacionId,
    );

  } on DioException catch (e) {

    error =
        e.response?.data['message'] ??
        'Error al cargar materia';

  } catch (_) {

    error = 'Error inesperado';

  } finally {

    loading = false;

    notifyListeners();
  }
}
}