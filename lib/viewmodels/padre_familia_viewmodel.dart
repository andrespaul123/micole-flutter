import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../core/utils/api_error_handler.dart';
import '../models/padre_familia.dart';
import '../repository/padre_familia_repository.dart';

class PadreFamiliaViewModel extends ChangeNotifier {
  final PadreFamiliaRepository repository;
  PadreFamiliaViewModel({required this.repository});

  bool loading = false;
  bool creating = false;
  String? error;
  List<PadreFamilia> padres = [];

  Future<void> loadPadres() async {
    loading = true;
    error = null;
    notifyListeners();
    try{
         padres = await repository.getPadres();
    }on DioException catch (e){
      error = ApiErrorHandler.handle(e);
    }catch(e){
      error = 'Error inesperado';
    }
    finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> createPadre({
    required String name,
    required String email,
    required String password,
    String? telefono,
    String? ocupacion,
  }) async {
    if(creating) return false;

    creating = true;
    error = null;
    notifyListeners();
    try {
      final padre = await repository.createPadre(
        name: name, email: email, password: password,
        telefono: telefono, ocupacion: ocupacion,
      );
      padres.add(padre);
      return true;
      }on DioException catch (e) {
        error = ApiErrorHandler.handle(e);
        return false;
      } catch (e) {
        error = 'Error inesperado';
        return false;
       
    } finally {
      creating = false;
      notifyListeners();
    }
  }

  Future<bool> deletePadre(int id) async {
    loading = true;
      error = null;
    notifyListeners();
    try{
     await repository.deletePadre(id);
      padres.removeWhere((p) => p.id == id);
      return true;
    }on DioException catch (e) {
      error = ApiErrorHandler.handle(e);
      return false;
    } catch (e) {
      error = 'Error inesperado';
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
    