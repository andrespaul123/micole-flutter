import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/circular.dart';

class CircularRepository {
  final Dio _dio;
  CircularRepository(this._dio);

  Future<List<Circular>> getCirculares() async {
    try {
      final response = await _dio.get('/circulares');
      return (response.data as List)
          .map((e) => Circular.fromJson(e))
          .toList();
    } catch (e) {
      if (e is DioException) debugPrint('ERROR GET CIRCULARES: ${e.response?.data}');
      return [];
    }
  }
  Future<Circular?> getCircularById(int id) async {
    try {
      final response = await _dio.get('/circulares/$id');

      return Circular.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        debugPrint('ERROR DETAIL: ${e.response?.data}');
      }
      return null;
    }
  }

  Future<bool> createCircular({
    required String titulo,
    required String contenido,
    required String target,
  }) async {
    try {
      await _dio.post('/circulares', data: {
        'titulo':    titulo,
        'contenido': contenido,
        'target':    target,
      });
      return true;
    } catch (e) {
      if (e is DioException) debugPrint('ERROR CREATE CIRCULAR: ${e.response?.data}');
      return false;
    }
  }

  Future<bool> marcarLeido(int id) async {
    try {
      await _dio.post('/circulares/$id/leer');
      return true;
    } catch (e) {
      if (e is DioException) debugPrint('ERROR LEER CIRCULAR: ${e.response?.data}');
      return false;
    }
  }

  Future<bool> deleteCircular(int id) async {
    try {
      await _dio.delete('/circulares/$id');
      return true;
    } catch (e) {
      if (e is DioException) debugPrint('ERROR DELETE CIRCULAR: ${e.response?.data}');
      return false;
    }
  }
}