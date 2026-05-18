import 'package:dio/dio.dart';
import '../models/subject.dart';

class SubjectRepository {
  final Dio _dio;

  SubjectRepository(this._dio);

  Future<Subject> createSubject(String name) async {
      final response = await _dio.post(
        '/subjects',
        data: {
          'name': name,
        },
      );

      return Subject.fromJson(response.data);
  }

  Future<List<Subject>> getSubjects() async {
      final response = await _dio.get('/subjects');

      print("GET SUBJECTS: ${response.data}");

      return (response.data as List)
          .map((e) => Subject.fromJson(e))
          .toList();
  }
}