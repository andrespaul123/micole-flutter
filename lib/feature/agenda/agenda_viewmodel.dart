// agenda_viewmodel.dart

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'agenda_repository.dart';
import 'agenda.dart';
import 'entrega_estudiante.dart';
import 'entrega_detalle_profesor.dart';

class AgendaViewModel extends ChangeNotifier {
  final AgendaRepository repository;

  AgendaViewModel({
    required this.repository,
  });

  bool loading = false;
  bool creating = false;
  bool uploading = false;
  bool replacing = false;
bool loadingDetalleEntrega = false;
String? errorDetalleEntrega;
EntregaDetalleProfesor? detalleEntrega;
  String? error;
  bool loadingEntregas = false;
  String? errorEntregas;
  EntregasResponse? entregasResponse;

  List<Agenda> agendas = [];

  Future<void> loadAgenda({
    required int periodoId,
    required int asignacionId,
  }) async {

    loading = true;

    error = null;

    notifyListeners();

    try {

      agendas = await repository.getAgenda(
        periodoId: periodoId,
        asignacionId: asignacionId,
      );

    } on DioException catch (e) {

      error =
          e.response?.data['message'] ??
          'Error al cargar agenda';

    } catch (_) {

      error = 'Error inesperado';
    }

    loading = false;

    notifyListeners();
  }

  Future<Agenda?> crearAgenda({
    required int periodoId,
    required int asignacionId,
    required String titulo,
    required String descripcion,
    required String tipo,
    String? fechaEntrega,
  }) async {

    creating = true;

    error = null;

    notifyListeners();

    try {

     final agenda = await repository.crearAgenda(
        periodoId: periodoId,
        asignacionId: asignacionId,
        titulo: titulo,
        descripcion: descripcion,
        tipo: tipo,
        fechaEntrega: fechaEntrega,
      );

      return agenda;

    } on DioException catch (e) {

      error =
          e.response?.data['message'] ??
          'Error al crear agenda';

      return null;

    } catch (_) {

      error = 'Error inesperado';

      return null;

    } finally {

      creating = false;

      notifyListeners();
    }
  }



  Future<bool> actualizarAgenda({
    required int agendaId,
    required String titulo,
    required String descripcion,
    required String tipo,
    String? fechaEntrega,
  }) async {

    creating = true;

    error = null;

    notifyListeners();

    try {

      await repository.actualizarAgenda(
        agendaId: agendaId,
        titulo: titulo,
        descripcion: descripcion,
        tipo: tipo,
        fechaEntrega: fechaEntrega,
      );

      return true;

    } on DioException catch (e) {

      error =
          e.response?.data['message'] ??
          'Error al actualizar agenda';

      return false;

    } catch (_) {

      error = 'Error inesperado';

      return false;

    } finally {

      creating = false;

      notifyListeners();
    }
  }

  Future<bool> eliminarAgenda(
    int agendaId,
  ) async {

    try {

      await repository.eliminarAgenda(
        agendaId,
      );

      agendas.removeWhere(
        (e) => e.id == agendaId,
      );

      notifyListeners();

      return true;

    } on DioException catch (e) {

      error =
          e.response?.data['message'] ??
          'Error al eliminar agenda';

      notifyListeners();

      return false;

    } catch (_) {

      error = 'Error inesperado';

      notifyListeners();

      return false;
    }
  }

  Future<bool> subirArchivos({
    required int agendaId,
    required List<PlatformFile> archivos,
  }) async {

    uploading = true;

    error = null;

    notifyListeners();

    try {

      await repository.subirArchivos(
        agendaId: agendaId,
        archivos: archivos,
      );

      return true;

    } on DioException catch (e) {

      error =
          e.response?.data['message'] ??
          'Error al subir archivos';

      return false;

    } catch (_) {

      error = 'Error inesperado';

      return false;

    } finally {

      uploading = false;

      notifyListeners();
    }
  }

  Future<bool> eliminarArchivo(
    int archivoId,
  ) async {

    try {

      await repository.eliminarArchivo(
        archivoId,
      );

      return true;

    } on DioException catch (e) {

      error =
          e.response?.data['message'] ??
          'Error al eliminar archivo';

      notifyListeners();

      return false;

    } catch (_) {

      error = 'Error inesperado';

      notifyListeners();

      return false;
    }
  }


  Future<bool> reemplazarArchivo({
    required int archivoId,
    required PlatformFile archivo,
  }) async {

    replacing = true;

    error = null;

    notifyListeners();

    try {

      await repository.reemplazarArchivo(
        archivoId: archivoId,
        archivo: archivo,
      );

      return true;

    } on DioException catch (e) {

      error =
          e.response?.data['message'] ??
          'Error al reemplazar archivo';

      return false;

    } catch (_) {

      error = 'Error inesperado';

      return false;

    } finally {

      replacing = false;

      notifyListeners();
    }
  }
  // ENTREGAS
  // ==========================================
  Future<void> loadEntregas(
    int agendaId,
  ) async {
    loadingEntregas = true;

    errorEntregas = null;

    notifyListeners();

    try {
      entregasResponse = await repository.getEntregas(agendaId);
    } on DioException catch (e) {
      errorEntregas = e.response?.data['message'] ?? 'Error al cargar entregas';
    } catch (_) {
      errorEntregas = 'Error inesperado';
    }

    loadingEntregas = false;

    notifyListeners();
  }
  Future<void> loadDetalleEntrega(
  int entregaId,
) async {
  loadingDetalleEntrega = true;

  errorDetalleEntrega = null;

  notifyListeners();

  try {
    detalleEntrega = await repository.getDetalleEntrega(entregaId);
  } on DioException catch (e) {
    errorDetalleEntrega =
        e.response?.data['message'] ?? 'Error al cargar la entrega';
  } catch (_) {
    errorDetalleEntrega = 'Error inesperado';
  }

  loadingDetalleEntrega = false;

  notifyListeners();
}
}