import 'package:dio/dio.dart';
import 'asignacion.dart';
import '../estudiante/estudiante_horario/horario_curso.dart';
import 'mi_clase.dart';
import 'asignacion_docente.dart';

class AsignacionRepository {
  final Dio _dio;

  AsignacionRepository(this._dio);

  Future<Map<String, List<Asignacion>>> getHorario(
    int profesorId,
  ) async {
    final response =
        await _dio.get('/profesores/$profesorId/horario');

    final Map<String, dynamic> raw =
        response.data['horario'] ?? {};

    return raw.map((dia, lista) {
      final items = (lista as List)
          .map((e) => Asignacion.fromJson(e))
          .toList();

      return MapEntry(dia, items);
    });
  }

  Future<Map<String, List<HorarioItem>>> getHorarioCurso({
    required int periodoId,
    required int cursoId,
    required int paraleloId,
  }) async {
    final response = await _dio.get(
      '/periodos/$periodoId/cursos/$cursoId/paralelos/$paraleloId/horario',
    );

    final Map<String, dynamic> raw =
        response.data['horario'] as Map<String, dynamic>? ?? {};

    return raw.map((dia, lista) {
      final items = (lista as List)
          .map(
            (e) =>
                HorarioItem.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      return MapEntry(dia, items);
    });
  }
  
  Future<void> crearAsignacion({
  required int periodoId,
  required int profesorId,
  required int subjectId,
  required int cursoId,
  required int paraleloId,
  required String dia,
  required String horaInicio,
  required String horaFin,
}) async {
  await _dio.post(
    '/periodos/$periodoId/asignaciones',
    data: {
      'profesor_id': profesorId,
      'subject_id': subjectId,
      'curso_id': cursoId,
      'paralelo_id': paraleloId,
      'horarios': [
        {
          'dia': dia,
          'hora_inicio': horaInicio,
          'hora_fin': horaFin,
        }
      ]
    },
  );
}
  Future<List<MiClase>> getMisClases(
    int periodoId,
  ) async {
    final response = await _dio.get(
      '/periodos/$periodoId/asignaciones/mis-clases',
    );

    final List data =
        response.data['asignaciones'] ?? [];

    return data
        .map((e) => MiClase.fromJson(e))
        .toList();
  }

  Future<List<AsignacionDocente>> getAsignacionesProfesor({
  required int periodoId,
  required int profesorId,
}) async {
  final response = await _dio.get(
    '/periodos/$periodoId/asignaciones',
    queryParameters: {
      'profesor_id': profesorId,
    },
  );

  final List data = response.data as List;

  return data
      .map(
        (e) => AsignacionDocente.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList();
}

Future<void> agregarHorario({
  required int asignacionId,
  required String dia,
  required String horaInicio,
  required String horaFin,
}) async {
  await _dio.post(
    '/asignaciones/$asignacionId/horarios',
    data: {
      'dia': dia,
      'hora_inicio': horaInicio,
      'hora_fin': horaFin,
    },
  );
}
}