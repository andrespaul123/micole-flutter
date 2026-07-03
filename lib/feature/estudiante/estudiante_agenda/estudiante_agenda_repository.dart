import 'package:dio/dio.dart';
import '../../padre_agenda/padre_agenda.dart';
import '../estudiante_biblioteca/estudiante_biblioteca.dart';

class   EstudianteAgendaRepository {
  final Dio dio;

  EstudianteAgendaRepository(this.dio);

  Future<List<PadreAgenda>> getPendientes({
    String? tipo,
    int? asignacionId,
  }) async {
    final response = await dio.get(
      '/estudiante/pendientes',
      queryParameters: {
        if (asignacionId != null)
          'asignacion_id': asignacionId,
          if(tipo !=null)
          'tipo': tipo,
      },
    );

    return (response.data as List)
        .map((e) => PadreAgenda.fromJson(e))
        .toList();
  }

  Future<List<EstudianteBiblioteca>> getBiblioteca({
  int? asignacionId,
}) async {
  final response = await dio.get(
    '/estudiante/biblioteca',
    queryParameters: {
      if (asignacionId != null) 'asignacion_id': asignacionId,
    },
  );

  return (response.data as List)
      .map((e) => EstudianteBiblioteca.fromJson(e))
      .toList();
}
}