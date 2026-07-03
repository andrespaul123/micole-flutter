import 'package:dio/dio.dart';

import 'estudiante_materia.dart';
import 'materia_detalle.dart';

class EstudianteMateriaRepository {
  final Dio dio;

  EstudianteMateriaRepository(this.dio);

  Future<List<EstudianteMateria>>
      getMaterias() async {
    final response = await dio.get(
      '/estudiante/materias',
    );

    return (response.data as List)
        .map(
          (e) => EstudianteMateria.fromJson(e),
        )
        .toList();
  }

  Future<MateriaDetalle> getDetalleMateria(
  int asignacionId,
) async {

  final response = await dio.get(
    '/estudiante/materias/$asignacionId',
  );

  return MateriaDetalle.fromJson(
    response.data,
  );
}


}