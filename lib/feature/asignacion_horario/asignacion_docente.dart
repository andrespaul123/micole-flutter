class AsignacionDocente {
  final int id;
  final int profesorId;
  final int subjectId;
  final int cursoId;
  final int paraleloId;

  final String profesor;
  final String materia;
  final String curso;
  final String paralelo;

  final List<HorarioAsignado> horarios;

  AsignacionDocente({
    required this.id,
    required this.profesorId,
    required this.subjectId,
    required this.cursoId,
    required this.paraleloId,
    required this.profesor,
    required this.materia,
    required this.curso,
    required this.paralelo,
    required this.horarios,
  });

  factory AsignacionDocente.fromJson(
      Map<String, dynamic> json) {
    return AsignacionDocente(
      id: json["id"],
      profesorId: json["profesor_id"],
      subjectId: json["subject_id"],
      cursoId: json["curso_id"],
      paraleloId: json["paralelo_id"],

      profesor: json["profesor"]["user"]["name"],
      materia: json["subject"]["name"],
      curso: json["curso"]["nombre"],
      paralelo: json["paralelo"]["nombre"],

      horarios: (json["horarios"] as List)
          .map((e) => HorarioAsignado.fromJson(e))
          .toList(),
    );
  }
}

class HorarioAsignado {
  final int id;
  final String dia;
  final String horaInicio;
  final String horaFin;

  HorarioAsignado({
    required this.id,
    required this.dia,
    required this.horaInicio,
    required this.horaFin,
  });

  factory HorarioAsignado.fromJson(
      Map<String, dynamic> json) {
    return HorarioAsignado(
      id: json["id"],
      dia: json["dia"],
      horaInicio: json["hora_inicio"],
      horaFin: json["hora_fin"],
    );
  }
}