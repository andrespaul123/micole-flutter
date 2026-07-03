class EstudianteMateria {
  final int asignacionId;
  final String materia;
  final String profesor;

  EstudianteMateria({
    required this.asignacionId,
    required this.materia,
    required this.profesor,
  });

  factory EstudianteMateria.fromJson(
    Map<String, dynamic> json,
  ) {
    return EstudianteMateria(
      asignacionId: json['asignacion_id'],
      materia: json['materia'],
      profesor: json['profesor'],
    );
  }
}