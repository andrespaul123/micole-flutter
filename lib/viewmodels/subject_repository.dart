import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/subject.dart';
import '../repository/subject_repository.dart';
import '../core/utils/api_error_handler.dart';

class SubjectViewModel extends ChangeNotifier {
  final SubjectRepository repository;

  bool loading = false;
  bool creating = false;
  String? error;
  List<Subject> subjects = [];

  SubjectViewModel({required this.repository});

  
  Future<bool> createSubject(String name) async {
    if (creating) return false; 
    creating = true;
    error = null;
    notifyListeners();

    try {
      final subject = await repository.createSubject(name);

      subjects.add(subject);
      return true;
    } on DioException catch (e) {
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

  // LISTAR
  Future<void> loadSubjects() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      subjects = await repository.getSubjects();
    } on DioException catch (e) {
      error = ApiErrorHandler.handle(e);
    } catch (e) {
      error = 'Error inesperado';
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
