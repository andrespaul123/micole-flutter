import 'package:flutter/material.dart';
import '../models/inscripcion.dart';
import '../models/academic_period.dart';
import '../repository/inscripcion_repository.dart';
import '../repository/academic_period_repository.dart';

class InscripcionViewModel extends ChangeNotifier {
  final InscripcionRepository repository;
  final AcademicPeriodRepository periodoRepository;

  InscripcionViewModel({
    required this.repository,
    required this.periodoRepository,
  });

  bool loading = false;
  bool creating = false;

  List<Inscripcion> inscripciones = [];
  List<AcademicPeriod> periodos = [];
  AcademicPeriod? periodoSeleccionado;

  Future<void> loadPeriodos() async {
    loading = true;
    notifyListeners();

    periodos = await periodoRepository.getPeriodos();

    // Auto-selecciona el activo, si no el primero
    if (periodos.isNotEmpty) {
      periodoSeleccionado = periodos.firstWhere(
        (p) => p.activo == true,
        orElse: () => periodos.first,
      );
      await _cargarInscripciones();
    } else {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> cambiarPeriodo(AcademicPeriod periodo) async {
    periodoSeleccionado = periodo;
    inscripciones = [];
    notifyListeners();
    await _cargarInscripciones();
  }

  Future<void> _cargarInscripciones() async {
    if (periodoSeleccionado?.id == null) return;
    loading = true;
    notifyListeners();
    inscripciones =
        await repository.getInscripciones(periodoSeleccionado!.id!);
    loading = false;
    notifyListeners();
  }

  Future<String?> createInscripcion({
    required int periodoId,
    required int estudianteId,
    required int cursoId,
    required int paraleloId,
  }) async {
    if (creating) return 'En proceso...';

    creating = true;
    notifyListeners();

    try {
      final err = await repository.createInscripcion(
        periodoId: periodoId,
        estudianteId: estudianteId,
        cursoId: cursoId,
        paraleloId: paraleloId,
      );
      if (err == null) await _cargarInscripciones();
      return err;
    } finally {
      creating = false;
      notifyListeners();
    }
  }

  Future<bool> deleteInscripcion(int id) async {
    if (periodoSeleccionado?.id == null) return false;
    loading = true;
    notifyListeners();
    final ok = await repository.deleteInscripcion(
        periodoSeleccionado!.id!, id);
    if (ok) await _cargarInscripciones();
    loading = false;
    notifyListeners();
    return ok;
  }
}