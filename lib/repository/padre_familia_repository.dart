import 'package:dio/dio.dart';
import '../models/padre_familia.dart';

class PadreFamiliaRepository {
  final Dio _dio;
  PadreFamiliaRepository(this._dio);

  Future<List<PadreFamilia>> getPadres() async {
      final response = await _dio.get('/padre-familias');
      return (response.data as List)
          .map((e) => PadreFamilia.fromJson(e))
          .toList();
    }

  Future<PadreFamilia> createPadre({
    required String name,
    required String email,
    required String password,
    String? telefono,
    String? ocupacion,
  }) async {
   
      final response = await _dio.post('/padre-familias', data: {
        'name': name,
        'email': email,
        'password': password,
        'telefono': telefono,
        'ocupacion': ocupacion,
      });
      return PadreFamilia.fromJson(response.data['data']);
    
  }

  Future<void> deletePadre(int id) async {
    
      await _dio.delete('/padre-familias/$id');
  }
}