import 'package:dio/dio.dart';
import 'entrega_tarea.dart';

class EntregaTareaRepository {
  final Dio dio;
  EntregaTareaRepository(this.dio);

  Future<EntregaTarea?> getEntrega(int agendaId) async {
    final response = await dio.get('/estudiante/tareas/$agendaId/entrega');
    if (response.data == null) return null;
    return EntregaTarea.fromJson(response.data);
  }

  Future<int> crearEntrega({
    required int agendaId,
    String? comentario,
  }) async {
    final response = await dio.post(
      '/estudiante/tareas/$agendaId/entrega',
      data: {
        if (comentario != null) 'comentario': comentario,
      },
    );
    return response.data['id'];
  }

  Future<List<EntregaTareaArchivo>> subirArchivos({
  required int entregaId,
  required List<MultipartFile> archivos,
}) async {
  final formData = FormData();

  for (final file in archivos) {
    formData.files.add(
      MapEntry('archivos[]', file),
    );
  }

  final response = await dio.post(
    '/estudiante/entregas/$entregaId/archivos',
    data: formData,
  );

  return (response.data['archivos'] as List)
      .map((e) => EntregaTareaArchivo.fromJson(e))
      .toList();
}

  Future<void> eliminarArchivo(int archivoId) async {
    await dio.delete('/estudiante/entrega-archivos/$archivoId');
  }
}