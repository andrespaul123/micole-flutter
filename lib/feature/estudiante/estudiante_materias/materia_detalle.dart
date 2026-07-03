class HorarioMateria {
  final String dia;
  final String horaInicio;
  final String horaFin;

  HorarioMateria({
    required this.dia,
    required this.horaInicio,
    required this.horaFin,
  });

  factory HorarioMateria.fromJson(Map<String, dynamic> json) {
    return HorarioMateria(
      dia: json['dia'],
      horaInicio: json['hora_inicio'],
      horaFin: json['hora_fin'],
    );
  }
}

class MateriaDetalle {
  final int asignacionId;
  final String materia;
  final String profesor;
  final List<HorarioMateria> horarios;

  MateriaDetalle({
    required this.asignacionId,
    required this.materia,
    required this.profesor,
    required this.horarios,
  });

  factory MateriaDetalle.fromJson(Map<String, dynamic> json) {
    return MateriaDetalle(
      asignacionId: json['asignacion_id'],
      materia: json['materia'],
      profesor: json['profesor'],
      horarios: (json['horarios'] as List)
          .map((e) => HorarioMateria.fromJson(e))
          .toList(),
    );
  }
}