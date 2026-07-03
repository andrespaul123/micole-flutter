import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/utils/api_error_handler.dart';
import 'entrega_tarea.dart';
import 'entrega_tarea_repository.dart';

class EntregaTareaViewModel extends ChangeNotifier {
  final EntregaTareaRepository repository;
  EntregaTareaViewModel({required this.repository});

  bool loading = false;
  bool submitting = false;
  String? error;

  EntregaTarea? entrega;

  Future<void> loadEntrega(int agendaId) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      entrega = await repository.getEntrega(agendaId);
    } on DioException catch (e) {
      error = ApiErrorHandler.handle(e);
    } catch (_) {
      error = 'Error inesperado';
    }

    loading = false;
    notifyListeners();
  }

  Future<bool> entregarTarea({
    required int agendaId,
    String? comentario,
    List<PlatformFile> archivos = const [],
  }) async {
    submitting = true;
    error = null;
    notifyListeners();

    try {
      final entregaId = await repository.crearEntrega(
        agendaId: agendaId,
        comentario: comentario,
      );

      if (archivos.isNotEmpty) {
        final multipartFiles = archivos
            .map((f) => MultipartFile.fromBytes(f.bytes!, filename: f.name))
            .toList();

        await repository.subirArchivos(
          entregaId: entregaId,
          archivos: multipartFiles,
        );
      }

      await loadEntrega(agendaId);
      return true;
    } on DioException catch (e) {
      error = ApiErrorHandler.handle(e);
      return false;
    } catch (_) {
      error = 'Error inesperado';
      return false;
    } finally {
      submitting = false;
      notifyListeners();
    }
  }

  Future<void> eliminarArchivo(int archivoId, int agendaId) async {
    try {
      await repository.eliminarArchivo(archivoId);
      await loadEntrega(agendaId);
    } on DioException catch (e) {
      error = ApiErrorHandler.handle(e);
      notifyListeners();
    } catch (_) {
      error = 'Error inesperado';
      notifyListeners();
    }
  }
}