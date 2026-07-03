import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../padre_agenda/padre_agenda.dart';
import 'estudiante_agenda_repository.dart';
import '../estudiante_biblioteca/estudiante_biblioteca.dart';

class EstudianteAgendaViewModel extends ChangeNotifier {
  final EstudianteAgendaRepository repository;

  EstudianteAgendaViewModel({
    required this.repository,
  });

  bool loading = false;
List<EstudianteBiblioteca> biblioteca = [];
  String? error;

  List<PadreAgenda> pendientes = [];

  Future<void> loadPendientes({
    String? tipo,
    int? asignacionId,
  }) async {
    loading = true;
    error = null;

    notifyListeners();

    try {
      pendientes = await repository.getPendientes(
        asignacionId: asignacionId,
        tipo: tipo,
      );
    } on DioException catch (e) {
      error =
          e.response?.data["message"] ??
          "Error al cargar pendientes";
    } catch (_) {
      error = "Error inesperado";
    }

    loading = false;

    notifyListeners();
  }

  

Future<void> loadBiblioteca({
  int? asignacionId,
}) async {
  loading = true;
  error = null;
  notifyListeners();

  try {
    biblioteca = await repository.getBiblioteca(
      asignacionId: asignacionId,
    );
  } on DioException catch (e) {
    error = e.response?.data["message"] ?? "Error al cargar biblioteca";
  } catch (_) {
    error = "Error inesperado";
  }

  loading = false;
  notifyListeners();
}
}