import 'package:dio/dio.dart';
import '../models/inscripcion.dart';

class InscripcionRepository {
  final Dio _dio;
  InscripcionRepository(this._dio);

  Future<List<Inscripcion>> getInscripciones(int periodoId) async {
    try {
      final response =
          await _dio.get('/periodos/$periodoId/inscripciones');
      final List data =
          response.data is List ? response.data : response.data['data'] ?? [];
      return data.map((e) => Inscripcion.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) {
        print("ERROR GET INSCRIPCIONES: ${e.response?.data}");
      }
      return [];
    }
  }

  Future<String?> createInscripcion({
    required int periodoId,
    required int estudianteId,
    required int cursoId,
    required int paraleloId,
  }) async {
    try {
      await _dio.post('/periodos/$periodoId/inscripciones', data: {
        'estudiante_id': estudianteId,
        'curso_id': cursoId,
        'paralelo_id': paraleloId,
      });
      return null;
    } catch (e) {
      if (e is DioException) {
        return e.response?.data?['message']?.toString() ?? 'Error desconocido';
      }
      return 'Error desconocido';
    }
  }

  Future<bool> deleteInscripcion(int periodoId, int id) async {
    try {
      await _dio.delete('/periodos/$periodoId/inscripciones/$id');
      return true;
    } catch (e) {
      if (e is DioException) {
        print("ERROR DELETE INSCRIPCION: ${e.response?.data}");
      }
      return false;
    }
  }
}